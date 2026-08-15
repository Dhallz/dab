import 'package:dab_api/src/domain/dtos/github/github_commit_dto.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/github_scope.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/websockets/presence_service.dart';
import '../../services/activity_live_publisher.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Ingests GitHub `push` webhooks into the DAB live pipeline.
/// CONTRACT: Persisted rows match polling ([GitHubCommitDto.toActivities]) shaping.
/// CONSTRAINTS: Read-only toward GitHub; dedupe by `X-GitHub-Delivery` and stable activity id.
class IngestGitHubWebhook {
  final IUserRepository _userRepository;
  final AbsIActivityRepository _activityRepository;
  final AbsIProviderConfigRepository _providerConfigRepository;
  final RedisService _redisService;
  final PresenceService _presenceService;
  final ActivityLivePublisher? _livePublisher;

  IngestGitHubWebhook(
    this._userRepository,
    this._activityRepository,
    this._providerConfigRepository,
    this._redisService,
    this._presenceService, {
    ActivityLivePublisher? livePublisher,
  }) : _livePublisher = livePublisher;

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

    final reserved = await _redisService.reserveGitHubDeliveryId(
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

    final commitsRaw = payload['commits'];
    if (commitsRaw is! List<dynamic>) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('invalid_commits'),
      );
    }

    var ingestedCount = 0;
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
      if (loginCandidate.isEmpty) {
        continue;
      }

      final userIdForLogin = userIdByLogin[loginCandidate.toLowerCase()];
      if (userIdForLogin == null) {
        continue;
      }

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

      final activities = dto.toActivities(users);
      if (activities.isEmpty) continue;
      final activity = activities.first;

      final createResult = await _activityRepository.createActivity(activity);
      if (createResult.isLeft()) {
        final messageFailures = createResult
            .getLeft()
            .toNullable()!
            .message
            .toLowerCase();
        if (_isDuplicateViolation(messageFailures)) {
          continue;
        }
        return Left(createResult.getLeft().toNullable()!);
      }
      ingestedCount++;
      print(
        '[GITHUB_WEBHOOK] db_insert activity_id=${activity.id} user_id=${activity.userId} sha=$sha',
      );
      await ActivityLivePublisher.emit(
        redis: _redisService,
        presence: _presenceService,
        activity: activity,
        publisher: _livePublisher,
      );
      print(
        '[GITHUB_WEBHOOK] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
      );
    }

    if (ingestedCount == 0) {
      return const Right(
        GitHubWebhookIngestionResult.ignored('no_eligible_commits'),
      );
    }
    await _redisService.recordLiveIngestSuccess('github');
    return const Right(GitHubWebhookIngestionResult.ingested());
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}

/// Outcome envelope for webhook processing (analytics / logging parity with Slack).
class GitHubWebhookIngestionResult {
  final bool ingested;
  final String reason;

  const GitHubWebhookIngestionResult._({
    required this.ingested,
    required this.reason,
  });

  const GitHubWebhookIngestionResult.ingested()
    : this._(ingested: true, reason: 'ingested');

  const GitHubWebhookIngestionResult.ignored(String reason)
    : this._(ingested: false, reason: reason);

  Map<String, dynamic> toMap() {
    return {'ingested': ingested, 'reason': reason};
  }
}
