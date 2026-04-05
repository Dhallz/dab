import 'package:dart_mappable/dart_mappable.dart';

part 'teams_message_dto.mapper.dart';

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Microsoft Teams messages.
/// CONTRACT: Represents the raw data shape from the MS Graph API.
///
/// This DTO is fetched by the [TeamsMessageSource] and transformed 
/// into a [Domain Activity] by the [TeamsMessageMapper].
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
