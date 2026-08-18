import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/dtos/jira/jira_issue_dto.dart';
import 'package:dab_api/src/domain/dtos/jira/jira_issue_mapping.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/jira_project_watch_list.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_activity_source.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_discovery_source.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_jql.dart';
import 'package:fpdart/fpdart.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Read-only Jira Cloud issue search via REST API v3 + JQL.
/// CONTRACT: Returns [JiraIssueDto] rows for [UnifiedActivityFetcher].
/// CONSTRAINTS: No remote writes. Auth: Basic (Atlassian email + API token).
class JiraIssueSource implements AbsIActivitySource<JiraIssueDto>, AbsIDiscoverySource {
  JiraIssueSource(
    this._configRepository,
    this._userRepository,
    this._jsonRest,
    this._credentials,
  );

  final AbsIProviderConfigRepository _configRepository;
  final IUserRepository _userRepository;
  final JsonRestProtocol _jsonRest;
  final AbsICredentialResolver _credentials;

  static const _searchFields =
      'key,summary,status,updated,assignee,reporter,creator,project,comment';

  @override
  Future<List<JiraIssueDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    final cfg = await _activeJiraConfig();
    if (cfg == null) return const [];

    final identitiesResult = await _userRepository
        .getIdentitiesForUsersAndProvider(users.map((u) => u.id), 'jira');
    final linkedIdentities = identitiesResult
        .getOrElse((_) => [])
        .where((i) => i.status == UserIdentityStatus.linked)
        .toList();
    if (linkedIdentities.isEmpty) return const [];

    final userSettings = await _credentials.getUserSettingsForUsers(
      userIds: linkedIdentities.map((i) => i.userId),
      providerId: 'jira',
    );

    var auth = jiraRequestAuth(cfg.settings, orgConfig: cfg);
    if (auth == null) {
      for (final identity in linkedIdentities) {
        final merged = _credentials.overlay(
          orgSettings: cfg.settings,
          userSettings: userSettings[identity.userId],
        );
        auth = jiraRequestAuth(merged, orgConfig: cfg);
        if (auth != null) break;
      }
    }
    if (auth == null) return const [];

    final projectKeys = parseJiraProjectKeys(cfg.settings['projectKeys']);
    final extraJql = (cfg.settings['extraJql'] ?? '').toString();

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

    final authHeaders = auth.headers;
    final host = auth.browseHost;
    final results = <JiraIssueDto>[];
    final seenKeys = <String>{};

    var startAt = 0;
    const maxResults = 50;
    for (var page = 0; page < 20; page++) {
      final uri = Uri.parse('${auth.apiBase}/rest/api/3/search/jql').replace(
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
        final dto = _mapSearchIssue(
          host: host,
          json: item,
          accountToUser: accountToUser,
          start: start,
          end: end,
        );
        if (dto == null) continue;

        final fetchedComments = await _fetchIssueComments(
          apiBase: auth.apiBase,
          issueKey: dto.issueKey,
          authHeaders: authHeaders,
          accountToUser: accountToUser,
          start: start,
          end: end,
        );
        final mergedComments = _mergeComments(dto.comments, fetchedComments);
        final withComments = JiraIssueDto(
          issueKey: dto.issueKey,
          projectKey: dto.projectKey,
          summary: dto.summary,
          statusName: dto.statusName,
          browseUrl: dto.browseUrl,
          updatedAt: dto.updatedAt,
          siteHost: dto.siteHost,
          dabUserId: dto.dabUserId,
          authorDisplayName: dto.authorDisplayName,
          comments: mergedComments,
        );

        if (!seenKeys.add(dto.issueKey)) continue;
        results.add(withComments);
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

    final auth = jiraRequestAuth(cfg.settings, orgConfig: cfg);
    if (auth == null) return const Right(null);

    final query = email.trim().isNotEmpty ? email.trim() : name.trim();
    if (query.isEmpty) return const Right(null);

    final uri = Uri.parse('${auth.apiBase}/rest/api/3/user/search').replace(
      queryParameters: {'query': query},
    );

    try {
      final list = await _jsonRest.getJsonList(
        uri,
        headers: auth.headers,
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

  JiraIssueDto? _mapSearchIssue({
    required String host,
    required Map<String, dynamic> json,
    required Map<String, String> accountToUser,
    required DateTime start,
    required DateTime end,
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
    final comments = _extractComments(
      rawComments: fields['comment'],
      accountToUser: accountToUser,
      start: start,
      end: end,
    );

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
      comments: comments,
    );
  }

  List<JiraIssueCommentDto> _extractComments({
    required Object? rawComments,
    required Map<String, String> accountToUser,
    required DateTime start,
    required DateTime end,
  }) {
    if (rawComments is! Map<String, dynamic>) return const [];
    final list = rawComments['comments'];
    if (list is! List) return const [];

    final items = <JiraIssueCommentDto>[];
    for (final raw in list) {
      if (raw is! Map<String, dynamic>) continue;
      final id = (raw['id'] ?? '').toString().trim();
      if (id.isEmpty) continue;
      final createdRaw = raw['created']?.toString();
      final createdAt = createdRaw != null
          ? DateTime.tryParse(createdRaw)?.toUtc()
          : null;
      if (createdAt == null) continue;

      final author = raw['author'];
      final accountId = jiraPersonAccountId(author);
      final dabUserId = accountId == null ? null : accountToUser[accountId];
      final authorDisplayName = pickJiraPersonDisplay(author);

      final bodyText = extractJiraCommentText(raw['body']);
      items.add(
        JiraIssueCommentDto(
          id: id,
          body: bodyText,
          createdAt: createdAt,
          dabUserId: dabUserId,
          authorDisplayName: authorDisplayName,
        ),
      );
    }

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  Future<List<JiraIssueCommentDto>> _fetchIssueComments({
    required String apiBase,
    required String issueKey,
    required Map<String, String> authHeaders,
    required Map<String, String> accountToUser,
    required DateTime start,
    required DateTime end,
  }) async {
    final results = <JiraIssueCommentDto>[];
    var startAt = 0;
    const maxResults = 100;

    for (var page = 0; page < 10; page++) {
      final uri = Uri.parse('$apiBase/rest/api/3/issue/$issueKey/comment').replace(
        queryParameters: {
          'startAt': '$startAt',
          'maxResults': '$maxResults',
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

      final pageItems = _extractComments(
        rawComments: body,
        accountToUser: accountToUser,
        start: start,
        end: end,
      );
      results.addAll(pageItems);

      final total = int.tryParse(body['total']?.toString() ?? '') ?? 0;
      final values = body['comments'];
      final fetchedCount = values is List ? values.length : 0;
      if (fetchedCount == 0) break;

      startAt += fetchedCount;
      if (startAt >= total) break;
    }

    results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return results;
  }

  List<JiraIssueCommentDto> _mergeComments(
    List<JiraIssueCommentDto> fromSearch,
    List<JiraIssueCommentDto> fromCommentsApi,
  ) {
    final byId = <String, JiraIssueCommentDto>{};
    for (final c in fromSearch) {
      byId[c.id] = c;
    }
    for (final c in fromCommentsApi) {
      byId[c.id] = c;
    }
    final merged = byId.values.toList();
    merged.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return merged;
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
