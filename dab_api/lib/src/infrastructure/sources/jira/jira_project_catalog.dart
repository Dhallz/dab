import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/jira_project.dart';
import '../../../domain/ports/i_jira_project_catalog.dart';
import '../../protocols/protocol_exceptions.dart';
import '../../protocols/rest/json_rest_protocol.dart';
import 'jira_jql.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: GET /rest/api/3/project for the Jira project picker. Read-only.
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
      return const Left(
        ValidationFailure('Jira credentials are incomplete'),
      );
    }
    try {
      final list = await _jsonRest.getJsonList(
        Uri.parse('${auth.apiBase}/rest/api/3/project'),
        headers: auth.headers,
      );
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
      return Left(ValidationFailure(e.message));
    } catch (_) {
      return const Left(ValidationFailure('Could not list Jira projects'));
    }
  }
}
