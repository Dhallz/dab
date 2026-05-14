import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'jira_issue_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Jira Issues.
/// CONTRACT: Represents the raw data shape from the Jira REST API.
///
/// Mapped to [Activity] via [OnJiraIssueDto.toActivities].
@MappableClass()
class JiraIssueDto with JiraIssueDtoMappable {
  final String key;
  final String summary;
  final String status;
  final DateTime updated;

  JiraIssueDto({
    required this.key,
    required this.summary,
    required this.status,
    required this.updated,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Jira issue → [`Activity`] mapping (placeholder until issue fields are modeled).
extension OnJiraIssueDto on JiraIssueDto {
  List<Activity> toActivities(List<User> users) {
    // TODO: Map Jira issue data to unified Activity attributes.
    return [];
  }
}
