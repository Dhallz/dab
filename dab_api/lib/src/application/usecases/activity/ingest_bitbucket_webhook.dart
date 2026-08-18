import 'package:fpdart/fpdart.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/bitbucket_scope.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/git_watch_scope.dart';
import '../../../domain/dtos/bitbucket/bitbucket_commit_dto.dart';
import '../../../domain/dtos/bitbucket/bitbucket_commit_mapping.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
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
  final AbsIProviderConfigRepository _providerConfigRepository;
  final AbsILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;
  final AbsICredentialResolver? _credentials;
  final AbsIActivityFollowRepository? _follows;

  IngestBitbucketWebhook(
    this._userRepository,
    AbsIActivityRepository activityRepository,
    this._providerConfigRepository,
    this._liveFeed,
    AbsIPresenceBroadcaster presence, {
    ActivityLivePublisher? livePublisher,
    LiveIngestPersister? persister,
    AbsICredentialResolver? credentials,
    AbsIActivityFollowRepository? follows,
  }) : _credentials = credentials,
       _follows = follows,
       _persister =
           persister ??
           LiveIngestPersister(
             activities: activityRepository,
             liveFeed: _liveFeed,
             presence: presence,
             livePublisher: livePublisher,
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
    final reserved = await _liveFeed.reserveIngestionEventId(
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

    final allowedRepos = {
      for (final item in bitbucketRepos(bitbucketConfig.settings))
        item.toLowerCase(),
    };
    if (allowedRepos.isNotEmpty && !allowedRepos.contains(repo.toLowerCase())) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('repo_not_configured'),
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

    var attributableCommits = 0;
    final toPersist = <Activity>[];
    final instanceRepos = bitbucketRepos(bitbucketConfig.settings);
    final settingsByUser =
        await _credentials?.getUserSettingsForUsers(
          userIds: users.map((u) => u.id),
          providerId: 'bitbucket',
        ) ??
        {for (final user in users) user.id: <String, dynamic>{}};
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
        if (dto == null) continue;
        final watchers = gitInboxWatchers(
          userSettingsById: settingsByUser,
          repo: repo,
          branch: branch?.isEmpty == true ? null : branch,
          instanceRepos: instanceRepos,
          senderUserId: dto.userId,
        );
        final followKey = gitFollowObjectKey(
          repo,
          branch?.isEmpty == true ? null : branch,
        );
        final followers = await inboxFollowerUserIds(
          _follows,
          providerId: 'bitbucket',
          objectKeys: [?followKey],
        );
        if (watchers.isEmpty && followers.isEmpty) continue;
        attributableCommits++;
        toPersist.addAll(
          dto.toActivities(
            users,
            forUserIds: watchers,
            followerUserIds: followers,
            senderUserId: dto.userId,
          ),
        );
      }
    }

    if (attributableCommits == 0) {
      return const Right(
        BitbucketWebhookIngestionResult.ignored('no_attributable_users'),
      );
    }
    return _persister.persist(
      activities: toPersist,
      providerId: 'bitbucket',
      emptyReason: 'duplicate_activity',
      logTag: 'BITBUCKET_WEBHOOK',
    );
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
}
