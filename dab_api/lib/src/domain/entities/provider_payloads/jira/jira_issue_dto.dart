import 'package:dart_mappable/dart_mappable.dart';

part 'jira_issue_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Jira Issues.
/// CONTRACT: Represents the raw data shape from the Jira REST API.
///
/// This DTO is fetched by the [JiraIssueSource] and transformed 
/// into a [Domain Activity] by the [JiraIssueMapper].
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
