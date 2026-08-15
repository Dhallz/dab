import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/ports/i_phorge_task_hydrator.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/websockets/presence_service.dart';
import '../../services/activity_live_publisher.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests Phorge Herald webhooks into the DAB live pipeline.
/// CONTRACT: Herald payloads carry only object/transaction PHIDs, so the task
/// is re-hydrated via Conduit ([IPhorgeTaskHydrator.fetchBundleForWebhook]) and
/// mapped through the same [OnPhorgeTaskBundleDto.toActivities] shaping as
/// polling. Only transactions authored by users with a known `phorgePhid` are
/// persisted (no fallback attribution on the live path).
/// CONSTRAINTS: Read-only toward Phorge; dedupe by object+transaction PHIDs.
class IngestPhorgeWebhook {
  final IUserRepository _userRepository;
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final IPhorgeTaskHydrator _taskHydrator;
  final RedisService _redisService;
  final PresenceService _presenceService;
  final ActivityLivePublisher? _livePublisher;

  IngestPhorgeWebhook(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._taskHydrator,
    this._redisService,
    this._presenceService, {
    ActivityLivePublisher? livePublisher,
  }) : _livePublisher = livePublisher;

  Future<Either<Failure, PhorgeWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
  }) async {
    final action = payload['action'];
    if (action is Map<String, dynamic> && action['test'] == true) {
      return const Right(PhorgeWebhookIngestionResult.ignored('test_event'));
    }

    final object = payload['object'];
    if (object is! Map<String, dynamic>) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('missing_object'),
      );
    }
    final objectType = (object['type'] ?? '').toString().trim().toUpperCase();
    final objectPhid = (object['phid'] ?? '').toString().trim();
    if (objectPhid.isEmpty) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('missing_object_phid'),
      );
    }
    if (objectType != 'TASK') {
      return Right(
        PhorgeWebhookIngestionResult.ignored(
          'unsupported_object_type:$objectType',
        ),
      );
    }

    final transactionsRaw = payload['transactions'];
    final transactionPhids = <String>[];
    if (transactionsRaw is List) {
      for (final raw in transactionsRaw) {
        if (raw is! Map<String, dynamic>) continue;
        final phid = (raw['phid'] ?? '').toString().trim();
        if (phid.isNotEmpty) transactionPhids.add(phid);
      }
    }
    if (transactionPhids.isEmpty) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('missing_transactions'),
      );
    }

    final sortedPhids = [...transactionPhids]..sort();
    final fingerprint = '$objectPhid|${sortedPhids.join(',')}';
    final reserved = await _redisService.reserveIngestionEventId(
      'phorge',
      fingerprint,
    );
    if (!reserved) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final phorgeConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'phorge' && config.isActive,
        )
        .firstOrNull;
    if (phorgeConfig == null) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('phorge_not_configured'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    final mappedUsers = users
        .where((u) => (u.phorgePhid ?? '').trim().isNotEmpty)
        .toList();
    if (mappedUsers.isEmpty) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('no_mapped_phorge_users'),
      );
    }

    final PhorgeTaskBundleDto? bundle;
    try {
      bundle = await _taskHydrator.fetchBundleForWebhook(
        taskPhid: objectPhid,
        transactionPhids: transactionPhids,
      );
    } catch (e) {
      print('[PHORGE_WEBHOOK] hydration_failed object=$objectPhid error=$e');
      return const Right(
        PhorgeWebhookIngestionResult.ignored('hydration_failed'),
      );
    }
    if (bundle == null) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('hydration_empty'),
      );
    }

    // Live path attribution is strict: only transactions authored by a known
    // DAB user (mapped phorgePhid) are ingested — no fallback user.
    final knownPhids = mappedUsers.map((u) => u.phorgePhid).toSet();
    final attributable = bundle.transactions
        .where((tx) => knownPhids.contains(tx.authorPHID))
        .toList();
    if (attributable.isEmpty) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('no_attributable_transactions'),
      );
    }

    final scopedBundle = PhorgeTaskBundleDto(
      task: bundle.task,
      transactions: attributable,
      sprintTag: bundle.sprintTag,
    );
    final activities = scopedBundle.toActivities(mappedUsers);
    if (activities.isEmpty) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('no_eligible_activities'),
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
        '[PHORGE_WEBHOOK] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
      );
    }

    if (ingestedCount == 0) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('duplicate_activity'),
      );
    }
    await _redisService.recordLiveIngestSuccess('phorge');
    return const Right(PhorgeWebhookIngestionResult.ingested());
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}

/// Outcome envelope for Herald webhook processing (parity with Slack/GitHub).
class PhorgeWebhookIngestionResult {
  final bool ingested;
  final String reason;

  const PhorgeWebhookIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const PhorgeWebhookIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const PhorgeWebhookIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
