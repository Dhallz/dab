import '../../entities/activity/activity.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Redis-backed live feed, Vegas clock, and ingest dedup keys.
/// CONTRACT: Application use cases depend on this port, not the Redis
/// implementation. Presentation may still use the concrete store for
/// session/sync helpers.
abstract interface class AbsILiveFeedStore {
  /// Increments the global Vegas version clock.
  Future<int> incrementVersion();

  /// Writes [activity] into global, per-user, and temporal live feeds.
  Future<void> fanOutActivity(Activity activity);

  /// Removes existing live-feed copies of [activity.id], then [fanOutActivity].
  Future<void> replaceFanOutActivity(Activity activity);

  /// Returns the caller's (or global) live-feed slice for today.
  Future<List<Activity>> getLiveActivities({
    required String userId,
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  });

  /// Sets the per-viewer archive flag. Null when the id is not in the feed.
  Future<Activity?> setActivityArchiveFlag({
    required String userId,
    required String activityId,
    required bool archived,
  });

  /// Drops archived and stale-by-date entries from live-feed lists.
  Future<Map<String, int>> purgeStaleLiveFeedActivities();

  /// Reserves a Slack Events API id (`SET NX`). False on duplicate delivery.
  Future<bool> reserveSlackEventId(
    String eventId, {
    Duration ttl = const Duration(hours: 24),
  });

  /// Reserves a GitHub `X-GitHub-Delivery` id. False on duplicate delivery.
  Future<bool> reserveGitHubDeliveryId(
    String deliveryId, {
    Duration ttl = const Duration(hours: 24),
  });

  /// Reserves a provider-scoped ingest fingerprint. False on duplicate.
  Future<bool> reserveIngestionEventId(
    String provider,
    String eventId, {
    Duration ttl = const Duration(hours: 24),
  });

  /// Records a successful live ingest for connectivity (7-day TTL).
  Future<void> recordLiveIngestSuccess(String providerId);

  /// Last successful live ingest instant, if any.
  Future<DateTime?> getLiveIngestLastSuccess(String providerId);
}
