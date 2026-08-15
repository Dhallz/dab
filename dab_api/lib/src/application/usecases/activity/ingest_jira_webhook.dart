import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/jira_scope.dart';
import '../../../domain/dtos/jira/jira_issue_dto.dart';
import '../../../domain/dtos/jira/jira_issue_mapping.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/websockets/presence_service.dart';
import '../../services/activity_live_publisher.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests Jira Cloud webhooks into the DAB live pipeline.
/// CONTRACT: Handles `jira:issue_created` / `jira:issue_updated` and
/// `comment_created` / `comment_updated`. Persisted rows match polling
/// ([OnJiraIssueDto.toActivities]) shaping. Attribution is identity-based
/// (`provider_id: jira` linked rows); unmapped comment authors fall back to
/// the issue owner.
/// CONSTRAINTS: Read-only toward Jira; dedupe on event + issue + comment id.
class IngestJiraWebhook {
  final IUserRepository _userRepository;
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final RedisService _redisService;
  final PresenceService _presenceService;
  final ActivityLivePublisher? _livePublisher;

  IngestJiraWebhook(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._redisService,
    this._presenceService, {
    ActivityLivePublisher? livePublisher,
  }) : _livePublisher = livePublisher;

  static const _issueEvents = {'jira:issue_created', 'jira:issue_updated'};
  static const _commentEvents = {'comment_created', 'comment_updated'};

  Future<Either<Failure, JiraWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
  }) async {
    final event = (payload['webhookEvent'] ?? '').toString().trim();
    final isCommentEvent = _commentEvents.contains(event);
    if (!_issueEvents.contains(event) && !isCommentEvent) {
      return Right(
        JiraWebhookIngestionResult.ignored('unsupported_event:$event'),
      );
    }

    final issue = payload['issue'];
    if (issue is! Map<String, dynamic>) {
      return const Right(JiraWebhookIngestionResult.ignored('missing_issue'));
    }
    final issueKey = (issue['key'] ?? '').toString().trim();
    if (issueKey.isEmpty) {
      return const Right(
        JiraWebhookIngestionResult.ignored('invalid_issue_payload'),
      );
    }
    final fieldsRaw = issue['fields'];
    final fields = fieldsRaw is Map<String, dynamic>
        ? fieldsRaw
        : <String, dynamic>{};
    if (fields.isEmpty && !isCommentEvent) {
      return const Right(
        JiraWebhookIngestionResult.ignored('invalid_issue_payload'),
      );
    }

    final commentRaw = payload['comment'];
    final hasComment = commentRaw is Map<String, dynamic>;
    final commentId = hasComment
        ? (commentRaw['id'] ?? '').toString().trim()
        : '';
    final commentOnly = isCommentEvent || (hasComment && commentId.isNotEmpty);

    final updatedAt =
        _parseJiraDateTime(fields['updated']) ??
        (hasComment
            ? _parseJiraDateTime(commentRaw['updated']) ??
                  _parseJiraDateTime(commentRaw['created'])
            : null) ??
        _parseJiraDateTime(payload['timestamp']);
    if (updatedAt == null) {
      return const Right(
        JiraWebhookIngestionResult.ignored('missing_updated_timestamp'),
      );
    }

    final fingerprint =
        '$event|$issueKey|${updatedAt.millisecondsSinceEpoch}'
        '${commentId.isEmpty ? '' : '|comment|$commentId'}';
    final reserved = await _redisService.reserveIngestionEventId(
      'jira',
      fingerprint,
    );
    if (!reserved) {
      return const Right(
        JiraWebhookIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final jiraConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'jira' && config.isActive,
        )
        .firstOrNull;
    if (jiraConfig == null) {
      return const Right(
        JiraWebhookIngestionResult.ignored('jira_not_configured'),
      );
    }

    var host = normalizeJiraCloudHost(jiraConfig.baseUrl);
    if (host.isEmpty) {
      final selfUrl = (issue['self'] ?? '').toString();
      host = normalizeJiraCloudHost(selfUrl);
    }
    if (host.isEmpty) {
      return const Right(JiraWebhookIngestionResult.ignored('missing_host'));
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(JiraWebhookIngestionResult.ignored('no_users_found'));
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'jira');
    final accountToUser = <String, String>{};
    for (final identity in identitiesResult.getOrElse((_) => const [])) {
      if (identity.status != UserIdentityStatus.linked) continue;
      final key = identity.externalId.trim();
      if (key.isEmpty) continue;
      accountToUser.putIfAbsent(key, () => identity.userId);
    }
    if (accountToUser.isEmpty) {
      return const Right(
        JiraWebhookIngestionResult.ignored('no_linked_jira_identities'),
      );
    }

    final assignee = fields['assignee'];
    final reporter = fields['reporter'];
    final creator = fields['creator'];
    final dabUserId = _firstMatchedUserId(accountToUser, [
      jiraPersonAccountId(assignee),
      jiraPersonAccountId(reporter),
      jiraPersonAccountId(creator),
    ]);

    final comments = <JiraIssueCommentDto>[];
    if (hasComment && commentId.isNotEmpty) {
      final author = commentRaw['author'];
      final authorAccountId = jiraPersonAccountId(author);
      final commentUserId = authorAccountId == null
          ? null
          : accountToUser[authorAccountId];
      final createdAt =
          _parseJiraDateTime(commentRaw['created']) ??
          _parseJiraDateTime(commentRaw['updated']) ??
          updatedAt;
      comments.add(
        JiraIssueCommentDto(
          id: commentId,
          body: _extractCommentBody(commentRaw['body']),
          createdAt: createdAt,
          dabUserId: commentUserId,
          authorDisplayName: pickJiraPersonDisplay(author),
        ),
      );
    }

    if (dabUserId == null &&
        comments.every((c) => (c.dabUserId ?? '').isEmpty)) {
      return const Right(
        JiraWebhookIngestionResult.ignored('no_attributable_users'),
      );
    }

    final project = fields['project'];
    final projectKey = project is Map<String, dynamic>
        ? (project['key'] ?? '').toString().trim()
        : '';

    final watchedProjects = parseJiraProjectKeys(
      jiraConfig.settings['projectKeys'],
    );
    if (watchedProjects.isNotEmpty &&
        projectKey.isNotEmpty &&
        !watchedProjects.contains(projectKey)) {
      return const Right(
        JiraWebhookIngestionResult.ignored('project_not_watched'),
      );
    }

    final dto = JiraIssueDto(
      issueKey: issueKey,
      projectKey: projectKey.isEmpty ? 'UNKNOWN' : projectKey,
      summary: (fields['summary'] ?? '').toString(),
      statusName: extractJiraEmbeddedName(fields['status']),
      browseUrl: 'https://$host/browse/$issueKey',
      updatedAt: updatedAt,
      siteHost: host,
      dabUserId: dabUserId,
      authorDisplayName:
          pickJiraPersonDisplay(assignee) ??
          pickJiraPersonDisplay(reporter) ??
          pickJiraPersonDisplay(creator),
      comments: comments,
      includeIssueSnapshot: !commentOnly,
    );

    final activities = dto.toActivities(users);
    if (activities.isEmpty) {
      return const Right(
        JiraWebhookIngestionResult.ignored('no_eligible_activities'),
      );
    }

    var ingestedCount = 0;
    for (final activity in activities) {
      final createResult = await _activityRepository.createActivity(activity);
      if (createResult.isLeft()) {
        final message = createResult
            .getLeft()
            .toNullable()!
            .message
            .toLowerCase();
        if (_isDuplicateViolation(message)) {
          continue;
        }
        return Left(createResult.getLeft().toNullable()!);
      }
      ingestedCount++;
      await ActivityLivePublisher.emit(
        redis: _redisService,
        presence: _presenceService,
        activity: activity,
        publisher: _livePublisher,
      );
      print(
        '[JIRA_WEBHOOK] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
      );
    }

    if (ingestedCount == 0) {
      return const Right(
        JiraWebhookIngestionResult.ignored('duplicate_activity'),
      );
    }
    await _redisService.recordLiveIngestSuccess('jira');
    return const Right(JiraWebhookIngestionResult.ingested());
  }

  /// Jira Cloud webhooks may deliver comment bodies as plain strings (REST v2
  /// shape) or as ADF nodes (REST v3 shape); both are normalized to text.
  String _extractCommentBody(Object? body) {
    if (body is String) return body.trim();
    return extractJiraCommentText(body);
  }

  /// Accepts ISO-8601 (`…+0000` or `…+00:00`) and unix-ms webhook timestamps.
  DateTime? _parseJiraDateTime(Object? raw) {
    if (raw == null) return null;
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw, isUtc: true);
    }
    if (raw is num) {
      return DateTime.fromMillisecondsSinceEpoch(raw.toInt(), isUtc: true);
    }
    var text = raw.toString().trim();
    if (text.isEmpty) return null;
    final asInt = int.tryParse(text);
    if (asInt != null && text.length >= 12) {
      return DateTime.fromMillisecondsSinceEpoch(asInt, isUtc: true);
    }
    text = text.replaceFirstMapped(
      RegExp(r'([+-]\d{2})(\d{2})$'),
      (m) => '${m[1]}:${m[2]}',
    );
    return DateTime.tryParse(text)?.toUtc();
  }

  static String? _firstMatchedUserId(
    Map<String, String> accountToUser,
    List<String?> candidateAccountIds,
  ) {
    for (final aid in candidateAccountIds) {
      if (aid == null || aid.isEmpty) continue;
      final dab = accountToUser[aid];
      if (dab != null && dab.isNotEmpty) return dab;
    }
    return null;
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}

/// Outcome envelope for Jira webhook processing (parity with Slack/GitHub).
class JiraWebhookIngestionResult {
  final bool ingested;
  final String reason;

  const JiraWebhookIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const JiraWebhookIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const JiraWebhookIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
