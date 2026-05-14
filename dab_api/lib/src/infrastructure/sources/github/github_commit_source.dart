import 'package:dab_api/src/domain/dtos/github/github_commit_dto.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_repo_config.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Fetches read-only commit activity from GitHub REST API.
/// CONTRACT: Returns commit DTOs scoped by configured repos and linked users.
/// CONSTRAINTS: Must not mutate remote state.
class GitHubCommitSource implements IActivitySource<GitHubCommitDto> {
  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;

  GitHubCommitSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest,
  );

  @override
  Future<List<GitHubCommitDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final configsResult = await _configRepository.getConfigs();
    final config = configsResult
        .getOrElse((_) => [])
        .where((c) => c.id == 'github' && c.isActive)
        .firstOrNull;
    if (config == null) {
      return [];
    }

    final settings = config.settings;
    final token = (settings['api.token'] ?? settings['token'] ?? '')
        .toString()
        .trim();
    if (token.isEmpty) {
      return [];
    }

    final configuredApiBaseUrl = (settings['apiBaseUrl'] ?? '')
        .toString()
        .trim();
    final apiBaseUrl =
        (configuredApiBaseUrl.isEmpty
                ? 'https://api.github.com'
                : configuredApiBaseUrl)
            .replaceAll(RegExp(r'/+$'), '');

    final repos = extractConfiguredGithubRepos(settings);
    if (repos.isEmpty) {
      return [];
    }
    final configuredBranch = (settings['branch'] ?? '').toString().trim();

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'github');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) {
      return [];
    }

    final userIdByLogin = {
      for (final identity in linkedIdentities)
        identity.externalId.toLowerCase(): identity.userId,
    };
    final userById = {for (final u in users) u.id: u};
    final authors = userIdByLogin.keys.toList();

    final commits = <GitHubCommitDto>[];
    final seen = <String>{};
    for (final repo in repos) {
      if (authoredOnly) {
        for (final author in authors) {
          final rawCommits = await _fetchCommits(
            apiBaseUrl: apiBaseUrl,
            token: token,
            repo: repo,
            start: start,
            end: end,
            author: author,
            branch: configuredBranch,
          );
          _appendDtos(
            commits: commits,
            seen: seen,
            rawCommits: rawCommits,
            repo: repo,
            branch: configuredBranch.isEmpty ? null : configuredBranch,
            userIdByLogin: userIdByLogin,
            fallbackUserId: userIdByLogin[author],
            fallbackAuthorName: userById[userIdByLogin[author]]?.name,
            fallbackAuthorAvatarUrl: userById[userIdByLogin[author]]?.avatarUrl,
          );
        }
      } else {
        final rawCommits = await _fetchCommits(
          apiBaseUrl: apiBaseUrl,
          token: token,
          repo: repo,
          start: start,
          end: end,
          branch: configuredBranch,
        );
        _appendDtos(
          commits: commits,
          seen: seen,
          rawCommits: rawCommits,
          repo: repo,
          branch: configuredBranch.isEmpty ? null : configuredBranch,
          userIdByLogin: userIdByLogin,
        );
      }
    }

    return commits;
  }

  Future<List<Map<String, dynamic>>> _fetchCommits({
    required String apiBaseUrl,
    required String token,
    required String repo,
    required DateTime start,
    required DateTime end,
    String? author,
    String? branch,
  }) async {
    try {
      final uri = Uri.parse('$apiBaseUrl/repos/$repo/commits').replace(
        queryParameters: {
          'since': start.toUtc().toIso8601String(),
          'until': end.toUtc().toIso8601String(),
          'per_page': '100',
          if (author != null && author.isNotEmpty) 'author': author,
          if (branch != null && branch.isNotEmpty) 'sha': branch,
        },
      );
      final decoded = await _jsonRest.getJsonList(
        uri,
        headers: {
          'Accept': 'application/vnd.github+json',
          'Authorization': 'Bearer $token',
          'User-Agent': 'dab-api',
          'X-GitHub-Api-Version': '2022-11-28',
        },
      );
      return decoded.whereType<Map<String, dynamic>>().toList();
    } on ProtocolException catch (_) {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  void _appendDtos({
    required List<GitHubCommitDto> commits,
    required Set<String> seen,
    required List<Map<String, dynamic>> rawCommits,
    required String repo,
    required String? branch,
    required Map<String, String> userIdByLogin,
    String? fallbackUserId,
    String? fallbackAuthorName,
    String? fallbackAuthorAvatarUrl,
  }) {
    for (final json in rawCommits) {
      final sha = (json['sha'] ?? '').toString().trim();
      if (sha.isEmpty) continue;

      final dedupeKey = '$repo:$sha';
      if (!seen.add(dedupeKey)) continue;

      final commit = json['commit'] as Map<String, dynamic>? ?? {};
      final commitAuthor = commit['author'] as Map<String, dynamic>? ?? {};
      final author = json['author'] as Map<String, dynamic>?;
      final login = author?['login']?.toString();

      final createdAtRaw = commitAuthor['date']?.toString();
      final createdAt = createdAtRaw != null
          ? DateTime.tryParse(createdAtRaw)?.toUtc()
          : null;
      if (createdAt == null) continue;

      final userId = login != null
          ? userIdByLogin[login.toLowerCase()]
          : fallbackUserId;
      commits.add(
        GitHubCommitDto(
          repo: repo,
          branch: branch,
          sha: sha,
          message: (commit['message'] ?? '').toString().trim(),
          url: (json['html_url'] ?? '').toString().trim(),
          authorLogin: login,
          authorName:
              commitAuthor['name']?.toString() ??
              author?['login']?.toString() ??
              fallbackAuthorName,
          authorEmail: commitAuthor['email']?.toString(),
          authorAvatarUrl:
              author?['avatar_url']?.toString() ?? fallbackAuthorAvatarUrl,
          committedAt: createdAt,
          userId: userId,
        ),
      );
    }
  }
}
