import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';
import '../../dtos/linear/linear_issue_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Linear Issue retrieval.
/// CONTRACT: Fetches technical [LinearIssueDto] from Linear GraphQL API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class LinearIssueSource implements IActivitySource<LinearIssueDto> {
  /// Placeholder for the Linear GraphQL Client.
  LinearIssueSource();

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
}
