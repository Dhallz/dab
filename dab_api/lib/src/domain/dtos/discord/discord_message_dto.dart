import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'discord_message_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Discord messages.
/// CONTRACT: Represents the raw data shape from the Discord REST API.
///
/// Mapped to [Activity] via [OnDiscordMessageDto.toActivities].
@MappableClass()
class DiscordMessageDto with DiscordMessageDtoMappable {
  final String content;
  final String authorId;
  final String timestamp;
  final String channelId;

  const DiscordMessageDto({
    required this.content,
    required this.authorId,
    required this.timestamp,
    required this.channelId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Discord message DTO → [`Activity`] mapping (placeholder).
extension OnDiscordMessageDto on DiscordMessageDto {
  List<Activity> toActivities(List<User> users) {
    // TODO: Map Discord message data to unified Activity attributes.
    return [];
  }
}
