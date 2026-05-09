import 'package:dart_mappable/dart_mappable.dart';

part 'discord_message_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Discord messages.
/// CONTRACT: Represents the raw data shape from the Discord REST API.
///
/// This DTO is fetched by the [DiscordMessageSource] and transformed
/// into a [Domain Activity] by the [DiscordMessageMapper].
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
