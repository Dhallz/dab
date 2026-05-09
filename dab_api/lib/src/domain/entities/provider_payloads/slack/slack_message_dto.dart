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
  final String channelId;
  final String? channelLabel;
  final String? workspaceId;
  final String text;
  final String userId;
  final String ts;
  final String? threadTs;
  final String? permalink;
  final String? userDisplayName;
  final String? userUsername;
  final String? userAvatarUrl;
  final String? dabUserId;
  final DateTime createdAt;

  const SlackMessageDto({
    required this.channelId,
    required this.text,
    required this.userId,
    required this.ts,
    required this.createdAt,
    this.channelLabel,
    this.workspaceId,
    this.threadTs,
    this.permalink,
    this.userDisplayName,
    this.userUsername,
    this.userAvatarUrl,
    this.dabUserId,
  });
}
