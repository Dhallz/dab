import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/activity/activity.dart';
import 'models/dashboard_provider_health.dart';

part 'dashboard_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Dashboard screen state.
/// CONTRACT: Immutable; exclusively emitted by [DashboardNotifier]. Aggregates
/// Live Now activities, provider health, last-sync, and archive visibility.
@MappableClass()
class DashboardState with DashboardStateMappable {
  final ViewStatus status;
  final List<Activity> activities;
  final bool showArchivedActivities;
  final List<DashboardProviderHealth> providerHealth;
  final DateTime? lastSyncedAt;
  final DateTime? reconnectNoticeAt;
  final String? errorMessage;

  const DashboardState({
    this.status = ViewStatus.initial,
    this.activities = const [],
    this.showArchivedActivities = false,
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
