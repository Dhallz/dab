import 'dart:math' as math;

import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../domain/entities/group/group.dart';
import '../../../../domain/entities/user/user.dart';
import '../../core/extensions/activity_extensions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../core/styles/app_colors.dart';
import 'models/directory_type.dart';
import 'models/explorer_activity_kind_summary.dart';
import 'models/explorer_date_mode.dart';
import 'models/explorer_item.dart';

part 'explorer_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Explorer screen state.
@MappableClass()
class ExplorerState with ExplorerStateMappable {
  final ViewStatus status;
  final List<ExplorerItem> items;
  final String? errorMessage;
  final DateTime selectedDate;
  final ExplorerDateMode dateMode;
  final DateTime? rangeStartDate;
  final DateTime? rangeEndDate;

  // Directory
  final DirectoryType directoryType;
  final List<User> users;
  final List<Group> groups;
  final Set<String> selectedUserIds;
  final Set<String> selectedGroupIds;

  // Filters
  final Set<ActivityCategory> availableActivityCategories;
  final Set<ActivityCategory> selectedActivityCategories;
  final List<String> availableProviders;
  final Set<String> selectedProviders;

  const ExplorerState({
    this.status = ViewStatus.initial,
    this.items = const [],
    this.errorMessage,
    required this.selectedDate,
    this.dateMode = ExplorerDateMode.singleDay,
    this.rangeStartDate,
    this.rangeEndDate,
    this.directoryType = DirectoryType.users,
    this.users = const [],
    this.groups = const [],
    this.selectedUserIds = const {},
    this.selectedGroupIds = const {},
    this.availableActivityCategories = const {
      ActivityCategory.commit,
      ActivityCategory.revision,
      ActivityCategory.task,
      ActivityCategory.message,
      ActivityCategory.generic,
    },
    this.selectedActivityCategories = const {
      ActivityCategory.commit,
      ActivityCategory.revision,
      ActivityCategory.task,
      ActivityCategory.message,
      ActivityCategory.generic,
    },
    this.availableProviders = const [],
    this.selectedProviders = const {},
  });

  factory ExplorerState.initial() =>
      ExplorerState(selectedDate: DateTime.now());
}

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Derived Explorer island-bar projections from [ExplorerState].
extension OnExplorerState on ExplorerState {
  /// All [Activity] instances currently represented in [items] (flattened stacks).
  List<Activity> get flattenedExplorerActivities {
    final result = <Activity>[];
    for (final item in items) {
      switch (item) {
        case SingleActivityItem(:final activity):
          result.add(activity);
        case TaskActivityItem(:final activities):
          result.addAll(activities);
        case SlackConversationItem(:final activities):
          result.addAll(activities);
      }
    }
    return result;
  }

  /// Number of calendar days included in the current date selection.
  int get explorerSelectedDayCount {
    if (dateMode == ExplorerDateMode.singleDay) {
      return 1;
    }
    final start = rangeStartDate ?? selectedDate;
    final end = rangeEndDate ?? selectedDate;
    final days = end.difference(start).inDays.abs() + 1;
    return days <= 0 ? 1 : days;
  }

  /// Number of users/groups in scope for heat normalisation (minimum 1).
  int get explorerSelectedScopeCount {
    if (directoryType == DirectoryType.users) {
      return selectedUserIds.isEmpty ? 1 : selectedUserIds.length;
    }
    final ids = <String>{};
    for (final groupId in selectedGroupIds) {
      final matching = groups.where((g) => g.id == groupId);
      if (matching.isEmpty) {
        continue;
      }
      final group = matching.first;
      ids.addAll(group.members.map((m) => m.id));
    }
    return ids.isEmpty ? 1 : ids.length;
  }

  /// Heat metric used for the aggregate “activity” summary and intensity bar.
  int heatMetricForActivityTotal(int totalCount) {
    final units = (explorerSelectedDayCount * explorerSelectedScopeCount).clamp(
      1,
      1000000,
    );
    final avgPerUnit = totalCount / units;
    final volumePerSqrtUnit = totalCount / math.sqrt(units);
    final heatScore = (0.8 * avgPerUnit) + (0.2 * volumePerSqrtUnit);
    return heatScore.ceil();
  }

  /// Accent color for a heat [count] (island bar strip + vertical bar).
  Color heatAccentColorForIntensity(int count) {
    if (count >= 8) {
      return const Color(0xFFFF1744);
    }
    if (count >= 6) {
      return const Color(0xFFFF3D00);
    }
    if (count >= 4) {
      return const Color(0xFFAEEA00);
    }
    if (count >= 2) {
      return const Color(0xFF00E5FF);
    }
    return AppColors.primary;
  }

  /// One summary chip per known granular key for the Explorer island bar.
  List<ExplorerActivityKindSummary> islandActivityKindSummaries(
    BuildContext context,
  ) {
    const allKeys = <String>[
      'comment',
      'tag',
      'status',
      'review',
      'assignment',
      'commit',
      'message',
      'activity',
    ];
    final counts = <String, int>{};
    final activeColors = <String, Color>{};
    final activities = flattenedExplorerActivities;
    final totalActivityCount = activities.length;
    final totalHeatCount = heatMetricForActivityTotal(totalActivityCount);

    for (final activity in activities) {
      final key = activity.granularKey();
      counts.update(key, (v) => v + 1, ifAbsent: () => 1);
      activeColors.putIfAbsent(key, () => activity.style(context).color);
    }

    return allKeys.map((key) {
      final count = key == 'activity' ? totalActivityCount : (counts[key] ?? 0);
      final color = count == 0
          ? const Color(0xFF64748B)
          : (key == 'activity'
                ? heatAccentColorForIntensity(totalHeatCount)
                : (activeColors[key] ?? const Color(0xFF94A3B8)));
      return ExplorerActivityKindSummary(
        label: key.islandSummaryLabel(context),
        count: count,
        icon: key.islandSummaryIcon,
        color: color,
      );
    }).toList();
  }
}
