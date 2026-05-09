import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/services/abs_i_discovery_source.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/graphql_protocol.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import 'package:dab_api/src/domain/entities/provider_payloads/linear/linear_issue_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Linear Issue retrieval.
/// CONTRACT: Fetches technical [LinearIssueDto] from Linear GraphQL API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class LinearIssueSource implements IActivitySource<LinearIssueDto>, IDiscoverySource {
  /// Wired for Linear GraphQL reads (currently unused while fetch is stubbed).
  // ignore: unused_field
  final GraphqlProtocol _graphql;

  /// Wire adapter for Linear GraphQL (`graphql_protocol`).
  LinearIssueSource(this._graphql);

  @override
  Future<List<LinearIssueDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    // TODO: Implement Linear GraphQL API issue retrieval.
    return [];
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(String name, String email) async {
    // TODO: Implement Linear user lookup by email.
    return const Right(null);
  }
}
