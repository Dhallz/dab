import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../domain/entities/user/user.dart';
import '../../core/models/view_status.dart';
import 'models/insights_date_preset.dart';
import 'models/insights_detail_row.dart';

part 'insights_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Immutable state snapshot for Insights analytics and filters.
@MappableClass()
class InsightsState with InsightsStateMappable {
  final ViewStatus status;
  final String? errorMessage;
  final List<Activity> activities;

  final List<User> users;
  final Set<String> selectedUserIds;

  final List<String> availableProviders;
  final Set<String> selectedProviders;

  final Set<ActivityCategory> availableActivityCategories;
  final Set<ActivityCategory> selectedActivityCategories;

  final InsightsDatePreset datePreset;
  final DateTime startDate;
  final DateTime endDate;

  const InsightsState({
    this.status = ViewStatus.initial,
    this.errorMessage,
    this.activities = const [],
    this.users = const [],
    this.selectedUserIds = const {},
    this.availableProviders = const [],
    this.selectedProviders = const {},
    this.availableActivityCategories = const {},
    this.selectedActivityCategories = const {},
    this.datePreset = InsightsDatePreset.last7Days,
    required this.startDate,
    required this.endDate,
  });

  factory InsightsState.initial() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final start = end.subtract(const Duration(days: 6));
    return InsightsState(startDate: start, endDate: end);
  }
}

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Derived analytics projections for the Insights screen.
extension OnInsightsState on InsightsState {
  int get totalActivities => activities.length;

  int get activeUsersCount =>
      activities.map((item) => item.userId).toSet().length;

  int get activeProvidersCount => providerCounts.length;

  Map<String, int> get providerCounts {
    final counts = <String, int>{};
    for (final activity in activities) {
      final key = activity.provider.name;
      counts.update(key, (current) => current + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  Map<ActivityCategory, int> get categoryCounts {
    final counts = <ActivityCategory, int>{};
    for (final activity in activities) {
      final key = activity.provider.category;
      counts.update(key, (current) => current + 1, ifAbsent: () => 1);
    }
    return counts;
  }

  Map<String, int> get userCounts {
    final counts = <String, int>{};
    for (final activity in activities) {
      counts.update(
        activity.userId,
        (current) => current + 1,
        ifAbsent: () => 1,
      );
    }
    return counts;
  }

  ActivityCategory? get mostFrequentCategory {
    if (categoryCounts.isEmpty) return null;
    final sorted = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  Map<DateTime, int> get dailyCounts {
    final buckets = <DateTime, int>{};
    final normalizedStart = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
    );
    final normalizedEnd = DateTime(endDate.year, endDate.month, endDate.day);
    final dayCount = normalizedEnd.difference(normalizedStart).inDays;
    for (var i = 0; i <= dayCount; i++) {
      final day = normalizedStart.add(Duration(days: i));
      buckets[day] = 0;
    }

    for (final activity in activities) {
      final day = DateTime(
        activity.createdAt.year,
        activity.createdAt.month,
        activity.createdAt.day,
      );
      if (buckets.containsKey(day)) {
        buckets.update(day, (value) => value + 1);
      }
    }
    return buckets;
  }

  List<InsightsDetailRow> detailRows(Map<String, String> userNameById) {
    final total = totalActivities == 0 ? 1 : totalActivities;
    final rows = <InsightsDetailRow>[
      ...providerCounts.entries.map(
        (entry) => InsightsDetailRow(
          kind: InsightsDetailRowKind.provider,
          label: entry.key,
          count: entry.value,
          share: '${((entry.value / total) * 100).toStringAsFixed(1)}%',
        ),
      ),
      ...categoryCounts.entries.map(
        (entry) => InsightsDetailRow(
          kind: InsightsDetailRowKind.activityType,
          label: entry.key.name,
          count: entry.value,
          share: '${((entry.value / total) * 100).toStringAsFixed(1)}%',
        ),
      ),
      ...userCounts.entries.map(
        (entry) => InsightsDetailRow(
          kind: InsightsDetailRowKind.user,
          label: userNameById[entry.key] ?? entry.key,
          count: entry.value,
          share: '${((entry.value / total) * 100).toStringAsFixed(1)}%',
        ),
      ),
    ]..sort((a, b) => b.count.compareTo(a.count));
    return rows;
  }
}
