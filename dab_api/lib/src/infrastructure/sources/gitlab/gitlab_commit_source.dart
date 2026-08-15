import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/core/gitlab_scope.dart';
import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/dtos/gitlab/gitlab_commit_dto.dart';
import 'package:dab_api/src/domain/dtos/gitlab/gitlab_commit_mapping.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/contracts/ports/i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/i_discovery_source.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
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
    this._credentials,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;
  final ICredentialResolver _credentials;

  @override
  Future<List<GitLabCommitDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeGitLabConfig();
    if (cfg == null) return const [];

    final userSettings = await _credentials.getUserSettingsForUsers(
      userIds: users.map((u) => u.id),
      providerId: 'gitlab',
    );
    Map<String, dynamic> authSettings = cfg.settings;
    var token = extractProviderToken('gitlab', authSettings);
    if (token.isEmpty) {
      for (final user in users) {
        final merged = _credentials.overlay(
          orgSettings: cfg.settings,
          userSettings: userSettings[user.id],
        );
        token = extractProviderToken('gitlab', merged);
        if (token.isNotEmpty) {
          authSettings = merged;
          break;
        }
      }
    }
    if (token.isEmpty) return const [];

    final projects = gitLabProjects(cfg.settings);
    if (projects.isEmpty) return const [];

    final emailToUser = await _buildEmailAttributionMap(users);
    if (emailToUser.isEmpty) return const [];

    final apiBase = gitLabApiBase(cfg.settings, cfg.baseUrl);
    final branch = (cfg.settings['branch'] ?? '').toString().trim();
    final headers = gitLabAuthHeaders(authSettings);

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

    final token = extractProviderToken('gitlab', cfg.settings);
    if (token.isEmpty) return const Right(null);

    final query = email.trim().isNotEmpty ? email.trim() : name.trim();
    if (query.isEmpty) return const Right(null);

    final uri = Uri.parse('${gitLabApiBase(cfg.settings, cfg.baseUrl)}/users')
        .replace(queryParameters: {'search': query});

    try {
      final list = await _jsonRest.getJsonList(
        uri,
        headers: gitLabAuthHeaders(cfg.settings),
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
}

/// Auth headers for GitLab REST. OAuth access tokens use Bearer.
Map<String, String> gitLabAuthHeaders(Map<String, dynamic> settings) {
  final token = extractProviderToken('gitlab', settings);
  if (isOauthCredential(settings)) {
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }
  return {'PRIVATE-TOKEN': token, 'Accept': 'application/json'};
}
