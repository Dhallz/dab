import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../domain/entities/group/group.dart';
import '../../../../domain/entities/user/user.dart';
import '../../core/models/directory_type.dart';
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
  final DirectoryType directoryType;
  final List<Group> groups;
  final Set<String> selectedGroupIds;

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
    this.directoryType = DirectoryType.users,
    this.groups = const [],
    this.selectedGroupIds = const {},
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

  /// One count per org-calendar day in the selected range.
  ///
  /// Every activity in [activities] is included — Insights already scopes
  /// that list to the Directory selection (users or expanded group members),
  /// so a group or multi-select is the sum of those people.
  Map<String, int> dailyCounts([
    String orgTimezoneId = kDefaultOrgTimezoneId,
  ]) {
    final buckets = {
      for (final key in orgCalendarDayKeysInclusive(
        orgTimezoneId,
        startDate,
        endDate,
      ))
        key: 0,
    };
    for (final activity in activities) {
      final key = orgDayKeyFromUtc(orgTimezoneId, activity.createdAt);
      if (buckets.containsKey(key)) {
        buckets[key] = buckets[key]! + 1;
      }
    }
    return buckets;
  }

  /// Per-provider daily counts aligned with [dailyCounts] keys.
  ///
  /// Each provider's value on a day is the sum of matching activities from
  /// every selected user, not a single-user slice.
  Map<String, List<int>> trendProviderSeries([
    String orgTimezoneId = kDefaultOrgTimezoneId,
  ]) {
    final days = orgCalendarDayKeysInclusive(
      orgTimezoneId,
      startDate,
      endDate,
    );
    final dayIndex = {for (var i = 0; i < days.length; i++) days[i]: i};
    final series = <String, List<int>>{};
    for (final activity in activities) {
      final day = orgDayKeyFromUtc(orgTimezoneId, activity.createdAt);
      final index = dayIndex[day];
      if (index == null) continue;
      final counts = series.putIfAbsent(
        activity.provider.name,
        () => List<int>.filled(days.length, 0),
      );
      counts[index] += 1;
    }
    return series;
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
