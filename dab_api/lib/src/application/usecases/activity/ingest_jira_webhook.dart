import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/jira_scope.dart';
import '../../../domain/core/live_inbox_targets.dart';
import '../../../domain/dtos/jira/jira_issue_dto.dart';
import '../../../domain/dtos/jira/jira_issue_mapping.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../../domain/contracts/ports/abs_i_presence_broadcaster.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import '../../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';
import '../../services/activity_live_publisher.dart';
import '../../services/live_ingest_persister.dart';
import 'inbox_followers.dart';
import 'ingestion_result.dart';

export 'ingestion_result.dart';

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
  final AbsIProviderConfigRepository _providerConfigRepository;
  final AbsILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;
  final AbsIActivityFollowRepository? _follows;

  IngestJiraWebhook(
    this._userRepository,
    AbsIActivityRepository activityRepository,
    this._providerConfigRepository,
    this._liveFeed,
    AbsIPresenceBroadcaster presence, {
    ActivityLivePublisher? livePublisher,
    LiveIngestPersister? persister,
    AbsIActivityFollowRepository? follows,
  }) : _follows = follows,
       _persister =
           persister ??
           LiveIngestPersister(
             activities: activityRepository,
             liveFeed: _liveFeed,
             presence: presence,
             livePublisher: livePublisher,
           );

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
    final reserved = await _liveFeed.reserveIngestionEventId(
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

    var host = jiraConfig.baseUrl.normalizeJiraCloudHost();
    if (host.isEmpty) {
      final selfUrl = (issue['self'] ?? '').toString();
      host = selfUrl.normalizeJiraCloudHost();
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

    final comments = <JiraIssueCommentDto>[];
    String? commentSenderUserId;
    Object? commentBodyRaw;
    if (hasComment && commentId.isNotEmpty) {
      final author = commentRaw['author'];
      final authorAccountId = jiraPersonAccountId(author);
      commentSenderUserId = authorAccountId == null
          ? null
          : accountToUser[authorAccountId];
      commentBodyRaw = commentRaw['body'];
      final createdAt =
          _parseJiraDateTime(commentRaw['created']) ??
          _parseJiraDateTime(commentRaw['updated']) ??
          updatedAt;
      comments.add(
        JiraIssueCommentDto(
          id: commentId,
          body: _extractCommentBody(commentBodyRaw),
          createdAt: createdAt,
          dabUserId: commentSenderUserId,
          authorDisplayName: pickJiraPersonDisplay(author),
        ),
      );
    }

    final project = fields['project'];
    final projectKey = project is Map<String, dynamic>
        ? (project['key'] ?? '').toString().trim()
        : '';

    final watchedProjects = (jiraConfig.settings['projectKeys'] as Object?).parseJiraProjectKeys();
    if (watchedProjects.isNotEmpty &&
        projectKey.isNotEmpty &&
        !watchedProjects.contains(projectKey)) {
      return const Right(
        JiraWebhookIngestionResult.ignored('project_not_watched'),
      );
    }

    final actorAccountId = hasComment
        ? jiraPersonAccountId(commentRaw['author'])
        : jiraPersonAccountId(payload['user']) ?? jiraPersonAccountId(creator);
    final senderUserId = actorAccountId == null
        ? commentSenderUserId
        : accountToUser[actorAccountId];

    Set<String> inboxTargets;
    final commentOnlyRow = commentOnly && comments.isNotEmpty;
    if (commentOnlyRow) {
      inboxTargets = liveInboxTargets(
        externalIds: extractJiraMentionAccountIds(commentBodyRaw),
        externalToUser: accountToUser,
      );
    } else {
      inboxTargets = liveInboxTargets(
        externalIds: extractJiraAssigneeBecameAccountIds(payload['changelog']),
        externalToUser: accountToUser,
      );
    }
    final followers = await inboxFollowerUserIds(
      _follows,
      providerId: 'jira',
      objectKeys: [issueKey],
    );
    if (inboxTargets.isEmpty && followers.isEmpty) {
      return const Right(
        JiraWebhookIngestionResult.ignored('no_target_mentions'),
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
      dabUserId: senderUserId,
      authorDisplayName:
          pickJiraPersonDisplay(assignee) ??
          pickJiraPersonDisplay(reporter) ??
          pickJiraPersonDisplay(creator),
      comments: comments,
      includeIssueSnapshot: !commentOnlyRow,
    );

    final activities = dto.toActivities(
      users,
      forUserIds: inboxTargets,
      followerUserIds: followers,
      senderUserId: senderUserId,
    );
    if (activities.isEmpty) {
      return const Right(
        JiraWebhookIngestionResult.ignored('no_eligible_activities'),
      );
    }

    return _persister.persist(
      activities: activities,
      providerId: 'jira',
      emptyReason: 'duplicate_activity',
      logTag: 'JIRA_WEBHOOK',
    );
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
}
