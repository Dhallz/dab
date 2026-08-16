import '../../domain/entities/activity/activity.dart';
import '../../domain/contracts/ports/i_live_feed_store.dart';
import '../../domain/contracts/ports/i_presence_broadcaster.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Persists live-feed fan-out and delivers WebSocket events to the recipient.
class ActivityLivePublisher {
  ActivityLivePublisher(this._redis, this._presence);

  final ILiveFeedStore _redis;
  final IPresenceBroadcaster _presence;

  Future<void> publish(Activity activity) async {
    await _redis.incrementVersion();
    await _redis.fanOutActivity(activity);
    final payload = activity.toMap();
    _presence.broadcastToUser(
      activity.userId,
      'ACTIVITY_RECEIVED',
      payload,
    );
  }

  /// Production ingest passes [publisher]; unit tests omit it and keep Redis/WS stubs.
  static Future<void> emit({
    required ILiveFeedStore redis,
    required IPresenceBroadcaster presence,
    required Activity activity,
    ActivityLivePublisher? publisher,
  }) async {
    if (publisher != null) {
      await publisher.publish(activity);
      return;
    }
    await redis.incrementVersion();
    await redis.fanOutActivity(activity);
    presence.broadcastToUser(
      activity.userId,
      'ACTIVITY_RECEIVED',
      activity.toMap(),
    );
  }
}
