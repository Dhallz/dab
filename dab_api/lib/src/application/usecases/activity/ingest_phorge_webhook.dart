import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import '../../../domain/dtos/phorge/phorge_task/phorge_task_dto.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/contracts/ports/i_live_feed_store.dart';
import '../../../domain/contracts/ports/i_phorge_task_hydrator.dart';
import '../../../domain/contracts/ports/i_presence_broadcaster.dart';
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
/// ROLE: Ingests Phorge Herald webhooks into the DAB live pipeline.
/// CONTRACT: Herald payloads carry only object/transaction PHIDs, so the task
/// is re-hydrated via Conduit ([IPhorgeTaskHydrator.fetchBundleForWebhook]) and
/// mapped through the same [OnPhorgeTaskBundleDto.toActivities] shaping as
/// polling. Only transactions authored by users with a known `phorgePhid` are
/// persisted (no fallback attribution on the live path).
/// CONSTRAINTS: Read-only toward Phorge; dedupe by object+transaction PHIDs.
class IngestPhorgeWebhook {
  final IUserRepository _userRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final IPhorgeTaskHydrator _taskHydrator;
  final ILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;
  final AbsIActivityFollowRepository? _follows;

  IngestPhorgeWebhook(
    this._userRepository,
    AbsIActivityRepository activityRepository,
    this._providerConfigRepository,
    this._taskHydrator,
    this._liveFeed,
    IPresenceBroadcaster presence, {
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
    if (objectType != 'TASK' && objectType != 'DREV') {
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
    final reserved = await _liveFeed.reserveIngestionEventId(
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
    final followers = await inboxFollowerUserIds(
      _follows,
      providerId: 'phorge',
      objectKeys: [bundle.task.conduitPhid],
    );
    final activities = scopedBundle.toActivities(
      mappedUsers,
      inbound: true,
      followerUserIds: followers,
    );
    if (activities.isEmpty) {
      return const Right(
        PhorgeWebhookIngestionResult.ignored('no_eligible_activities'),
      );
    }

    return _persister.persist(
      activities: activities,
      providerId: 'phorge',
      emptyReason: 'duplicate_activity',
      logTag: 'PHORGE_WEBHOOK',
    );
  }
}
