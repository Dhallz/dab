import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/dtos/gitlab/gitlab_commit_dto.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/websockets/presence_service.dart';

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
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final RedisService _redisService;
  final PresenceService _presenceService;

  IngestGitLabWebhook(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._redisService,
    this._presenceService,
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
    final reserved = await _redisService.reserveIngestionEventId(
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

    var ingestedCount = 0;
    var attributableCommits = 0;
    for (final raw in commitsRaw) {
      if (raw is! Map<String, dynamic>) continue;

      final sha = (raw['id'] ?? '').toString().trim();
      if (sha.isEmpty) continue;

      final timestampRaw = raw['timestamp']?.toString();
      final committedAt = timestampRaw != null
          ? DateTime.tryParse(timestampRaw)?.toUtc()
          : null;
      if (committedAt == null) continue;

      final author = raw['author'];
      final authorEmail = author is Map<String, dynamic>
          ? (author['email'] ?? '').toString().trim()
          : '';
      final userId = authorEmail.isEmpty
          ? null
          : emailToUser[authorEmail.toLowerCase()];
      if (userId == null) continue;
      attributableCommits++;

      final dto = GitLabCommitDto(
        project: project,
        branch: branch,
        sha: sha,
        message: (raw['message'] ?? raw['title'] ?? '').toString().trim(),
        url: (raw['url'] ?? '').toString().trim(),
        authorName: author is Map<String, dynamic>
            ? author['name']?.toString()
            : null,
        authorEmail: authorEmail,
        committedAt: committedAt,
        userId: userId,
      );

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
          '[GITLAB_WEBHOOK] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
        );
      }
    }

    if (attributableCommits == 0) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('no_attributable_users'),
      );
    }
    if (ingestedCount == 0) {
      return const Right(
        GitLabWebhookIngestionResult.ignored('duplicate_activity'),
      );
    }
    return const Right(GitLabWebhookIngestionResult.ingested());
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}

/// Outcome envelope for GitLab webhook processing (parity with Slack/GitHub).
class GitLabWebhookIngestionResult {
  final bool ingested;
  final String reason;

  const GitLabWebhookIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const GitLabWebhookIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const GitLabWebhookIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
