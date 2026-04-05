import 'package:dab_api/src/domain/entities/activity.dart';
import 'package:dab_api/src/domain/entities/user.dart';
import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import '../../../infrastructure/dtos/discord/discord_message_dto.dart';

/// [ARCH: DOMAIN_MAPPER]
/// ROLE: Business Logic definer for Discord Message interpretation.
/// CONTRACT: Transforms technical [DiscordMessageDto] into unified Domain [Activity] entities.
/// CONSTRAINTS: Must be a pure function. Mapping is currently a placeholder.
class DiscordMessageMapper implements IActivityMapper<DiscordMessageDto> {
  @override
  String get providerName => 'Discord';

  @override
  List<Activity> mapToActivities(DiscordMessageDto data, List<User> users) {
    // TODO: Map Discord message data to unified Activity attributes.
    return [];
  }
}
