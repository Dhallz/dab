import 'activity.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Discriminated union of events delivered by the live activity WS
/// channel to the Dashboard. Lets the dashboard notifier react uniformly to new incoming
/// activities and to triage-state mutations from other sessions.
/// CONTRACT: Sealed class; extend it inside this file only.
/// CONSTRAINTS: Not serialized — lives purely on the client stream; the
/// repository maps WS payloads into concrete subclasses.
sealed class ActivityLiveEvent {
  const ActivityLiveEvent();
}

/// A brand-new activity arrived for the user.
class ActivityReceivedEvent extends ActivityLiveEvent {
  final Activity activity;
  const ActivityReceivedEvent(this.activity);
}

/// An existing live-feed entry was archived (either by this client or from
/// another session belonging to the same user).
class ActivityArchivedEvent extends ActivityLiveEvent {
  final String activityId;
  final String userId;
  const ActivityArchivedEvent({required this.activityId, required this.userId});
}

/// An existing live-feed entry was un-archived.
class ActivityUnarchivedEvent extends ActivityLiveEvent {
  final String activityId;
  final String userId;
  const ActivityUnarchivedEvent({
    required this.activityId,
    required this.userId,
  });
}
