import 'dart:convert';

import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/dtos/bitbucket/bitbucket_commit_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/ports/i_credential_resolver.dart';
import 'package:dab_api/src/domain/ports/i_discovery_source.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Read-only Bitbucket Cloud commit retrieval via the REST 2.0 API.
/// CONTRACT: Returns [BitbucketCommitDto] rows for [UnifiedActivityFetcher],
/// scoped by `workspace` + `repos` settings. Attribution prefers the commit
/// author's `account_id` against linked `bitbucket` identities, falling back
/// to the email parsed from the raw Git signature matched against DAB user
/// emails.
/// CONSTRAINTS: Must be READ-ONLY. Auth: Basic (username + app password /
/// API token). The commits endpoint has no date filters — pagination stops
/// once rows fall before the window.
class BitbucketCommitSource
    implements IActivitySource<BitbucketCommitDto>, IDiscoverySource {
  BitbucketCommitSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest,
    this._credentials,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;
  final ICredentialResolver _credentials;

  static const _apiBase = 'https://api.bitbucket.org/2.0';

  @override
  Future<List<BitbucketCommitDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeBitbucketConfig();
    if (cfg == null) return const [];

    final userSettings = await _credentials.getUserSettingsForUsers(
      userIds: users.map((u) => u.id),
      providerId: 'bitbucket',
    );
    var auth = bitbucketAuthHeaders(cfg.settings);
    if (auth == null) {
      for (final user in users) {
        final merged = _credentials.overlay(
          orgSettings: cfg.settings,
          userSettings: userSettings[user.id],
        );
        auth = bitbucketAuthHeaders(merged);
        if (auth != null) break;
      }
    }
    if (auth == null) return const [];

    final workspace = bitbucketWorkspace(cfg.settings);
    final repos = bitbucketRepos(cfg.settings);
    if (workspace.isEmpty || repos.isEmpty) return const [];

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
    if (accountToUser.isEmpty && emailToUser.isEmpty) return const [];

    final commits = <BitbucketCommitDto>[];
    final seen = <String>{};

    for (final repo in repos) {
      final fullRepo = repo.contains('/') ? repo : '$workspace/$repo';
      var uri = Uri.parse('$_apiBase/repositories/$fullRepo/commits').replace(
        queryParameters: {'pagelen': '100'},
      );

      for (var page = 0; page < 10; page++) {
        Map<String, dynamic> body;
        try {
          body = await _jsonRest.getJsonMap(uri, headers: auth);
        } catch (_) {
          break;
        }

        final values = body['values'];
        if (values is! List || values.isEmpty) break;

        var reachedOlderThanWindow = false;
        for (final raw in values) {
          if (raw is! Map<String, dynamic>) continue;
          final dto = mapBitbucketCommitJson(
            raw,
            repo: fullRepo,
            accountToUser: accountToUser,
            emailToUser: emailToUser,
          );
          if (dto == null) continue;
          if (dto.committedAt.isBefore(start.toUtc())) {
            reachedOlderThanWindow = true;
            continue;
          }
          if (dto.committedAt.isAfter(end.toUtc())) continue;
          if (dto.userId == null) continue;
          if (!seen.add('${dto.repo}:${dto.sha}')) continue;
          commits.add(dto);
        }

        final next = body['next']?.toString();
        if (reachedOlderThanWindow || next == null || next.isEmpty) break;
        uri = Uri.parse(next);
      }
    }

    return commits;
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    final cfg = await _activeBitbucketConfig();
    if (cfg == null) return const Right(null);

    final auth = bitbucketAuthHeaders(cfg.settings);
    final workspace = bitbucketWorkspace(cfg.settings);
    if (auth == null || workspace.isEmpty) return const Right(null);

    final query = name.trim().toLowerCase();
    if (query.isEmpty) return const Right(null);

    final uri = Uri.parse('$_apiBase/workspaces/$workspace/members').replace(
      queryParameters: {'pagelen': '100'},
    );

    try {
      final body = await _jsonRest.getJsonMap(uri, headers: auth);
      final values = body['values'];
      if (values is! List) return const Right(null);
      for (final raw in values) {
        if (raw is! Map<String, dynamic>) continue;
        final member = raw['user'];
        if (member is! Map<String, dynamic>) continue;
        final display = (member['display_name'] ?? '')
            .toString()
            .trim()
            .toLowerCase();
        final nickname = (member['nickname'] ?? '')
            .toString()
            .trim()
            .toLowerCase();
        if (display == query || nickname == query) {
          final accountId = member['account_id']?.toString().trim();
          if (accountId != null && accountId.isNotEmpty) {
            return Right(accountId);
          }
        }
      }
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  Future<ProviderConfig?> _activeBitbucketConfig() async {
    final configsResult = await _configRepository.getConfigs();
    final configs = configsResult.getOrElse((_) => <ProviderConfig>[]);
    for (final c in configs) {
      if (c.id == 'bitbucket' && c.isActive) return c;
    }
    return null;
  }
}

/// Auth headers for Bitbucket REST. OAuth access tokens use Bearer.
Map<String, String>? bitbucketAuthHeaders(Map<String, dynamic> settings) {
  final secret = extractProviderToken('bitbucket', settings);
  if (secret.isEmpty) return null;
  if (isOauthCredential(settings)) {
    return {'Authorization': 'Bearer $secret', 'Accept': 'application/json'};
  }
  final username = (settings['username'] ?? '').toString().trim();
  if (username.isEmpty) return null;
  final encoded = base64Encode(utf8.encode('$username:$secret'));
  return {'Authorization': 'Basic $encoded', 'Accept': 'application/json'};
}

/// Extracts the configured workspace slug.
String bitbucketWorkspace(Map<String, dynamic> settings) =>
    (settings['workspace'] ?? '').toString().trim();

/// Extracts the configured repo allow-list (list or comma/newline string).
List<String> bitbucketRepos(Map<String, dynamic> settings) {
  final raw = settings['repos'];
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

/// Maps one Bitbucket commit JSON object (REST 2.0 row or `repo:push`
/// webhook change commit) into a [BitbucketCommitDto].
///
/// Returns null for malformed rows. [branch] is only known on webhook
/// payloads (the commits API is branch-agnostic).
BitbucketCommitDto? mapBitbucketCommitJson(
  Map<String, dynamic> json, {
  required String repo,
  String? branch,
  Map<String, String> accountToUser = const {},
  Map<String, String> emailToUser = const {},
}) {
  final sha = (json['hash'] ?? '').toString().trim();
  if (sha.isEmpty) return null;

  final dateRaw = json['date']?.toString();
  final committedAt = dateRaw != null
      ? DateTime.tryParse(dateRaw)?.toUtc()
      : null;
  if (committedAt == null) return null;

  final author = json['author'];
  String? accountId;
  String? displayName;
  String? rawSignature;
  if (author is Map<String, dynamic>) {
    rawSignature = author['raw']?.toString();
    final platformUser = author['user'];
    if (platformUser is Map<String, dynamic>) {
      accountId = platformUser['account_id']?.toString().trim();
      displayName = platformUser['display_name']?.toString().trim();
    }
  }
  final email = bitbucketEmailFromRaw(rawSignature);

  String? userId;
  if (accountId != null && accountId.isNotEmpty) {
    userId = accountToUser[accountId];
  }
  if (userId == null && email != null) {
    userId = emailToUser[email.toLowerCase()];
  }

  final links = json['links'];
  final html = links is Map<String, dynamic> ? links['html'] : null;
  final url = html is Map<String, dynamic>
      ? (html['href'] ?? '').toString().trim()
      : '';

  return BitbucketCommitDto(
    repo: repo,
    branch: branch,
    sha: sha,
    message: (json['message'] ?? '').toString().trim(),
    url: url,
    authorName: displayName?.isNotEmpty == true
        ? displayName
        : bitbucketNameFromRaw(rawSignature),
    authorEmail: email,
    committedAt: committedAt,
    userId: userId,
  );
}
