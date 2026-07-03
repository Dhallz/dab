import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/gitlab/gitlab_commit_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/ports/i_discovery_source.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Read-only GitLab commit retrieval via the GitLab REST API v4.
/// CONTRACT: Returns [GitLabCommitDto] rows for [UnifiedActivityFetcher],
/// scoped by the `projects` allow-list setting. The commits API carries no
/// platform user object, so attribution matches `author_email` against DAB
/// user emails and email-shaped linked `gitlab` identities.
/// CONSTRAINTS: Must be READ-ONLY. Auth: personal access token
/// (`PRIVATE-TOKEN` header).
class GitLabCommitSource
    implements IActivitySource<GitLabCommitDto>, IDiscoverySource {
  GitLabCommitSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;

  static const _defaultApiBase = 'https://gitlab.com/api/v4';

  @override
  Future<List<GitLabCommitDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeGitLabConfig();
    if (cfg == null) return const [];

    final token = gitLabToken(cfg.settings);
    if (token.isEmpty) return const [];

    final projects = gitLabProjects(cfg.settings);
    if (projects.isEmpty) return const [];

    final emailToUser = await _buildEmailAttributionMap(users);
    if (emailToUser.isEmpty) return const [];

    final apiBase = gitLabApiBase(cfg.settings, cfg.baseUrl);
    final branch = (cfg.settings['branch'] ?? '').toString().trim();
    final headers = _authHeaders(token);

    final commits = <GitLabCommitDto>[];
    final seen = <String>{};

    for (final project in projects) {
      final encodedProject = Uri.encodeComponent(project);
      final uri = Uri.parse(
        '$apiBase/projects/$encodedProject/repository/commits',
      ).replace(
        queryParameters: {
          'since': start.toUtc().toIso8601String(),
          'until': end.toUtc().toIso8601String(),
          'per_page': '100',
          if (branch.isNotEmpty) 'ref_name': branch,
        },
      );

      List<dynamic> items;
      try {
        items = await _jsonRest.getJsonList(uri, headers: headers);
      } catch (_) {
        continue;
      }

      for (final raw in items) {
        if (raw is! Map<String, dynamic>) continue;
        final dto = mapGitLabCommitJson(
          raw,
          project: project,
          branch: branch.isEmpty ? null : branch,
          emailToUser: emailToUser,
        );
        if (dto == null) continue;
        if (dto.userId == null) continue;
        if (!seen.add('${dto.project}:${dto.sha}')) continue;
        commits.add(dto);
      }
    }

    return commits;
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    final cfg = await _activeGitLabConfig();
    if (cfg == null) return const Right(null);

    final token = gitLabToken(cfg.settings);
    if (token.isEmpty) return const Right(null);

    final query = email.trim().isNotEmpty ? email.trim() : name.trim();
    if (query.isEmpty) return const Right(null);

    final uri = Uri.parse('${gitLabApiBase(cfg.settings, cfg.baseUrl)}/users')
        .replace(queryParameters: {'search': query});

    try {
      final list = await _jsonRest.getJsonList(
        uri,
        headers: _authHeaders(token),
      );
      for (final raw in list) {
        if (raw is! Map<String, dynamic>) continue;
        final username = raw['username']?.toString().trim();
        if (username != null && username.isNotEmpty) return Right(username);
      }
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  /// Merges DAB user emails with email-shaped linked `gitlab` identity
  /// external ids into one lowercase email → DAB user id map.
  Future<Map<String, String>> _buildEmailAttributionMap(
    List<User> users,
  ) async {
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
    return emailToUser;
  }

  Future<ProviderConfig?> _activeGitLabConfig() async {
    final configsResult = await _configRepository.getConfigs();
    final configs = configsResult.getOrElse((_) => <ProviderConfig>[]);
    for (final c in configs) {
      if (c.id == 'gitlab' && c.isActive) return c;
    }
    return null;
  }

  Map<String, String> _authHeaders(String token) {
    return {'PRIVATE-TOKEN': token, 'Accept': 'application/json'};
  }
}

/// Extracts the personal access token from provider settings.
String gitLabToken(Map<String, dynamic> settings) =>
    (settings['api.token'] ?? settings['apiToken'] ?? settings['token'] ?? '')
        .toString()
        .trim();

/// Normalized API base URL (`https://gitlab.example.com/api/v4`).
///
/// Resolution order: explicit `apiBaseUrl` setting, then the provider's base
/// URL (instance URL) with `/api/v4` appended, then gitlab.com.
String gitLabApiBase(Map<String, dynamic> settings, [String baseUrl = '']) {
  final explicit = (settings['apiBaseUrl'] ?? '').toString().trim();
  if (explicit.isNotEmpty) {
    return explicit.replaceAll(RegExp(r'/+$'), '');
  }
  final instance = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
  if (instance.isNotEmpty) {
    return instance.endsWith('/api/v4') ? instance : '$instance/api/v4';
  }
  return GitLabCommitSource._defaultApiBase;
}

/// Extracts the configured project allow-list (list or comma/newline string).
List<String> gitLabProjects(Map<String, dynamic> settings) {
  final raw = settings['projects'];
  if (raw is List) {
    return raw
        .map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  final str = (raw ?? '').toString();
  if (str.trim().isEmpty) return const [];
  return str
      .split(RegExp(r'[\n,]+'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// Maps one GitLab commit JSON object (REST response row) into a
/// [GitLabCommitDto]. Returns null for malformed rows.
GitLabCommitDto? mapGitLabCommitJson(
  Map<String, dynamic> json, {
  required String project,
  String? branch,
  Map<String, String> emailToUser = const {},
}) {
  final sha = (json['id'] ?? '').toString().trim();
  if (sha.isEmpty) return null;

  final createdRaw =
      (json['committed_date'] ?? json['created_at'])?.toString();
  final committedAt = createdRaw != null
      ? DateTime.tryParse(createdRaw)?.toUtc()
      : null;
  if (committedAt == null) return null;

  final authorEmail = (json['author_email'] ?? '').toString().trim();

  return GitLabCommitDto(
    project: project,
    branch: branch,
    sha: sha,
    message: (json['message'] ?? json['title'] ?? '').toString().trim(),
    url: (json['web_url'] ?? '').toString().trim(),
    authorName: json['author_name']?.toString(),
    authorEmail: authorEmail.isEmpty ? null : authorEmail,
    committedAt: committedAt,
    userId: authorEmail.isEmpty ? null : emailToUser[authorEmail.toLowerCase()],
  );
}
