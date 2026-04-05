import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';
import '../../dtos/jira/jira_issue_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Jira Issue retrieval.
/// CONTRACT: Fetches technical [JiraIssueDto] from Jira Cloud REST API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class JiraIssueSource implements IActivitySource<JiraIssueDto> {
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
}
