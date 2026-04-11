import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/activity/activity.dart';

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
