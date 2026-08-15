import 'package:dab_api/src/domain/dtos/discord/discord_message_dto.dart';

/// [ARCH: DOMAIN]
/// ROLE: Maps Discord REST / Gateway message JSON into [DiscordMessageDto].

/// Maps one Discord message JSON object (REST response row or Gateway
/// `MESSAGE_CREATE` dispatch data) into a [DiscordMessageDto].
///
/// Returns null for malformed rows and for bot/system authors.
/// [externalToUser] maps Discord user snowflakes to DAB user ids.
DiscordMessageDto? mapDiscordMessageJson(
  Map<String, dynamic> json, {
  required String fallbackChannelId,
  String? guildId,
  Map<String, String> externalToUser = const {},
}) {
  final messageId = (json['id'] ?? '').toString().trim();
  if (messageId.isEmpty) return null;

  final author = json['author'];
  if (author is! Map<String, dynamic>) return null;
  if (author['bot'] == true || author['system'] == true) return null;
  final authorId = (author['id'] ?? '').toString().trim();
  if (authorId.isEmpty) return null;

  final timestampRaw = json['timestamp']?.toString();
  final createdAt = timestampRaw != null
      ? DateTime.tryParse(timestampRaw)?.toUtc()
      : null;
  if (createdAt == null) return null;

  final channelId = (json['channel_id'] ?? '').toString().trim().isEmpty
      ? fallbackChannelId
      : (json['channel_id'] ?? '').toString().trim();

  final avatarHash = (author['avatar'] ?? '').toString().trim();
  final avatarUrl = avatarHash.isEmpty
      ? null
      : 'https://cdn.discordapp.com/avatars/$authorId/$avatarHash.png';

  final reference = json['message_reference'];
  final replyToId = reference is Map<String, dynamic>
      ? (reference['message_id'] ?? '').toString().trim()
      : '';

  final displayName =
      ((author['global_name'] ?? author['username']) ?? '').toString().trim();

  return DiscordMessageDto(
    messageId: messageId,
    channelId: channelId,
    guildId: (json['guild_id'] ?? guildId)?.toString().trim(),
    content: (json['content'] ?? '').toString(),
    authorId: authorId,
    createdAt: createdAt,
    authorDisplayName: displayName.isEmpty ? null : displayName,
    authorAvatarUrl: avatarUrl,
    replyToId: replyToId.isEmpty ? null : replyToId,
    dabUserId: externalToUser[authorId],
  );
}
