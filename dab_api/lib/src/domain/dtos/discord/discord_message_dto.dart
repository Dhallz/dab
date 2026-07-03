import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'discord_message_dto.mapper.dart';

final _discordMessageUuid = const Uuid();

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Parsed Discord message (REST API or Gateway dispatch) for ingestion.
/// CONTRACT: [dabUserId] is resolved by the caller from linked `discord`
/// identities (external id = Discord user snowflake); rows without an
/// attributable user are skipped at mapping time.
///
/// Mapped to [Activity] via [OnDiscordMessageDto.toActivities].
@MappableClass()
class DiscordMessageDto with DiscordMessageDtoMappable {
  /// Message snowflake id.
  final String messageId;

  final String channelId;
  final String? guildId;

  /// Channel display label (`#general`) when known.
  final String? channelLabel;

  final String content;

  /// Author snowflake id.
  final String authorId;

  final String? authorDisplayName;
  final String? authorAvatarUrl;

  /// Referenced message id when this message is a reply.
  final String? replyToId;

  final DateTime createdAt;

  /// DAB user id when the author resolves to a linked Discord identity.
  final String? dabUserId;

  const DiscordMessageDto({
    required this.messageId,
    required this.channelId,
    required this.content,
    required this.authorId,
    required this.createdAt,
    this.guildId,
    this.channelLabel,
    this.authorDisplayName,
    this.authorAvatarUrl,
    this.replyToId,
    this.dabUserId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Discord message DTO → unified [`Activity`] (linked DAB user attribution).
/// CONSTRAINTS: Pure logic; skips rows without attributable DAB users.
extension OnDiscordMessageDto on DiscordMessageDto {
  List<Activity> toActivities(List<User> users) {
    final ownerId = dabUserId?.trim();
    if (ownerId == null || ownerId.isEmpty) return const [];
    final owner = users.where((u) => u.id == ownerId).firstOrNull;
    if (owner == null) return const [];

    final trimmedContent = content.trim();
    final conversationLabel = (channelLabel ?? channelId).trim();
    final title = trimmedContent.isEmpty
        ? '[$conversationLabel] Discord message'
        : '[$conversationLabel] ${_truncateDiscordPreview(trimmedContent)}';

    final gid = guildId?.trim();
    final url = (gid == null || gid.isEmpty)
        ? null
        : 'https://discord.com/channels/$gid/$channelId/$messageId';

    return [
      Activity(
        id: _discordMessageUuid.v5(Namespace.url.value, 'discord-$messageId'),
        userId: owner.id,
        provider: DiscordMessageProvider(
          guildId: guildId,
          channelId: channelId,
          messageId: messageId,
          replyToId: replyToId,
        ),
        title: title,
        content: trimmedContent.isEmpty ? '(no message text)' : trimmedContent,
        url: url,
        authorName: authorDisplayName?.trim().isNotEmpty == true
            ? authorDisplayName!.trim()
            : owner.name,
        authorAvatarUrl: authorAvatarUrl ?? owner.avatarUrl,
        createdAt: createdAt.toUtc(),
      ),
    ];
  }
}

String _truncateDiscordPreview(String text, {int max = 60}) {
  if (text.length <= max) {
    return text;
  }
  return '${text.substring(0, max - 1)}...';
}
