import '../../domain/entities/activity/activity.dart';
import '../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../domain/contracts/ports/abs_i_presence_broadcaster.dart';
import '../../domain/contracts/ports/abs_i_push_wake_client.dart';
import '../../domain/contracts/repositories/abs_i_user_device_token_repository.dart';
import '../../domain/core/inbox_wake.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Persists live-feed fan-out, delivers WebSocket events, and wakes
/// offline devices without putting activity copy on FCM.
class ActivityLivePublisher {
  ActivityLivePublisher(
    this._redis,
    this._presence, {
    AbsIUserDeviceTokenRepository? tokens,
    AbsIPushWakeClient? wake,
  }) : _tokens = tokens,
       _wake = wake;

  final AbsILiveFeedStore _redis;
  final AbsIPresenceBroadcaster _presence;
  final AbsIUserDeviceTokenRepository? _tokens;
  final AbsIPushWakeClient? _wake;

  Future<void> publish(
    Activity activity, {
    bool replaceExisting = false,
  }) async {
    await _redis.incrementVersion();
    if (replaceExisting) {
      await _redis.replaceFanOutActivity(activity);
    } else {
      await _redis.fanOutActivity(activity);
    }
    final payload = activity.toMap();
    _presence.broadcastToUser(
      activity.userId,
      'ACTIVITY_RECEIVED',
      payload,
    );
    await _maybeWake(activity);
  }

  Future<void> _maybeWake(Activity activity) async {
    final tokensRepo = _tokens;
    final wake = _wake;
    if (tokensRepo == null || wake == null) return;
    if (_presence.hasSession(activity.userId)) return;
    final listed = await tokensRepo.listTokensForUser(activity.userId);
    final tokens = listed.fold((_) => const <String>[], (ids) => ids);
    if (tokens.isEmpty) return;
    try {
      await wake.sendWake(tokens: tokens, data: activity.inboxWakeData());
    } catch (_) {
      // Ingest must not fail because a wake provider is down.
    }
  }

  /// Production ingest passes [publisher]; unit tests omit it and keep Redis/WS stubs.
  static Future<void> emit({
    required AbsILiveFeedStore redis,
    required AbsIPresenceBroadcaster presence,
    required Activity activity,
    ActivityLivePublisher? publisher,
    bool replaceExisting = false,
  }) async {
    if (publisher != null) {
      await publisher.publish(activity, replaceExisting: replaceExisting);
      return;
    }
    await redis.incrementVersion();
    if (replaceExisting) {
      await redis.replaceFanOutActivity(activity);
    } else {
      await redis.fanOutActivity(activity);
    }
    presence.broadcastToUser(
      activity.userId,
      'ACTIVITY_RECEIVED',
      activity.toMap(),
    );
  }
}
