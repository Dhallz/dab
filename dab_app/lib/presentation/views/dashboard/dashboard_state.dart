import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/upcoming/upcoming_event.dart';
import 'models/dashboard_banner.dart';
import 'models/dashboard_provider_health.dart';

part 'dashboard_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Dashboard screen state.
/// CONTRACT: Immutable; exclusively emitted by [DashboardNotifier]. Aggregates
/// Live Now activities, Upcoming Soon placeholder events, the currently
/// active banner, and user-facing triage preferences.
@MappableClass()
class DashboardState with DashboardStateMappable {
  final ViewStatus status;
  final List<Activity> activities;
  final List<UpcomingEvent> upcomingEvents;
  final DashboardBanner? activeBanner;
  final List<String> lastNotifiedEventIds;
  final bool showArchivedActivities;
  final List<DashboardProviderHealth> providerHealth;
  final DateTime? lastSyncedAt;
  final DateTime? reconnectNoticeAt;
  final int snoozedCount;
  final int reviewQueueCount;
  final String? errorMessage;

  const DashboardState({
    this.status = ViewStatus.initial,
    this.activities = const [],
    this.upcomingEvents = const [],
    this.activeBanner,
    this.lastNotifiedEventIds = const [],
    this.showArchivedActivities = false,
    this.providerHealth = const [],
    this.lastSyncedAt,
    this.reconnectNoticeAt,
    this.snoozedCount = 0,
    this.reviewQueueCount = 0,
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
