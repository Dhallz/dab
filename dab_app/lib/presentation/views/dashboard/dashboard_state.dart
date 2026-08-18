import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import 'models/dashboard_feed_group.dart';
import 'models/dashboard_feed_mode.dart';
import 'models/dashboard_provider_health.dart';
import 'models/dashboard_watching_placeholder.dart';

part 'dashboard_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Dashboard screen state.
/// CONTRACT: Immutable; exclusively emitted by [DashboardNotifier]. Aggregates
/// Live Now activities, connection-based provider health, last-sync, archive
/// visibility, and feed layout mode.
@MappableClass()
class DashboardState with DashboardStateMappable {
  final ViewStatus status;
  final List<Activity> activities;
  final bool showArchivedActivities;
  final DashboardFeedMode feedMode;
  final List<DashboardProviderHealth> providerHealth;
  final DateTime? lastSyncedAt;
  final DateTime? reconnectNoticeAt;
  final String? errorMessage;
  final List<ActivityFollow> follows;
  final String followSearchQuery;
  final List<FollowCandidate> followCandidates;
  final ViewStatus followSearchStatus;

  const DashboardState({
    this.status = ViewStatus.initial,
    this.activities = const [],
    this.showArchivedActivities = false,
    this.feedMode = DashboardFeedMode.timeline,
    this.providerHealth = const [],
    this.lastSyncedAt,
    this.reconnectNoticeAt,
    this.errorMessage,
    this.follows = const [],
    this.followSearchQuery = '',
    this.followCandidates = const [],
    this.followSearchStatus = ViewStatus.initial,
  });

  factory DashboardState.initial() => const DashboardState();

  /// Returns the subset of [activities] that should be rendered in the
  /// Live Now list, honouring the [showArchivedActivities] toggle.
  List<Activity> get visibleActivities {
    if (showArchivedActivities) return activities;
    return activities.where((activity) => !activity.archived).toList();
  }

  /// Directed pane: mentions, assignments, CCs, git watches.
  /// Legacy live JSON without [Activity.inboxLane] is treated as directed.
  List<Activity> get directedVisible =>
      visibleActivities.where((activity) => !activity.isFollowLane).toList();

  /// Follow pane: later updates on Follow-pinned objects.
  List<Activity> get followedVisible =>
      visibleActivities.where((activity) => activity.isFollowLane).toList();

  /// Stable Follow refs for the current [follows] pins.
  List<String> get followedObjectRefs => [
    for (final follow in follows) follow.objectRef,
  ];

  /// Quiet Follow pins that do not already have a Follow-lane live card.
  List<ActivityFollow> get watchingPins {
    final covered = <String>{
      for (final activity in followedVisible)
        ?followObjectRefFor(activity.provider),
    };
    return [
      for (final follow in follows)
        if (!covered.contains(follow.objectRef)) follow,
    ];
  }

  /// Picker rows that are not already Follow-pinned.
  List<FollowCandidate> get followPickerVisible => [
    for (final row in followCandidates)
      if (!followedObjectRefs.contains(row.objectRef)) row,
  ];

  int get archivedCount =>
      activities.where((activity) => activity.archived).length;

  /// Whether [activity] is currently Follow-pinned.
  bool isFollowing(Activity activity) {
    final ref = followObjectRefFor(activity.provider);
    return ref != null && followedObjectRefs.contains(ref);
  }
}

/// Derived feed projections so widgets stay layout-only.
extension OnDashboardState on DashboardState {
  /// Following pane items: quiet pin cards first, then Follow-lane live cards.
  List<Activity> get followedFeed => [
    for (final pin in watchingPins) watchingPlaceholderActivity(pin),
    ...followedVisible,
  ];

  /// Category containers for the current [visibleActivities] subset.
  List<DashboardFeedGroup> get categoryGroups =>
      deriveCategoryFeedGroups(visibleActivities);

  /// Provider containers for activated health rows plus unmatched feed names.
  List<DashboardFeedGroup> get providerGroups => deriveProviderFeedGroups(
    visible: visibleActivities,
    providerHealth: providerHealth,
  );

  /// Category containers for a pane's visible subset.
  List<DashboardFeedGroup> categoryGroupsFor(List<Activity> visible) =>
      deriveCategoryFeedGroups(visible);

  /// Provider containers for a pane's visible subset.
  List<DashboardFeedGroup> providerGroupsFor(List<Activity> visible) =>
      deriveProviderFeedGroups(
        visible: visible,
        providerHealth: providerHealth,
      );
}
