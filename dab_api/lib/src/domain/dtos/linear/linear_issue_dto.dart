import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'linear_issue_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Linear Issues.
/// CONTRACT: Represents the raw data shape from the Linear GraphQL API.
///
/// Mapped to [Activity] via [OnLinearIssueDto.toActivities].
@MappableClass()
class LinearIssueDto with LinearIssueDtoMappable {
  final String identifier;
  final String title;
  final String status;
  final DateTime updatedAt;

  LinearIssueDto({
    required this.identifier,
    required this.title,
    required this.status,
    required this.updatedAt,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Linear issue DTO → [`Activity`] mapping (placeholder).
extension OnLinearIssueDto on LinearIssueDto {
  List<Activity> toActivities(List<User> users) {
    // TODO: Map Linear issue data to unified Activity attributes.
    return [];
  }
}
