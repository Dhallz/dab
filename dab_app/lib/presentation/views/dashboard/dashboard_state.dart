import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/activity/activity.dart';
import 'models/dashboard_feed_group.dart';
import 'models/dashboard_feed_mode.dart';
import 'models/dashboard_provider_health.dart';

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

  const DashboardState({
    this.status = ViewStatus.initial,
    this.activities = const [],
    this.showArchivedActivities = false,
    this.feedMode = DashboardFeedMode.timeline,
    this.providerHealth = const [],
    this.lastSyncedAt,
    this.reconnectNoticeAt,
    this.errorMessage,
  });

  factory DashboardState.initial() => const DashboardState();

  /// Returns the subset of [activities] that should be rendered in the
  /// Live Now list, honouring the [showArchivedActivities] toggle.
  List<Activity> get visibleActivities {
    if (showArchivedActivities) return activities;
    return activities.where((activity) => !activity.archived).toList();
  }

  int get archivedCount =>
      activities.where((activity) => activity.archived).length;
}

/// Derived feed projections so widgets stay layout-only.
extension OnDashboardState on DashboardState {
  /// Category containers for the current [visibleActivities] subset.
  List<DashboardFeedGroup> get categoryGroups =>
      deriveCategoryFeedGroups(visibleActivities);

  /// Provider containers for activated health rows plus unmatched feed names.
  List<DashboardFeedGroup> get providerGroups => deriveProviderFeedGroups(
    visible: visibleActivities,
    providerHealth: providerHealth,
  );
}
