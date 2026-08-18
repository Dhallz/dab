import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/linear_team.dart';
import '../../../domain/contracts/ports/abs_i_linear_team_catalog.dart';
import '../../protocols/graphql/graphql_protocol.dart';
import '../../protocols/protocol_exceptions.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: GraphQL `teams` listing for the Linear watch-list picker. Read-only.
class LinearTeamCatalog implements AbsILinearTeamCatalog {
  LinearTeamCatalog(this._graphql);

  final GraphqlProtocol _graphql;

  static const _defaultEndpoint = 'https://api.linear.app/graphql';

  static const _teamsQuery = '''
query DabTeams(\$first: Int!, \$after: String) {
  teams(first: \$first, after: \$after) {
    nodes { key name }
    pageInfo { hasNextPage endCursor }
  }
}
''';

  @override
  Future<Either<Failure, List<LinearTeam>>> listAccessible({
    required Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  }) async {
    final token = extractProviderToken('linear', settings);
    if (token.isEmpty) {
      return const Left(ValidationFailure('Linear credentials are incomplete'));
    }
    final raw = (settings['apiBaseUrl'] ?? '').toString().trim();
    final endpoint = Uri.parse(raw.isEmpty ? _defaultEndpoint : raw);

    try {
      final teams = <LinearTeam>[];
      final seen = <String>{};
      String? after;
      for (var page = 0; page < 20; page++) {
        final data = await _graphql.execute(
          endpoint,
          bearerToken: token,
          document: _teamsQuery,
          variables: {'first': 50, 'after': ?after},
        );
        final envelope = data['teams'];
        if (envelope is! Map<String, dynamic>) break;
        final nodes = envelope['nodes'];
        if (nodes is! List) break;
        for (final node in nodes) {
          if (node is! Map<String, dynamic>) continue;
          final key = (node['key'] ?? '').toString().trim();
          if (key.isEmpty || !seen.add(key)) continue;
          final name = (node['name'] ?? key).toString().trim();
          teams.add(LinearTeam(key: key, name: name.isEmpty ? key : name));
        }
        final pageInfo = envelope['pageInfo'];
        if (pageInfo is! Map<String, dynamic> ||
            pageInfo['hasNextPage'] != true) {
          break;
        }
        after = pageInfo['endCursor']?.toString();
        if (after == null || after.isEmpty) break;
      }
      teams.sort((a, b) => a.key.compareTo(b.key));
      return Right(teams);
    } on GraphqlProtocolException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (_) {
      return const Left(ValidationFailure('Could not list Linear teams'));
    }
  }
}
