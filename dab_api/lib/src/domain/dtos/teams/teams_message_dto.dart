import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'teams_message_dto.mapper.dart';

final _teamsMessageUuid = const Uuid();

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Microsoft Teams messages.
/// CONTRACT: Represents the raw data shape from Microsoft Graph.
///
/// Mapped to [Activity] via [OnTeamsMessageDto.toActivities].
@MappableClass()
class TeamsMessageDto with TeamsMessageDtoMappable {
  final String teamId;
  final String channelId;
  final String? channelLabel;
  final String? tenantId;
  final String messageId;
  final String? replyToId;
  final String content;
  final String fromId;
  final String? permalink;
  final String? userDisplayName;
  final String? userUsername;
  final String? userAvatarUrl;
  final String? dabUserId;
  final DateTime createdAt;

  const TeamsMessageDto({
    required this.teamId,
    required this.channelId,
    required this.messageId,
    required this.content,
    required this.fromId,
    required this.createdAt,
    this.channelLabel,
    this.tenantId,
    this.replyToId,
    this.permalink,
    this.userDisplayName,
    this.userUsername,
    this.userAvatarUrl,
    this.dabUserId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Teams message DTO → unified [`Activity`] (linked DAB user attribution).
extension OnTeamsMessageDto on TeamsMessageDto {
  List<Activity> toActivities(List<User> users) {
    final userId = dabUserId;
    if (userId == null || userId.isEmpty) {
      return const [];
    }

    final user = users.where((u) => u.id == userId).firstOrNull;
    if (user == null) {
      return const [];
    }

    final trimmedContent = content.trim();
    final conversationLabel = (channelLabel ?? channelId).trim();
    final title = trimmedContent.isEmpty
        ? '[$conversationLabel] Teams message'
        : '[$conversationLabel] ${_truncateTeamsPreview(trimmedContent)}';
    final stableIdentity =
        '${tenantId ?? 'tenant'}-$teamId-$channelId-${replyToId ?? 'root'}-$messageId';

    return [
      Activity(
        id: _teamsMessageUuid.v5(Namespace.url.value, 'teams-$stableIdentity'),
        userId: userId,
        provider: TeamsMessageProvider(
          tenantId: tenantId,
          teamId: teamId,
          channelId: channelId,
          messageId: messageId,
          replyToId: replyToId,
        ),
        title: title,
        content: trimmedContent.isEmpty ? '(no message text)' : trimmedContent,
        url: permalink,
        authorName:
            userUsername?.trim().isNotEmpty == true
                ? userUsername!.trim()
                : (userDisplayName ?? user.name),
        authorAvatarUrl: userAvatarUrl ?? user.avatarUrl,
        createdAt: createdAt,
      ),
    ];
  }
}

String _truncateTeamsPreview(String text, {int max = 60}) {
  if (text.length <= max) {
    return text;
  }
  return '${text.substring(0, max - 1)}...';
}
