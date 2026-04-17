import 'package:dart_mappable/dart_mappable.dart';

part 'dashboard_event.mapper.dart';

@MappableClass()
sealed class DashboardEvent with DashboardEventMappable {
  const DashboardEvent();
}

/// Kicks off initial loading (live feed + upcoming events) and starts
/// subscriptions.
@MappableClass()
class DashboardStarted extends DashboardEvent with DashboardStartedMappable {
  const DashboardStarted();
}

/// A new live activity arrived via the WS stream.
@MappableClass()
class DashboardActivityReceived extends DashboardEvent
    with DashboardActivityReceivedMappable {
  final dynamic activity;
  const DashboardActivityReceived(this.activity);
}

/// A WS `ACTIVITY_ARCHIVED` event from any session owned by this user.
@MappableClass()
class DashboardActivityArchivedRemotely extends DashboardEvent
    with DashboardActivityArchivedRemotelyMappable {
  final String activityId;
  const DashboardActivityArchivedRemotely(this.activityId);
}

/// A WS `ACTIVITY_UNARCHIVED` event from any session owned by this user.
@MappableClass()
class DashboardActivityUnarchivedRemotely extends DashboardEvent
    with DashboardActivityUnarchivedRemotelyMappable {
  final String activityId;
  const DashboardActivityUnarchivedRemotely(this.activityId);
}

/// User requested to archive a live activity from the UI.
@MappableClass()
class DashboardArchiveActivityRequested extends DashboardEvent
    with DashboardArchiveActivityRequestedMappable {
  final String activityId;
  const DashboardArchiveActivityRequested(this.activityId);
}

/// User requested to restore an archived live activity.
@MappableClass()
class DashboardUnarchiveActivityRequested extends DashboardEvent
    with DashboardUnarchiveActivityRequestedMappable {
  final String activityId;
  const DashboardUnarchiveActivityRequested(this.activityId);
}

/// User toggled the Show archived / Hide archived switch.
@MappableClass()
class DashboardArchivedVisibilityToggled extends DashboardEvent
    with DashboardArchivedVisibilityToggledMappable {
  const DashboardArchivedVisibilityToggled();
}

/// Internal tick used by the banner evaluator to re-check upcoming events
/// against the current wall-clock time.
@MappableClass()
class DashboardBannerTick extends DashboardEvent
    with DashboardBannerTickMappable {
  const DashboardBannerTick();
}

/// User dismissed the active banner.
@MappableClass()
class DashboardBannerDismissed extends DashboardEvent
    with DashboardBannerDismissedMappable {
  const DashboardBannerDismissed();
}
