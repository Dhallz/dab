import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/bitbucket/bitbucket_commit_dto.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/sources/bitbucket/bitbucket_commit_source.dart';
import '../../../infrastructure/websockets/presence_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests Bitbucket Cloud `repo:push` webhooks into the DAB live
/// pipeline.
/// CONTRACT: Each change's commits are shaped identically to polling via
/// [mapBitbucketCommitJson] + [OnBitbucketCommitDto.toActivities].
/// Attribution prefers commit author `account_id` against linked `bitbucket`
/// identities, then raw-signature emails against DAB user emails.
/// CONSTRAINTS: Read-only toward Bitbucket; dedupe on delivery id (fallback:
/// repo + change target hashes).
class IngestBitbucketWebhook {
  final IUserRepository _userRepository;
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final RedisService _redisService;
  final PresenceService _presenceService;

  IngestBitbucketWebhook(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._redisService,
    this._presenceService,
  );

  Future<Either<Failure, BitbucketWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
    String? deliveryId,
  }) async {
    final push = payload['push'];
    if (push is! Map<String, dynamic>) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('unsupported_event'),
      );
    }
    final changes = push['changes'];
    if (changes is! List || changes.isEmpty) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('no_changes'),
      );
    }

    final repositoryNode = payload['repository'];
    final repo = repositoryNode is Map<String, dynamic>
        ? (repositoryNode['full_name'] ?? '').toString().trim()
        : '';
    if (repo.isEmpty) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('missing_repository'),
      );
    }

    final fingerprint = (deliveryId ?? '').trim().isNotEmpty
        ? deliveryId!.trim()
        : '$repo|${_changeHashes(changes).join(',')}';
    final reserved = await _redisService.reserveIngestionEventId(
      'bitbucket',
      fingerprint,
    );
    if (!reserved) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final bitbucketConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'bitbucket' && config.isActive,
        )
        .firstOrNull;
    if (bitbucketConfig == null) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('bitbucket_not_configured'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('no_users_found'),
      );
    }

    final accountToUser = <String, String>{};
    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'bitbucket');
    for (final identity in identitiesResult.getOrElse((_) => const [])) {
      if (identity.status != UserIdentityStatus.linked) continue;
      final key = identity.externalId.trim();
      if (key.isEmpty) continue;
      accountToUser.putIfAbsent(key, () => identity.userId);
    }
    final emailToUser = <String, String>{
      for (final u in users)
        if (u.email.trim().isNotEmpty) u.email.trim().toLowerCase(): u.id,
    };

    var ingestedCount = 0;
    var attributableCommits = 0;
    for (final change in changes) {
      if (change is! Map<String, dynamic>) continue;
      final newState = change['new'];
      final branch =
          newState is Map<String, dynamic> &&
              (newState['type'] ?? '') == 'branch'
          ? (newState['name'] ?? '').toString().trim()
          : null;

      final commits = change['commits'];
      if (commits is! List) continue;

      for (final raw in commits) {
        if (raw is! Map<String, dynamic>) continue;
        final dto = mapBitbucketCommitJson(
          raw,
          repo: repo,
          branch: branch?.isEmpty == true ? null : branch,
          accountToUser: accountToUser,
          emailToUser: emailToUser,
        );
        if (dto == null || dto.userId == null) continue;
        attributableCommits++;

        for (final activity in dto.toActivities(users)) {
          final createResult = await _activityRepository.createActivity(
            activity,
          );
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
          await _redisService.incrementVersion();
          await _redisService.fanOutActivity(activity);
          _presenceService.broadcastToUser(
            activity.userId,
            'ACTIVITY_RECEIVED',
            activity.toMap(),
          );
          print(
            '[BITBUCKET_WEBHOOK] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
          );
        }
      }
    }

    if (attributableCommits == 0) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('no_attributable_users'),
      );
    }
    if (ingestedCount == 0) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('duplicate_activity'),
      );
    }
    return const Right(BitbucketWebhookIngestionResult.ingested());
  }

  List<String> _changeHashes(List<dynamic> changes) {
    final hashes = <String>[];
    for (final change in changes) {
      if (change is! Map<String, dynamic>) continue;
      final newState = change['new'];
      if (newState is Map<String, dynamic>) {
        final target = newState['target'];
        final hash = target is Map<String, dynamic>
            ? (target['hash'] ?? '').toString().trim()
            : '';
        if (hash.isNotEmpty) hashes.add(hash);
      }
    }
    return hashes;
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}

/// Outcome envelope for Bitbucket webhook processing (parity with GitHub).
class BitbucketWebhookIngestionResult {
  final bool ingested;
  final String reason;

  const BitbucketWebhookIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const BitbucketWebhookIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const BitbucketWebhookIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
