import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/linear/linear_issue_dto.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/sources/linear/linear_issue_source.dart';
import '../../../infrastructure/websockets/presence_service.dart';
import '../../services/activity_live_publisher.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests Linear webhooks into the DAB live pipeline.
/// CONTRACT: Handles `Issue` create/update events; payloads carry the full
/// model, so no API callback is needed. Rows are shaped identically to
/// polling via [mapLinearIssueNode] + [OnLinearIssueDto.toActivities].
/// CONSTRAINTS: Read-only toward Linear; dedupe on delivery id (fallback:
/// identifier + updatedAt).
class IngestLinearWebhook {
  final IUserRepository _userRepository;
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final RedisService _redisService;
  final PresenceService _presenceService;
  final ActivityLivePublisher? _livePublisher;

  IngestLinearWebhook(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._redisService,
    this._presenceService, {
    ActivityLivePublisher? livePublisher,
  }) : _livePublisher = livePublisher;

  static const _supportedActions = {'create', 'update'};

  Future<Either<Failure, LinearWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
    String? deliveryId,
  }) async {
    final type = (payload['type'] ?? '').toString().trim();
    if (type != 'Issue') {
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

    final identifier = (data['identifier'] ?? '').toString().trim();
    final updatedRaw = data['updatedAt']?.toString() ?? '';
    final fingerprint = (deliveryId ?? '').trim().isNotEmpty
        ? deliveryId!.trim()
        : '$action|$identifier|$updatedRaw';
    final reserved = await _redisService.reserveIngestionEventId(
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

    // Webhook `data` sometimes carries plain `assigneeId`/`creatorId` instead
    // of expanded person nodes; normalize before mapping.
    final node = Map<String, dynamic>.from(data);
    if (node['assignee'] is! Map<String, dynamic> &&
        node['assigneeId'] != null) {
      node['assignee'] = {'id': node['assigneeId']};
    }
    if (node['creator'] is! Map<String, dynamic> && node['creatorId'] != null) {
      node['creator'] = {'id': node['creatorId']};
    }
    if ((node['url'] ?? '').toString().trim().isEmpty &&
        payload['url'] != null) {
      node['url'] = payload['url'];
    }

    final dto = mapLinearIssueNode(node, externalToUser);
    if (dto == null) {
      return const Right(
        LinearWebhookIngestionResult.ignored('invalid_issue_payload'),
      );
    }
    if (dto.dabUserId == null) {
      return const Right(
        LinearWebhookIngestionResult.ignored('no_attributable_users'),
      );
    }

    final activities = dto.toActivities(users);
    if (activities.isEmpty) {
      return const Right(
        LinearWebhookIngestionResult.ignored('no_eligible_activities'),
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
        '[LINEAR_WEBHOOK] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
      );
    }

    if (ingestedCount == 0) {
      return const Right(
        LinearWebhookIngestionResult.ignored('duplicate_activity'),
      );
    }
    await _redisService.recordLiveIngestSuccess('linear');
    return const Right(LinearWebhookIngestionResult.ingested());
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}

/// Outcome envelope for Linear webhook processing (parity with Slack/GitHub).
class LinearWebhookIngestionResult {
  final bool ingested;
  final String reason;

  const LinearWebhookIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const LinearWebhookIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const LinearWebhookIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
