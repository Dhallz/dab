import '../../../../domain/core/activity_follow_key.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/user/activity_follow.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Synthetic Follow-lane card for a quiet Follow pin.

/// Prefix on synthetic Following cards for quiet Follow pins.
const kDashboardWatchingPlaceholderIdPrefix = 'watching:';

/// Whether [activity] is a quiet Follow pin rendered in the Following feed.
bool isDashboardWatchingPlaceholder(Activity activity) =>
    activity.id.startsWith(kDashboardWatchingPlaceholderIdPrefix);

/// Follow-lane card for a pin that has not received a live update yet.
///
/// Disappears from [DashboardState.watchingPins] once a real Follow-lane
/// activity exists for the same object.
Activity watchingPlaceholderActivity(ActivityFollow pin) {
  return Activity(
    id: '$kDashboardWatchingPlaceholderIdPrefix${pin.objectRef}',
    userId: '',
    provider: activityProviderForFollow(
      providerId: pin.providerId,
      objectKey: pin.objectKey,
    ),
    title: pin.displayTitle,
    content: '',
    authorName: '',
    commentCount: 0,
    url: pin.url,
    createdAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
    inboxLane: ActivityInboxLane.follow,
  );
}
