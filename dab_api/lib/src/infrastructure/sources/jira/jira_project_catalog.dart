import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/jira_project.dart';
import '../../../domain/contracts/ports/i_jira_project_catalog.dart';
import '../../protocols/protocol_exceptions.dart';
import '../../protocols/rest/json_rest_protocol.dart';
import 'jira_jql.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Lists Jira Cloud projects for the Settings picker. Read-only.
/// CONTRACT: Prefers `/rest/api/3/project/search`, falls back to `/project`.
class JiraProjectCatalog implements IJiraProjectCatalog {
  JiraProjectCatalog(this._jsonRest);

  final JsonRestProtocol _jsonRest;

  @override
  Future<Either<Failure, List<JiraProject>>> listAccessible({
    required Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  }) async {
    final auth = jiraRequestAuth(settings, orgConfig: orgConfig);
    if (auth == null) {
      return const Left(ValidationFailure('Jira credentials are incomplete'));
    }
    try {
      final list = await listJiraProjectRows(_jsonRest, auth);
      final projects = <JiraProject>[];
      final seen = <String>{};
      for (final raw in list) {
        if (raw is! Map<String, dynamic>) continue;
        final key = (raw['key'] ?? '').toString().trim();
        if (key.isEmpty || !seen.add(key)) continue;
        final name = (raw['name'] ?? key).toString().trim();
        projects.add(JiraProject(key: key, name: name.isEmpty ? key : name));
      }
      projects.sort((a, b) => a.key.compareTo(b.key));
      return Right(projects);
    } on JsonRestProtocolException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) {
        return const Left(ValidationFailure('HTTP 401'));
      }
      return Left(ValidationFailure(e.message));
    } catch (_) {
      return const Left(ValidationFailure('Could not list Jira projects'));
    }
  }
}

/// Fetches raw Jira project rows for the picker and whoami discovery.
Future<List<dynamic>> listJiraProjectRows(
  JsonRestProtocol jsonRest,
  JiraRequestAuth auth,
) async {
  try {
    final body = await jsonRest.getJsonMap(
      Uri.parse(
        '${auth.apiBase}/rest/api/3/project/search',
      ).replace(queryParameters: const {'maxResults': '100'}),
      headers: auth.headers,
    );
    final values = body['values'];
    if (values is List) return values;
    } on JsonRestProtocolException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) rethrow;
      // Classic `/project` remains valid on some Cloud sites.
    }
  return jsonRest.getJsonList(
    Uri.parse('${auth.apiBase}/rest/api/3/project'),
    headers: auth.headers,
  );
}
