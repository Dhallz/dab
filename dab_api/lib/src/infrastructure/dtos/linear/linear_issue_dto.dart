import 'package:dart_mappable/dart_mappable.dart';

part 'linear_issue_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Linear Issues.
/// CONTRACT: Represents the raw data shape from the Linear GraphQL API.
///
/// This DTO is fetched by the [LinearIssueSource] and transformed 
/// into a [Domain Activity] by the [LinearIssueMapper].
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
