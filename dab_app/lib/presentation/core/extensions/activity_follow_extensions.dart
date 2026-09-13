import '../../../../domain/core/activity_follow_key.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/user/activity_follow.dart';

/// Prefix on synthetic Following cards for quiet Follow pins.
const kDashboardWatchingPlaceholderIdPrefix = 'watching:';

/// [ARCH: PRESENTATION_CORE]
/// ROLE: Dashboard Following-feed placeholder built from a quiet Follow pin.
extension OnActivityFollow on ActivityFollow {
  /// Follow-lane card for a pin that has not received a live update yet.
  ///
  /// Disappears from [DashboardState.watchingPins] once a real Follow-lane
  /// activity exists for the same object.
  Activity get watchingPlaceholderActivity {
    return Activity(
      id: '$kDashboardWatchingPlaceholderIdPrefix$objectRef',
      userId: '',
      provider: activityProviderForFollow(
        providerId: providerId,
        objectKey: objectKey,
      ),
      title: displayTitle,
      content: '',
      authorName: '',
      commentCount: 0,
      url: url,
      createdAt: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      inboxLane: ActivityInboxLane.follow,
    );
  }
}
