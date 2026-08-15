import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/linear/linear_issue_dto.dart';
import '../../../domain/dtos/linear/linear_issue_mapping.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/ports/i_live_feed_store.dart';
import '../../../domain/ports/i_presence_broadcaster.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../services/activity_live_publisher.dart';
import '../../services/live_ingest_persister.dart';
import 'ingestion_result.dart';

export 'ingestion_result.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests Linear webhooks into the DAB live pipeline.
/// CONTRACT: Handles `Issue` and `Comment` create/update events. Issue
/// snapshots and comments are distinct activity rows that share
/// [LinearIssueProvider.identifier] so Explorer groups them like Phorge,
/// while Dashboard live-publishes each new id. Payloads carry the model;
/// no API callback is needed.
/// CONSTRAINTS: Read-only toward Linear; dedupe on delivery id (fallback:
/// identifier + updatedAt / comment id).
class IngestLinearWebhook {
  final IUserRepository _userRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final ILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;

  IngestLinearWebhook(
    this._userRepository,
    AbsIActivityRepository activityRepository,
    this._providerConfigRepository,
    this._liveFeed,
    IPresenceBroadcaster presence, {
    ActivityLivePublisher? livePublisher,
    LiveIngestPersister? persister,
  }) : _persister =
           persister ??
           LiveIngestPersister(
             activities: activityRepository,
             liveFeed: _liveFeed,
             presence: presence,
             livePublisher: livePublisher,
           );

  static const _supportedTypes = {'Issue', 'Comment'};
  static const _supportedActions = {'create', 'update'};

  Future<Either<Failure, LinearWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
    String? deliveryId,
  }) async {
    final type = (payload['type'] ?? '').toString().trim();
    if (!_supportedTypes.contains(type)) {
      return Right(
        LinearWebhookIngestionResult.ignored('unsupported_type:$type'),
      );
    }
    final action = (payload['action'] ?? '').toString().trim();
    if (!_supportedActions.contains(action)) {
      return Right(
        LinearWebhookIngestionResult.ignored('unsupported_action:$action'),
      );
    }

    final data = payload['data'];
    if (data is! Map<String, dynamic>) {
      return const Right(LinearWebhookIngestionResult.ignored('missing_data'));
    }

    final isComment = type == 'Comment';
    final issueNode = isComment
        ? _issueNodeFromComment(payload, data)
        : _issueNodeFromIssue(payload, data);
    if (issueNode == null) {
      return const Right(
        LinearWebhookIngestionResult.ignored('invalid_issue_payload'),
      );
    }

    final identifier = (issueNode['identifier'] ?? '').toString().trim();
    final updatedRaw = issueNode['updatedAt']?.toString() ?? '';
    final commentId = isComment ? (data['id'] ?? '').toString().trim() : '';
    final fingerprint = (deliveryId ?? '').trim().isNotEmpty
        ? deliveryId!.trim()
        : isComment
        ? '$action|comment|$commentId|$updatedRaw'
        : '$action|$identifier|$updatedRaw';
    final reserved = await _liveFeed.reserveIngestionEventId(
      'linear',
      fingerprint,
    );
    if (!reserved) {
      return const Right(
        LinearWebhookIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final linearConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'linear' && config.isActive,
        )
        .firstOrNull;
    if (linearConfig == null) {
      return const Right(
        LinearWebhookIngestionResult.ignored('linear_not_configured'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(
        LinearWebhookIngestionResult.ignored('no_users_found'),
      );
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'linear');
    final externalToUser = <String, String>{};
    for (final identity in identitiesResult.getOrElse((_) => const [])) {
      if (identity.status != UserIdentityStatus.linked) continue;
      final key = identity.externalId.trim();
      if (key.isEmpty) continue;
      externalToUser.putIfAbsent(key, () => identity.userId);
    }
    if (externalToUser.isEmpty) {
      return const Right(
        LinearWebhookIngestionResult.ignored('no_linked_linear_identities'),
      );
    }

    var comments = const <LinearIssueCommentDto>[];
    if (isComment) {
      final commentNode = Map<String, dynamic>.from(data);
      if (commentNode['user'] is! Map<String, dynamic>) {
        final actor = payload['actor'];
        if (actor is Map<String, dynamic>) {
          commentNode['user'] = actor;
        } else if (commentNode['userId'] != null) {
          commentNode['user'] = {'id': commentNode['userId']};
        }
      }
      final mapped = mapLinearCommentNode(commentNode, externalToUser);
      if (mapped == null || commentId.isEmpty) {
        return const Right(
          LinearWebhookIngestionResult.ignored('invalid_comment_payload'),
        );
      }
      comments = [mapped];
    }

    final dto = mapLinearIssueNode(issueNode, externalToUser);
    if (dto == null) {
      return const Right(
        LinearWebhookIngestionResult.ignored('invalid_issue_payload'),
      );
    }

    final watchedTeams = parseLinearTeamKeys(linearConfig.settings['teamKeys']);
    if (watchedTeams.isNotEmpty && !watchedTeams.contains(dto.teamKey)) {
      return const Right(
        LinearWebhookIngestionResult.ignored('team_not_watched'),
      );
    }

    // Comment webhooks omit the issue snapshot so Dashboard gets one ping
    // (the comment). Unmapped authors fall back to the issue owner.
    final hydrated = isComment
        ? dto.copyWith(includeIssueSnapshot: false, comments: comments)
        : dto.copyWith(comments: comments);

    if (hydrated.dabUserId == null &&
        hydrated.comments.every((c) => (c.dabUserId ?? '').isEmpty)) {
      return const Right(
        LinearWebhookIngestionResult.ignored('no_attributable_users'),
      );
    }

    final activities = hydrated.toActivities(users);
    if (activities.isEmpty) {
      return const Right(
        LinearWebhookIngestionResult.ignored('no_eligible_activities'),
      );
    }

    return _persister.persist(
      activities: activities,
      providerId: 'linear',
      emptyReason: 'duplicate_activity',
      logTag: 'LINEAR_WEBHOOK',
    );
  }

  Map<String, dynamic>? _issueNodeFromIssue(
    Map<String, dynamic> payload,
    Map<String, dynamic> data,
  ) {
    final node = Map<String, dynamic>.from(data);
    _normalizePerson(node, 'assignee', 'assigneeId');
    _normalizePerson(node, 'creator', 'creatorId');
    if ((node['url'] ?? '').toString().trim().isEmpty &&
        payload['url'] != null) {
      node['url'] = payload['url'];
    }
    return node;
  }

  Map<String, dynamic>? _issueNodeFromComment(
    Map<String, dynamic> payload,
    Map<String, dynamic> data,
  ) {
    final issueRaw = data['issue'];
    if (issueRaw is! Map<String, dynamic>) return null;
    final node = Map<String, dynamic>.from(issueRaw);
    _normalizePerson(node, 'assignee', 'assigneeId');
    _normalizePerson(node, 'creator', 'creatorId');
    if ((node['url'] ?? '').toString().trim().isEmpty) {
      node['url'] = data['url'] ?? payload['url'];
    }
    if (node['updatedAt'] == null) {
      node['updatedAt'] =
          data['createdAt'] ?? data['updatedAt'] ?? payload['createdAt'];
    }
    return node;
  }

  void _normalizePerson(
    Map<String, dynamic> node,
    String objectKey,
    String idKey,
  ) {
    if (node[objectKey] is! Map<String, dynamic> && node[idKey] != null) {
      node[objectKey] = {'id': node[idKey]};
    }
  }
}
