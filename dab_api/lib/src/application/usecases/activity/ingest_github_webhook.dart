import 'package:dab_api/src/domain/dtos/github/github_commit_dto.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/github_scope.dart';
import '../../../domain/core/git_watch_scope.dart';
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
/// ROLE: Ingests GitHub `push` webhooks into the DAB live pipeline.
/// CONTRACT: Persisted rows match polling ([GitHubCommitDto.toActivities]) shaping.
/// CONSTRAINTS: Read-only toward GitHub; dedupe by `X-GitHub-Delivery` and stable activity id.
class IngestGitHubWebhook {
  final IUserRepository _userRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final AbsILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;
  final AbsICredentialResolver? _credentials;
  final AbsIActivityFollowRepository? _follows;

  IngestGitHubWebhook(
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

  Future<Either<Failure, GitHubWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
    required String deliveryId,
    required String event,
  }) async {
    final trimmedDelivery = deliveryId.trim();
    if (trimmedDelivery.isEmpty) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('missing_delivery_id'),
      );
    }

    final reserved = await _liveFeed.reserveGitHubDeliveryId(
      trimmedDelivery,
    );
    if (!reserved) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('duplicate_delivery_id'),
      );
    }

    final trimmedEvent = event.trim().toLowerCase();
    if (trimmedEvent == 'ping') {
      return const Right(GitHubWebhookIngestionResult.ignored('ping'));
    }

    if (trimmedEvent != 'push') {
      return Right(
        GitHubWebhookIngestionResult.ignored('unsupported_event:$trimmedEvent'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final githubConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'github' && config.isActive,
        )
        .firstOrNull;
    if (githubConfig == null) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('github_not_configured'),
      );
    }

    final fullNameRaw = payload['repository'] is Map<String, dynamic>
        ? (payload['repository'] as Map<String, dynamic>)['full_name']
              ?.toString()
              .trim()
        : null;
    if (fullNameRaw == null || fullNameRaw.isEmpty) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('missing_repository'),
      );
    }
    final fullNameNormalized = fullNameRaw.toLowerCase();

    final allowedRepos = extractConfiguredGithubRepos(
      githubConfig.settings,
    ).map((r) => r.toLowerCase()).toSet();
    if (!allowedRepos.contains(fullNameNormalized)) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('repo_not_configured'),
      );
    }

    final ref = payload['ref']?.toString().trim() ?? '';
    const headsPrefix = 'refs/heads/';
    if (!ref.startsWith(headsPrefix)) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('non_branch_ref'),
      );
    }
    final branch = ref.substring(headsPrefix.length);
    if (branch.isEmpty) {
      return const Right(GitHubWebhookIngestionResult.ignored('empty_branch'));
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('no_users_found'),
      );
    }

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'github');
    var identities = identitiesResult
        .getOrElse((_) => const [])
        .where((identity) => identity.status == UserIdentityStatus.linked)
        .toList();
    if (identities.isEmpty) {
      final allIdentitiesResult = await _userRepository.getAllIdentities();
      final allowedUserIds = users.map((user) => user.id).toSet();
      identities = allIdentitiesResult
          .getOrElse((_) => const [])
          .where((identity) => allowedUserIds.contains(identity.userId))
          .where((identity) => identity.status == UserIdentityStatus.linked)
          .where(
            (identity) => identity.providerId.trim().toLowerCase() == 'github',
          )
          .toList();
    }

    final userIdByLogin = <String, String>{};
    for (final identity in identities) {
      final key = identity.externalId.trim().toLowerCase();
      if (key.isEmpty) continue;
      userIdByLogin.putIfAbsent(key, () => identity.userId);
    }
    if (userIdByLogin.isEmpty) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('no_linked_github_identities'),
      );
    }

    final instanceRepos = extractConfiguredGithubRepos(githubConfig.settings);
    final settingsByUser =
        await _credentials?.getUserSettingsForUsers(
          userIds: users.map((u) => u.id),
          providerId: 'github',
        ) ??
        {for (final user in users) user.id: <String, dynamic>{}};

    final followKey = gitFollowObjectKey(fullNameRaw, branch);
    final followers = await inboxFollowerUserIds(
      _follows,
      providerId: 'github',
      objectKeys: [?followKey],
    );

    final commitsRaw = payload['commits'];
    if (commitsRaw is! List<dynamic>) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('invalid_commits'),
      );
    }

    final toPersist = <Activity>[];
    for (final raw in commitsRaw) {
      if (raw is! Map<String, dynamic>) continue;

      final distinct = raw['distinct'];
      if (distinct == false) {
        continue;
      }

      final sha = (raw['id'] ?? '').toString().trim();
      if (sha.isEmpty) continue;

      final authorMap = raw['author'] is Map<String, dynamic>
          ? raw['author'] as Map<String, dynamic>
          : null;
      final committerMap = raw['committer'] is Map<String, dynamic>
          ? raw['committer'] as Map<String, dynamic>
          : null;

      final loginCandidate =
          (authorMap?['username'] ??
                  committerMap?['username'] ??
                  authorMap?['login'] ??
                  committerMap?['login'] ??
                  '')
              .toString()
              .trim();
      final userIdForLogin = loginCandidate.isEmpty
          ? null
          : userIdByLogin[loginCandidate.toLowerCase()];

      final watchers = gitInboxWatchers(
        userSettingsById: settingsByUser,
        repo: fullNameRaw,
        branch: branch,
        instanceRepos: instanceRepos,
        senderUserId: userIdForLogin,
      );
      if (watchers.isEmpty && followers.isEmpty) continue;

      final commitMessage =
          (raw['message'] ??
                  (raw['commit'] is Map<String, dynamic>
                      ? (raw['commit'] as Map<String, dynamic>)['message']
                            ?.toString()
                      : null) ??
                  '')
              .toString()
              .trim();
      final urlCandidate = (raw['url'] ?? '').toString().trim();
      final url = urlCandidate.isEmpty
          ? 'https://github.com/$fullNameRaw/commit/$sha'
          : urlCandidate;

      final tsStr = raw['timestamp']?.toString().trim() ?? '';
      late final DateTime committedAtUtc;
      if (tsStr.isNotEmpty) {
        final parsedTs = DateTime.tryParse(tsStr);
        if (parsedTs != null) {
          committedAtUtc = parsedTs.toUtc();
        } else {
          continue;
        }
      } else {
        final nestedCommit = raw['commit'] is Map<String, dynamic>
            ? raw['commit'] as Map<String, dynamic>
            : null;
        if (nestedCommit == null) {
          continue;
        }
        Map<String, dynamic>? nestedAuthor;
        if (nestedCommit['author'] is Map<String, dynamic>) {
          nestedAuthor = nestedCommit['author'] as Map<String, dynamic>;
        }
        String? dateStr = nestedAuthor?['date']?.toString().trim();
        if (dateStr == null || dateStr.isEmpty) {
          if (nestedCommit['committer'] is Map<String, dynamic>) {
            final c = nestedCommit['committer'] as Map<String, dynamic>;
            dateStr = c['date']?.toString().trim();
          }
        }
        final parsedNested =
            dateStr != null &&
                dateStr.isNotEmpty &&
                DateTime.tryParse(dateStr) != null
            ? DateTime.tryParse(dateStr)?.toUtc()
            : null;
        if (parsedNested == null) continue;
        committedAtUtc = parsedNested;
      }

      final dto = GitHubCommitDto(
        repo: fullNameRaw,
        branch: branch,
        sha: sha,
        message: commitMessage.isEmpty
            ? '(empty commit message)'
            : commitMessage,
        url: url,
        authorLogin: loginCandidate,
        authorName:
            authorMap?['name']?.toString() ?? committerMap?['name']?.toString(),
        authorEmail: authorMap?['email']?.toString(),
        authorAvatarUrl: null,
        committedAt: committedAtUtc,
        userId: userIdForLogin,
      );

      toPersist.addAll(
        dto.toActivities(
          users,
          forUserIds: watchers,
          followerUserIds: followers,
          senderUserId: userIdForLogin,
        ),
      );
    }

    return _persister.persist(
      activities: toPersist,
      providerId: 'github',
      emptyReason: 'no_eligible_commits',
      logTag: 'GITHUB_WEBHOOK',
      onInserted: (activity) {
        final sha = (activity.url ?? '').split('/').last;
        print(
          '[GITHUB_WEBHOOK] db_insert activity_id=${activity.id} user_id=${activity.userId} sha=$sha',
        );
      },
    );
  }
}
