import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import 'package:uuid/uuid.dart';
import 'package:dab_api/src/domain/entities/provider_payloads/slack/slack_message_dto.dart';

/// [ARCH: DOMAIN_MAPPER]
/// ROLE: Business Logic definer for Slack Message interpretation.
/// CONTRACT: Transforms technical [SlackMessageDto] into unified Domain [Activity] entities.
/// CONSTRAINTS: Must be a pure function.
class SlackMessageMapper implements IActivityMapper<SlackMessageDto> {
  final _uuid = const Uuid();

  @override
  String get providerName => 'slack';

  @override
  List<Activity> mapToActivities(SlackMessageDto data, List<User> users) {
    final userId = data.dabUserId;
    if (userId == null || userId.isEmpty) {
      return const [];
    }

    final user = users.where((u) => u.id == userId).firstOrNull;
    if (user == null) {
      return const [];
    }

    final trimmedText = data.text.trim();
    final conversationLabel = (data.channelLabel ?? data.channelId).trim();
    final title = trimmedText.isEmpty
        ? '[$conversationLabel] Slack message'
        : '[$conversationLabel] ${_truncate(trimmedText)}';
    final stableIdentity =
        '${data.workspaceId ?? 'workspace'}'
        '-${data.channelId}-${data.threadTs ?? data.ts}-${data.ts}';

    return [
      Activity(
        id: _uuid.v5(Namespace.url.value, 'slack-$stableIdentity'),
        userId: userId,
        provider: SlackMessageProvider(
          workspaceId: data.workspaceId,
          channelId: data.channelId,
          threadTs: data.threadTs,
          messageTs: data.ts,
        ),
        title: title,
        content: trimmedText.isEmpty ? '(no message text)' : trimmedText,
        url: data.permalink,
        authorName:
            data.userUsername?.trim().isNotEmpty == true
                ? data.userUsername!.trim()
                : (data.userDisplayName ?? user.name),
        authorAvatarUrl: data.userAvatarUrl ?? user.avatarUrl,
        createdAt: data.createdAt,
      ),
    ];
  }

  String _truncate(String text, {int max = 60}) {
    if (text.length <= max) {
      return text;
    }
    return '${text.substring(0, max - 1)}...';
  }
}
