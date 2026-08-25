import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../domain/entities/user/jira_project_watch_list.dart';
import '../../../domain/contracts/ports/abs_i_credential_resolver.dart';
import '../../../domain/contracts/ports/abs_i_follow_candidate_catalog.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../protocols/rest/json_rest_protocol.dart';
import 'jira_jql.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Lists Jira issues for the Follow picker. Read-only.
/// CONTRACT: Empty [query] is involved (assignee/watcher/reporter). A typed
/// query matches summary **contains** or issue key (including `PROJ-n` when
/// [query] is numeric and [projectKeys] is set).
class JiraFollowCandidateCatalog implements AbsIFollowCandidateCatalog {
  JiraFollowCandidateCatalog(this._configs, this._credentials, this._jsonRest);

  final AbsIProviderConfigRepository _configs;
  final AbsICredentialResolver _credentials;
  final JsonRestProtocol _jsonRest;

  @override
  String get providerId => 'jira';

  @override
  Future<Either<Failure, List<FollowCandidate>>> list({
    required String userId,
    required String query,
  }) async {
    try {
      return Right(await _list(userId: userId, query: query));
    } catch (_) {
      return const Right([]);
    }
  }

  Future<List<FollowCandidate>> _list({
    required String userId,
    required String query,
  }) async {
    final org = await _activeConfig();
    if (org == null) return const [];
    final userSettings = await _credentials.getUserSettings(
      userId: userId,
      providerId: 'jira',
    );
    final merged = _credentials.overlay(
      orgSettings: org.settings,
      userSettings: userSettings,
    );
    final auth = jiraRequestAuth(merged, orgConfig: org);
    if (auth == null) return const [];

    final projectKeys = (org.settings['projectKeys'] as Object?).parseJiraProjectKeys();
    final q = query.trim();
    final jql = q.isEmpty
        ? _involvedJql(projectKeys: projectKeys)
        : _searchJql(projectKeys: projectKeys, query: q);
    if (jql == null) return const [];

    final uri = Uri.parse('${auth.apiBase}/rest/api/3/search/jql').replace(
      queryParameters: {
        'jql': jql,
        'maxResults': '25',
        'fields': 'key,summary',
      },
    );
    final body = await _jsonRest.getJsonMap(
      uri,
      headers: {...auth.headers, 'Accept': 'application/json'},
    );
    final issues = body['issues'];
    if (issues is! List) return const [];
    final out = <FollowCandidate>[];
    for (final item in issues) {
      if (item is! Map) continue;
      final key = (item['key'] ?? '').toString().trim();
      if (key.isEmpty) continue;
      final fields = item['fields'];
      final summary = fields is Map
          ? (fields['summary'] ?? '').toString().trim()
          : '';
      final title = summary.isEmpty ? key : '[$key] $summary';
      out.add(
        FollowCandidate(
          providerId: 'jira',
          objectKey: key,
          title: title,
          url: 'https://${auth.browseHost}/browse/$key',
        ),
      );
    }
    return out;
  }

  static final _issueKey = RegExp(r'^([A-Za-z][A-Za-z0-9_]*)-(\d+)$');

  String _involvedJql({required List<String> projectKeys}) {
    final parts = <String>[
      'resolution = Unresolved',
      '(assignee = currentUser() OR watcher = currentUser() OR reporter = currentUser())',
    ];
    if (projectKeys.isNotEmpty) {
      parts.add('project in (${projectKeys.join(', ')})');
    }
    return '${parts.join(' AND ')} ORDER BY updated DESC';
  }

  /// Workspace search by summary contains, exact key, or `PROJ-{n}` when
  /// [query] is numeric. Returns null when [projectKeys] excludes the typed
  /// project.
  String? _searchJql({
    required List<String> projectKeys,
    required String query,
  }) {
    final escaped = query.replaceAll('"', '\\"');
    final key = _issueKey.firstMatch(query);
    if (key != null) {
      final project = key.group(1)!;
      if (projectKeys.isNotEmpty && !projectKeys.contains(project)) {
        return null;
      }
    }
    final clauses = <String>[
      'summary ~ "$escaped"',
      'key = "$escaped"',
    ];
    if (key == null) {
      final n = int.tryParse(query);
      if (n != null) {
        for (final project in projectKeys) {
          clauses.add('key = "$project-$n"');
        }
      }
    }
    final parts = <String>['(${clauses.join(' OR ')})'];
    if (projectKeys.isNotEmpty) {
      parts.add('project in (${projectKeys.join(', ')})');
    }
    return '${parts.join(' AND ')} ORDER BY updated DESC';
  }

  Future<ProviderConfig?> _activeConfig() async {
    final configs = (await _configs.getConfigs()).getOrElse((_) => const []);
    for (final c in configs) {
      if (c.id == 'jira' && c.isActive) return c;
    }
    return null;
  }
}
