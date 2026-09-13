import 'package:fpdart/fpdart.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/git_watch_scope.dart';
import '../../../domain/core/gitlab_scope.dart';
import '../../../domain/dtos/gitlab/gitlab_commit_dto.dart';
import '../../../domain/dtos/gitlab/gitlab_commit_mapping.dart';
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
/// ROLE: Ingests GitLab Push Hook webhooks into the DAB live pipeline.
/// CONTRACT: Handles `object_kind: push` events; each commit in the payload is
/// shaped identically to polling via [GitLabCommitDto] +
/// [OnGitLabCommitDto.toActivities]. Attribution matches commit
/// `author.email` against DAB user emails and email-shaped linked `gitlab`
/// identities.
/// CONSTRAINTS: Read-only toward GitLab; dedupe on checkout SHA + ref.
class IngestGitLabWebhook {
  final IUserRepository _userRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final AbsILiveFeedStore _liveFeed;
  final LiveIngestPersister _persister;
  final AbsICredentialResolver? _credentials;
  final AbsIActivityFollowRepository? _follows;

  IngestGitLabWebhook(
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

  Future<Either<Failure, GitLabWebhookIngestionResult>> execute({
    required Map<String, dynamic> payload,
  }) async {
    final objectKind = (payload['object_kind'] ?? '').toString().trim();
    if (objectKind != 'push') {
      return Right(
        GitLabWebhookIngestionResult.ignored('unsupported_event:$objectKind'),
      );
    }

    final projectNode = payload['project'];
    final project = projectNode is Map<String, dynamic>
        ? (projectNode['path_with_namespace'] ?? '').toString().trim()
        : '';
    if (project.isEmpty) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('missing_project'),
      );
    }

    final ref = (payload['ref'] ?? '').toString().trim();
    final branch = ref.startsWith('refs/heads/')
        ? ref.substring('refs/heads/'.length)
        : (ref.isEmpty ? null : ref);

    final commitsRaw = payload['commits'];
    if (commitsRaw is! List || commitsRaw.isEmpty) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('no_commits'),
      );
    }

    final checkoutSha = (payload['checkout_sha'] ?? payload['after'] ?? '')
        .toString()
        .trim();
    final fingerprint = '$project|$ref|$checkoutSha';
    final reserved = await _liveFeed.reserveIngestionEventId(
      'gitlab',
      fingerprint,
    );
    if (!reserved) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('duplicate_delivery'),
      );
    }

    final configsResult = await _providerConfigRepository.getConfigs();
    final gitlabConfig = configsResult
        .getOrElse((_) => const [])
        .where(
          (config) =>
              config.id.trim().toLowerCase() == 'gitlab' && config.isActive,
        )
        .firstOrNull;
    if (gitlabConfig == null) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('gitlab_not_configured'),
      );
    }

    final allowedProjects = {
      for (final item in gitlabConfig.settings.gitLabProjects())
        item.toLowerCase(),
    };
    if (allowedProjects.isNotEmpty &&
        !allowedProjects.contains(project.toLowerCase())) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('project_not_configured'),
      );
    }

    final usersResult = await _userRepository.getUsers();
    final users = usersResult.getOrElse((_) => const <User>[]);
    if (users.isEmpty) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('no_users_found'),
      );
    }

    final emailToUser = <String, String>{
      for (final u in users)
        if (u.email.trim().isNotEmpty) u.email.trim().toLowerCase(): u.id,
    };
    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'gitlab');
    for (final identity in identitiesResult.getOrElse((_) => const [])) {
      if (identity.status != UserIdentityStatus.linked) continue;
      final externalId = identity.externalId.trim().toLowerCase();
      if (externalId.contains('@')) {
        emailToUser.putIfAbsent(externalId, () => identity.userId);
      }
    }

    var attributableCommits = 0;
    final toPersist = <Activity>[];
    final instanceRepos = gitlabConfig.settings.gitLabProjects();
    final settingsByUser =
        await _credentials?.getUserSettingsForUsers(
          userIds: users.map((u) => u.id),
          providerId: 'gitlab',
        ) ??
        {for (final user in users) user.id: <String, dynamic>{}};
    final followKey = gitFollowObjectKey(project, branch);
    final followers = await inboxFollowerUserIds(
      _follows,
      providerId: 'gitlab',
      objectKeys: [?followKey],
    );
    for (final raw in commitsRaw) {
      if (raw is! Map<String, dynamic>) continue;

      final dto = mapGitLabCommitJson(
        raw,
        project: project,
        branch: branch,
        emailToUser: emailToUser,
      );
      if (dto == null) continue;
      final watchers = settingsByUser.gitInboxWatchers(repo: project, branch: branch, instanceRepos: instanceRepos, senderUserId: dto.userId);
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

    if (attributableCommits == 0) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('no_attributable_users'),
      );
    }
    return _persister.persist(
      activities: toPersist,
      providerId: 'gitlab',
      emptyReason: 'duplicate_activity',
      logTag: 'GITLAB_WEBHOOK',
    );
  }
}
