import 'package:dart_mappable/dart_mappable.dart';

part 'slack_message_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Slack messages.
/// CONTRACT: Represents the raw data shape from the Slack Web API.
///
/// This DTO is fetched by the [SlackMessageSource] and transformed 
/// into a [Domain Activity] by the [SlackMessageMapper].
@MappableClass()
class SlackMessageDto with SlackMessageDtoMappable {
  final String text;
  final String user;
  final String ts;
  final String channel;

  SlackMessageDto({
    required this.text,
    required this.user,
    required this.ts,
    required this.channel,
  });
}
