import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';
import 'package:dab_api/src/domain/entities/provider_payloads/discord/discord_message_dto.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Raw I/O Handler for Discord Message retrieval.
/// CONTRACT: Fetches technical [DiscordMessageDto] from Discord REST API.
/// CONSTRAINTS: Must be READ-ONLY. Placeholder implementation.
class DiscordMessageSource implements IActivitySource<DiscordMessageDto> {
  /// Placeholder for the Discord API Client.
  DiscordMessageSource();

  @override
  Future<List<DiscordMessageDto>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    // TODO: Implement Discord REST API message retrieval.
    return [];
  }
}
