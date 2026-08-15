import '../../domain/core/deployment_mode.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/ports/i_live_feed_store.dart';
import '../../domain/ports/i_presence_broadcaster.dart';
import '../../domain/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Persists live-feed fan-out and chooses personal vs org WebSocket delivery.
class ActivityLivePublisher {
  ActivityLivePublisher(this._redis, this._presence, this._settings);

  final ILiveFeedStore _redis;
  final IPresenceBroadcaster _presence;
  final ISystemSettingsRepository _settings;

  Future<void> publish(Activity activity) async {
    await _redis.incrementVersion();
    await _redis.fanOutActivity(activity);
    final payload = activity.toMap();
    final mode = await _settings.getSetting(kDeploymentModeSettingKey);
    final personal = isPersonalDeploymentMode(
      mode.getOrElse((_) => null),
    );
    if (personal) {
      _presence.broadcast('ACTIVITY_RECEIVED', payload);
    } else {
      _presence.broadcastToUser(
        activity.userId,
        'ACTIVITY_RECEIVED',
        payload,
      );
    }
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
