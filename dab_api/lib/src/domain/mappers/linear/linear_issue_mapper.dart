import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import 'package:dab_api/src/domain/entities/provider_payloads/linear/linear_issue_dto.dart';

/// [ARCH: DOMAIN_MAPPER]
/// ROLE: Business Logic definer for Linear Issue interpretation.
/// CONTRACT: Transforms technical [LinearIssueDto] into unified Domain [Activity] entities.
/// CONSTRAINTS: Must be a pure function. Mapping is currently a placeholder.
class LinearIssueMapper implements IActivityMapper<LinearIssueDto> {
  @override
  String get providerName => 'Linear';

  @override
  List<Activity> mapToActivities(LinearIssueDto data, List<User> users) {
    // TODO: Map Linear issue data to unified Activity attributes.
    return [];
  }
}
