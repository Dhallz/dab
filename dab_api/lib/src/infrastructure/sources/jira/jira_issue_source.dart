import 'dart:convert';

import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/jira/jira_issue_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/ports/i_discovery_source.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_jql.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Read-only Jira Cloud issue search via REST API v3 + JQL.
/// CONTRACT: Returns [JiraIssueDto] rows for [UnifiedActivityFetcher].
/// CONSTRAINTS: No remote writes. Auth: Basic (Atlassian email + API token).
class JiraIssueSource implements IActivitySource<JiraIssueDto>, IDiscoverySource {
  JiraIssueSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;

  static const _searchFields =
      'key,summary,status,updated,assignee,reporter,creator,project';

  @override
  Future<List<JiraIssueDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeJiraConfig();
    if (cfg == null) return const [];

    final host = normalizeJiraCloudHost(cfg.baseUrl);
    if (host.isEmpty) return const [];

    final email = _email(cfg.settings);
    final token = _apiToken(cfg.settings);
    if (email.isEmpty || token.isEmpty) return const [];

    final projectKeys = _projectKeys(cfg.settings);
    final extraJql = (cfg.settings['extraJql'] ?? '').toString();

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'jira');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) return const [];

    final accountIds = linkedIdentities.map((i) => i.externalId).toSet().toList();

    final jql = buildIssuesSearchJql(
      startInclusiveUtc: start.toUtc(),
      endInclusiveUtc: end.toUtc(),
      projectKeysRaw: projectKeys,
      extraJql: extraJql,
      authoredOnly: authoredOnly,
      accountIds: authoredOnly ? accountIds : null,
    );
    if (jql == null || jql.isEmpty) return const [];

    final accountToUser = {
      for (final i in linkedIdentities) i.externalId: i.userId,
    };

    final authHeaders = _basicAuthHeaders(email, token);
    final results = <JiraIssueDto>[];
    final seenKeys = <String>{};

    var startAt = 0;
    const maxResults = 50;
    for (var page = 0; page < 20; page++) {
      final uri = Uri.parse('https://$host/rest/api/3/search/jql').replace(
        queryParameters: {
          'jql': jql,
          'startAt': '$startAt',
          'maxResults': '$maxResults',
          'fields': _searchFields,
        },
      );

      Map<String, dynamic> body;
      try {
        body = await _jsonRest.getJsonMap(
          uri,
          headers: {
            ...authHeaders,
            'Accept': 'application/json',
          },
        );
      } on ProtocolException catch (_) {
        break;
      } catch (_) {
        break;
      }

      final rawIssues = body['issues'];
      if (rawIssues is! List) break;

      for (final item in rawIssues) {
        if (item is! Map<String, dynamic>) continue;
        final dto = _mapSearchIssue(host: host, json: item, accountToUser: accountToUser);
        if (dto == null) continue;
        if (!seenKeys.add(dto.issueKey)) continue;
        results.add(dto);
      }

      final total = int.tryParse(body['total']?.toString() ?? '') ?? 0;
      startAt += maxResults;
      if (startAt >= total || rawIssues.isEmpty) break;
    }

    return results;
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(
    String name,
    String email,
  ) async {
    final cfg = await _activeJiraConfig();
    if (cfg == null) return const Right(null);

    final host = normalizeJiraCloudHost(cfg.baseUrl);
    if (host.isEmpty) return const Right(null);

    final atlassianEmail = _email(cfg.settings);
    final token = _apiToken(cfg.settings);
    if (atlassianEmail.isEmpty || token.isEmpty) return const Right(null);

    final query = email.trim().isNotEmpty ? email.trim() : name.trim();
    if (query.isEmpty) return const Right(null);

    final uri = Uri.parse('https://$host/rest/api/3/user/search').replace(
      queryParameters: {'query': query},
    );

    try {
      final list = await _jsonRest.getJsonList(
        uri,
        headers: {
          ..._basicAuthHeaders(atlassianEmail, token),
          'Accept': 'application/json',
        },
      );
      Map<String, dynamic>? firstUser;
      for (final raw in list) {
        if (raw is Map<String, dynamic>) {
          firstUser = raw;
          break;
        }
      }
      final accountId = firstUser?['accountId']?.toString().trim();
      if (accountId == null || accountId.isEmpty) {
        return const Right(null);
      }
      return Right(accountId);
    } on ProtocolException catch (_) {
      return const Right(null);
    } catch (_) {
      return const Right(null);
    }
  }

  Future<ProviderConfig?> _activeJiraConfig() async {
    final configsResult = await _configRepository.getConfigs();
    final configs = configsResult.getOrElse((_) => <ProviderConfig>[]);
    for (final c in configs) {
      if (c.id == 'jira' && c.isActive) return c;
    }
    return null;
  }

  String _email(Map<String, dynamic> settings) =>
      (settings['api.email'] ?? settings['email'] ?? '').toString().trim();

  String _apiToken(Map<String, dynamic> settings) =>
      (settings['api.token'] ?? settings['apiToken'] ?? settings['token'] ?? '')
          .toString()
          .trim();

  List<String> _projectKeys(Map<String, dynamic> settings) {
    final raw = (settings['projectKeys'] ?? '').toString();
    if (raw.trim().isEmpty) return const [];
    return raw
        .split(RegExp(r'[\n,]+'))
        .map((k) => k.trim())
        .where((k) => k.isNotEmpty)
        .toList();
  }

  Map<String, String> _basicAuthHeaders(String email, String token) {
    final bytes = utf8.encode('$email:$token');
    final encoded = base64Encode(bytes);
    return {'Authorization': 'Basic $encoded'};
  }

  JiraIssueDto? _mapSearchIssue({
    required String host,
    required Map<String, dynamic> json,
    required Map<String, String> accountToUser,
  }) {
    final key = json['key']?.toString().trim();
    if (key == null || key.isEmpty) return null;

    final fields = json['fields'];
    if (fields is! Map<String, dynamic>) return null;

    final summary = (fields['summary'] ?? '').toString();
    final statusName = extractJiraEmbeddedName(fields['status']);
    final updatedRaw = fields['updated'];
    final updated =
        updatedRaw != null ? DateTime.tryParse(updatedRaw.toString())?.toUtc() : null;
    if (updated == null) return null;

    final project = fields['project'];
    final projectKey = project is Map<String, dynamic>
        ? (project['key'] ?? '').toString().trim()
        : '';

    final assignee = fields['assignee'];
    final reporter = fields['reporter'];
    final creator = fields['creator'];

    final assigneeId = jiraPersonAccountId(assignee);
    final reporterId = jiraPersonAccountId(reporter);
    final creatorId = jiraPersonAccountId(creator);

    final dabUserId = _firstMatchedUserId(
      accountToUser,
      [assigneeId, reporterId, creatorId],
    );

    final authorDisplayName =
        pickJiraPersonDisplay(assignee) ??
        pickJiraPersonDisplay(reporter) ??
        pickJiraPersonDisplay(creator);

    final browseUrl = 'https://$host/browse/$key';

    return JiraIssueDto(
      issueKey: key,
      projectKey: projectKey.isEmpty ? 'UNKNOWN' : projectKey,
      summary: summary,
      statusName: statusName,
      browseUrl: browseUrl,
      updatedAt: updated,
      siteHost: host,
      dabUserId: dabUserId,
      authorDisplayName: authorDisplayName,
    );
  }

  static String? _firstMatchedUserId(
    Map<String, String> accountToUser,
    List<String?> candidateAccountIds,
  ) {
    for (final aid in candidateAccountIds) {
      if (aid == null || aid.isEmpty) continue;
      final dab = accountToUser[aid];
      if (dab != null && dab.isNotEmpty) return dab;
    }
    return null;
  }
}

String extractJiraEmbeddedName(Object? nested) {
  if (nested is! Map<String, dynamic>) return '';
  final n = nested['name']?.toString().trim();
  return n ?? '';
}

String? jiraPersonAccountId(Object? person) {
  if (person == null || person == false) return null;
  if (person is! Map<String, dynamic>) return null;
  final raw = person['accountId']?.toString().trim();
  if (raw == null || raw.isEmpty) return null;
  return raw;
}

String? pickJiraPersonDisplay(Object? person) {
  if (person is! Map<String, dynamic>) return null;
  final name = person['displayName']?.toString().trim();
  if (name == null || name.isEmpty) return null;
  return name;
}
