import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:uuid/uuid.dart';

part 'slack_message_dto.mapper.dart';

final _slackMessageUuid = const Uuid();

/// [ARCH: DOMAIN]
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
///
/// Polling attributes the row to [dabUserId]. Events API ingest passes
/// [forUserIds] so mention / broadcast fan-out keeps live activity ids
/// (`slack-{workspace}-{channel}-{ts}-{recipient}`).
extension OnSlackMessageDto on SlackMessageDto {
  List<Activity> toActivities(
    List<User> users, {
    Iterable<String>? forUserIds,
    Iterable<String>? followerUserIds,
    String? senderUserId,
  }) {
    final targets = resolveInboxLaneTargets(
      forUserIds: forUserIds,
      followerUserIds: followerUserIds,
      fallbackUserId: dabUserId,
    );
    if (targets.isEmpty) {
      return const [];
    }

    final usersById = {for (final user in users) user.id: user};
    final trimmedText = text.trim();
    final conversationLabel = (channelLabel ?? channelId).trim();
    final title = trimmedText.isEmpty
        ? '[$conversationLabel] Slack message'
        : '[$conversationLabel] ${_truncateSlackPreview(trimmedText)}';
    final content = trimmedText.isEmpty ? '(no message text)' : trimmedText;
    final fanOut = forUserIds != null || followerUserIds != null;

    final activities = <Activity>[];
    for (final (targetUserId, lane) in targets) {
      final user = usersById[targetUserId];
      if (user == null) continue;

      final stableIdentity = fanOut
          ? ('${workspaceId ?? 'workspace'}-$channelId-$ts-$targetUserId').withInboxLaneId(lane)
          : '${workspaceId ?? 'workspace'}-$channelId-${threadTs ?? ts}-$ts';

      activities.add(
        Activity(
          id: _slackMessageUuid.v5(
            Namespace.url.value,
            'slack-$stableIdentity',
          ),
          userId: targetUserId,
          senderUserId: senderUserId ?? dabUserId,
          provider: SlackMessageProvider(
            workspaceId: workspaceId,
            channelId: channelId,
            threadTs: threadTs,
            messageTs: ts,
          ),
          title: title,
          content: content,
          url: permalink,
          authorName: userUsername?.trim().isNotEmpty == true
              ? userUsername!.trim()
              : (userDisplayName ?? (fanOut ? '' : user.name)),
          authorAvatarUrl: fanOut
              ? userAvatarUrl
              : (userAvatarUrl ?? user.avatarUrl),
          createdAt: createdAt,
          inboxLane: lane,
        ),
      );
    }
    return activities;
  }
}

String _truncateSlackPreview(String text, {int max = 60}) {
  if (text.length <= max) {
    return text;
  }
  return '${text.substring(0, max - 1)}...';
}
