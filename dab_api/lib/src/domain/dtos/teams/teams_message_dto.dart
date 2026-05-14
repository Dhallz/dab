import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'teams_message_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Microsoft Teams messages.
/// CONTRACT: Represents the raw data shape from the MS Graph API.
///
/// Mapped to [Activity] via [OnTeamsMessageDto.toActivities].
@MappableClass()
class TeamsMessageDto with TeamsMessageDtoMappable {
  final String content;
  final String fromId;
  final DateTime createdDateTime;
  final String channelId;

  TeamsMessageDto({
    required this.content,
    required this.fromId,
    required this.createdDateTime,
    required this.channelId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Teams message DTO → [`Activity`] mapping (placeholder).
extension OnTeamsMessageDto on TeamsMessageDto {
  List<Activity> toActivities(List<User> users) {
    // TODO: Map Teams message data to unified Activity attributes.
    return [];
  }
}
