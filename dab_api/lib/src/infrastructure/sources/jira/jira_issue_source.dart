import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/services/abs_i_discovery_source.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import '../../dtos/jira/jira_issue_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Jira Issue retrieval.
/// CONTRACT: Fetches technical [JiraIssueDto] from Jira Cloud REST API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class JiraIssueSource implements IActivitySource<JiraIssueDto>, IDiscoverySource {
  /// Placeholder for the Jira Cloud Client.
  JiraIssueSource();

  @override
  Future<List<JiraIssueDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    // TODO: Implement Jira Cloud REST API issue retrieval by JQL.
    return [];
  }

  @override
  Future<Either<Failure, String?>> lookupExternalId(String name, String email) async {
    // TODO: Implement Jira user lookup by email.
    return const Right(null);
  }
}
