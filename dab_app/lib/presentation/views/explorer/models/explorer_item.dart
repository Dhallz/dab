import 'package:dart_mappable/dart_mappable.dart';

import '../../../../../domain/entities/activity/activity.dart';

part 'explorer_item.mapper.dart';

@MappableClass()
sealed class ExplorerItem with ExplorerItemMappable {
  const ExplorerItem();
}

@MappableClass()
class SingleActivityItem extends ExplorerItem with SingleActivityItemMappable {
  final Activity activity;
  const SingleActivityItem(this.activity);
}

@MappableClass()
class TaskActivityItem extends ExplorerItem with TaskActivityItemMappable {
  final List<Activity> activities;
  final bool isExpanded;

  /// The task identifier for grouping (e.g., PHID)
  final String taskId;
  final String userId;

  const TaskActivityItem({
    required this.activities,
    required this.taskId,
    required this.userId,
    this.isExpanded = false,
  });

  Activity get latestActivity => activities.first;
}

@MappableClass()
class SlackConversationItem extends ExplorerItem
    with SlackConversationItemMappable {
  final List<Activity> activities;
  final bool isExpanded;
  final String conversationKey;
  final String channelId;
  final String threadTs;

  const SlackConversationItem({
    required this.activities,
    required this.conversationKey,
    required this.channelId,
    required this.threadTs,
    this.isExpanded = false,
  });

  Activity get latestActivity => activities.first;
}
