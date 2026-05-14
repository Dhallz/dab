import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'slack_message_dto.mapper.dart';

final _slackMessageUuid = const Uuid();

/// [ARCH: INFRASTRUCTURE_DTO]
/// ROLE: Technical DTO for Slack messages.
/// CONTRACT: Represents the raw data shape from the Slack Web API.
///
/// Mapped to [Activity] via [OnSlackMessageDto.toActivities].
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

/// [ARCH: DOMAIN]
/// ROLE: Slack message DTO → unified [`Activity`] (linked DAB user attribution).
extension OnSlackMessageDto on SlackMessageDto {
  List<Activity> toActivities(List<User> users) {
    final userId = dabUserId;
    if (userId == null || userId.isEmpty) {
      return const [];
    }

    final user = users.where((u) => u.id == userId).firstOrNull;
    if (user == null) {
      return const [];
    }

    final trimmedText = text.trim();
    final conversationLabel = (channelLabel ?? channelId).trim();
    final title = trimmedText.isEmpty
        ? '[$conversationLabel] Slack message'
        : '[$conversationLabel] ${_truncateSlackPreview(trimmedText)}';
    final stableIdentity =
        '${workspaceId ?? 'workspace'}-$channelId-${threadTs ?? ts}-$ts';

    return [
      Activity(
        id: _slackMessageUuid.v5(Namespace.url.value, 'slack-$stableIdentity'),
        userId: userId,
        provider: SlackMessageProvider(
          workspaceId: workspaceId,
          channelId: channelId,
          threadTs: threadTs,
          messageTs: ts,
        ),
        title: title,
        content: trimmedText.isEmpty ? '(no message text)' : trimmedText,
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

String _truncateSlackPreview(String text, {int max = 60}) {
  if (text.length <= max) {
    return text;
  }
  return '${text.substring(0, max - 1)}...';
}
