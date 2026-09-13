import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import 'dashboard_provider_health.dart';

/// [ARCH: PRESENTATION]
/// ROLE: One Dashboard container of activities that share a category or provider.
class DashboardFeedGroup {
  final String key;
  final ActivityCategory? category;
  final String? providerName;
  final List<Activity> activities;

  const DashboardFeedGroup({
    required this.key,
    this.category,
    this.providerName,
    this.activities = const [],
  });

  bool get isEmpty => activities.isEmpty;
}

/// Groups visible live-feed activities by [ActivityCategory].
///
/// Every [ActivityCategory] gets a container, even when quiet.
/// Order follows [ActivityCategory.values].
List<DashboardFeedGroup> deriveCategoryFeedGroups(List<Activity> visible) {
  final buckets = <ActivityCategory, List<Activity>>{};
  for (final activity in visible) {
    buckets.putIfAbsent(activity.type, () => []).add(activity);
  }
  return [
    for (final category in ActivityCategory.values)
      DashboardFeedGroup(
        key: category.name,
        category: category,
        activities: List<Activity>.unmodifiable(buckets[category] ?? const []),
      ),
  ];
}

/// Groups visible live-feed activities by provider.
///
/// Every Admin-activated provider in [providerHealth] gets a container, even
/// when quiet. Extra names that appear only on activities are appended.
List<DashboardFeedGroup> deriveProviderFeedGroups({
  required List<Activity> visible,
  required List<DashboardProviderHealth> providerHealth,
}) {
  final groups = <DashboardFeedGroup>[];
  final claimed = <String>{};

  for (final health in providerHealth) {
    final key = health.providerName.toLowerCase();
    claimed.add(key);
    groups.add(
      DashboardFeedGroup(
        key: key,
        providerName: health.providerName,
        activities: [
          for (final activity in visible)
            if (activity.provider.name.toLowerCase() == key) activity,
        ],
      ),
    );
  }

  final extras = <String, List<Activity>>{};
  for (final activity in visible) {
    final key = activity.provider.name.toLowerCase();
    if (claimed.contains(key)) continue;
    extras.putIfAbsent(key, () => []).add(activity);
  }
  for (final entry in extras.entries) {
    groups.add(
      DashboardFeedGroup(
        key: entry.key,
        providerName: entry.value.first.provider.name,
        activities: List<Activity>.unmodifiable(entry.value),
      ),
    );
  }

  groups.sort(
    (a, b) => (a.providerName ?? a.key).toLowerCase().compareTo(
      (b.providerName ?? b.key).toLowerCase(),
    ),
  );
  return groups;
}
