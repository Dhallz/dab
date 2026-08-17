import 'dart:convert';

import 'package:redis/redis.dart';

import '../../../domain/core/org_calendar.dart' as org_calendar;
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/contracts/ports/i_live_feed_store.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';
import 'redis_client.dart';

/// [ARCH: INFRASTRUCTURE_SERVICE]
/// ROLE: Redis live feeds, Vegas clock, and ingest dedup keys.
class RedisService implements ILiveFeedStore {
  final RedisClient _client;
  final ISystemSettingsRepository _settings;

  RedisService(this._client, this._settings);

  Command get _cmd => _client.command;

  /// --- VEGAS PATTERN (VERSION CLOCK) ---

  /// Increments the global DAB version counter.
  @override
  Future<int> incrementVersion() async {
    return await _cmd.send_object(['INCR', 'dab:version']);
  }

  /// Gets the current global version.
  Future<int> getCurrentVersion() async {
    final val = await _cmd.get('dab:version');
    return val != null ? int.parse(val.toString()) : 0;
  }

  /// --- THE FAN-OUT PATTERN ---

  /// Fans out a single activity to Global, Per-User, and Temporal feeds.
  @override
  Future<void> fanOutActivity(Activity activity) async {
    final activityJson = _encodeActivity(activity);
    final timestamp = activity.createdAt.millisecondsSinceEpoch;

    // 1. Global Feed (Rolling last 500)
    final globalLen = await _cmd.send_object([
      'LPUSH',
      'activities:global',
      activityJson,
    ]);
    await _cmd.send_object(['LTRIM', 'activities:global', 0, 499]);

    // 2. Per-User Feed
    final userLen = await _cmd.send_object([
      'LPUSH',
      'activities:user:${activity.userId}',
      activityJson,
    ]);
    await _cmd.send_object([
      'LTRIM',
      'activities:user:${activity.userId}',
      0,
      99,
    ]);

    // 3. Temporal Sharding (ZSET for the day)
    final dateKey = _getDateKey(activity.createdAt);
    await _cmd.send_object([
      'ZADD',
      'activities:date:$dateKey',
      timestamp,
      activityJson,
    ]);

    // Follow-lane copies must not double Insights ingest stats.
    if (!activity.isFollowLane) {
      // 4. Insights (HINCRBY)
      await _cmd.send_object([
        'HINCRBY',
        'insights:stats:$dateKey',
        activity.provider.category,
        1,
      ]);

      // 5. Leaderboards (ZINCRBY)
      await _cmd.send_object([
        'ZINCRBY',
        'insights:rankings:$dateKey:${activity.provider.category}',
        1,
        activity.userId,
      ]);
      await _cmd.send_object([
        'ZINCRBY',
        'insights:rankings:$dateKey:total',
        1,
        activity.userId,
      ]);
    }

    print(
      '[SLACK_PIPELINE] redis_fanout activity_id=${activity.id} user_id=${activity.userId} global_len=$globalLen user_len=$userLen',
    );
  }

  /// Returns live activities from Redis materialized feeds.
  ///
  /// This method serves the dedicated live endpoint and intentionally reads only
  /// from Redis live keys. It does not query Postgres.
  ///
  /// When [includeArchived] is false (default), entries whose `archived` flag
  /// is true are filtered out before the limit is applied. Entries whose
  /// [Activity.createdAt] is before the start of the current **UTC** calendar
  /// day are always excluded (live feed is "today" only).
  ///
  /// The [limit] is the upper bound on the **returned** list, so we over-read
  /// internally to avoid starving the result when many entries are archived or
  /// stale.
  @override
  Future<List<Activity>> getLiveActivities({
    required String userId,
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  }) async {
    final normalizedLimit = limit.clamp(1, 100);
    final startOfTodayUtc = await liveFeedStartOfTodayUtc();
    final key = global ? 'activities:global' : 'activities:user:$userId';
    // Over-read so filtering by `archived` / date can still fill up to the limit.
    final fetchSize = includeArchived ? normalizedLimit : 100;
    final raw = await _cmd.send_object(['LRANGE', key, 0, fetchSize - 1]);

    if (raw is! List) return const [];

    final decoded = <Activity>[];
    final viewerArchivedIds = global
        ? await _archivedActivityIdsForUser(userId)
        : const <String>{};
    for (final entry in raw) {
      var activity = _decodeActivity(entry);
      if (activity == null) continue;
      if (activity.createdAt.isBefore(startOfTodayUtc)) continue;
      if (global && viewerArchivedIds.contains(activity.id)) {
        activity = activity.copyWith(archived: true);
      }
      if (!includeArchived && activity.archived) continue;
      decoded.add(activity);
      if (decoded.length >= normalizedLimit) break;
    }
    return decoded;
  }

  /// Rewrites a user's live-feed entry with an updated [archived] flag.
  ///
  /// Uses `LRANGE` + `LSET` so we keep the original position (and therefore
  /// the timestamp ordering) in place. Returns the updated [Activity] on
  /// success, or `null` if the id could not be found in the caller's live
  /// feed (e.g. already purged or never fanned out to this user).
  @override
  Future<Activity?> setActivityArchiveFlag({
    required String userId,
    required String activityId,
    required bool archived,
  }) async {
    final key = 'activities:user:$userId';
    final raw = await _cmd.send_object(['LRANGE', key, 0, -1]);
    if (raw is! List) return null;

    for (var index = 0; index < raw.length; index++) {
      final entry = raw[index];
      final activity = _decodeActivity(entry);
      if (activity == null || activity.id != activityId) continue;

      final updated = activity.copyWith(archived: archived);
      await _cmd.send_object(['LSET', key, index, _encodeActivity(updated)]);
      print(
        '[TRIAGE_PIPELINE] redis_flag activity_id=$activityId user_id=$userId archived=$archived position=$index',
      );
      return updated;
    }

    if (archived) {
      final globalRaw = await _cmd.send_object([
        'LRANGE',
        'activities:global',
        0,
        -1,
      ]);
      if (globalRaw is List) {
        for (final entry in globalRaw) {
          final activity = _decodeActivity(entry);
          if (activity == null || activity.id != activityId) continue;
          final updated = activity.copyWith(archived: true);
          await _cmd.send_object(['LPUSH', key, _encodeActivity(updated)]);
          await _cmd.send_object(['LTRIM', key, 0, 99]);
          return updated;
        }
      }
    }

    return null;
  }

  Future<Set<String>> _archivedActivityIdsForUser(String userId) async {
    final raw = await _cmd.send_object([
      'LRANGE',
      'activities:user:$userId',
      0,
      -1,
    ]);
    if (raw is! List) return {};
    final ids = <String>{};
    for (final entry in raw) {
      final activity = _decodeActivity(entry);
      if (activity != null && activity.archived) {
        ids.add(activity.id);
      }
    }
    return ids;
  }

  /// Drops live-feed rows that are **archived** or older than the current UTC
  /// calendar day. Runs for every `activities:user:*` key (full SCAN loop) and
  /// for `activities:global`.
  ///
  /// Intended for the daily UTC midnight job ([ActivityPurgeScheduler]).
  /// Rebuilds each list by decoding entries, dropping removals, and rewriting in
  /// a `DEL` + `RPUSH` cycle so order is preserved.
  ///
  /// Returns a map of Redis key -> removedCount for observability.
  @override
  Future<Map<String, int>> purgeStaleLiveFeedActivities() async {
    final removed = <String, int>{};
    final startOfTodayUtc = await liveFeedStartOfTodayUtc();
    var totalArchived = 0;
    var totalStale = 0;

    for (final keyStr in await _scanAllKeysMatching('activities:user:*')) {
      final r = await _purgeLiveFeedListKey(keyStr, startOfTodayUtc);
      if (r.dropped > 0) {
        removed[keyStr] = r.dropped;
        totalArchived += r.archived;
        totalStale += r.staleByDate;
      }
    }

    final global = await _purgeLiveFeedListKey(
      'activities:global',
      startOfTodayUtc,
    );
    if (global.dropped > 0) {
      removed['activities:global'] = global.dropped;
      totalArchived += global.archived;
      totalStale += global.staleByDate;
    }

    if (removed.isNotEmpty) {
      final n = removed.values.fold(0, (a, b) => a + b);
      print(
        '[TRIAGE_PIPELINE] purge_complete keys=${removed.length} total_removed=$n '
        'removed_archived=$totalArchived removed_stale_by_date=$totalStale',
      );
    }
    return removed;
  }

  /// Start of the current org calendar day as a UTC instant. Live feeds only
  /// surface activities at or after this instant.
  Future<DateTime> liveFeedStartOfTodayUtc([DateTime? now]) async {
    final orgTimezoneId = await loadOrgTimezoneId(_settings);
    return org_calendar.liveFeedStartOfTodayUtc(orgTimezoneId, now);
  }

  /// Start of the current org calendar day for a fixed timezone (tests).
  static DateTime liveFeedStartOfTodayForTimezone(
    String orgTimezoneId, [
    DateTime? now,
  ]) => org_calendar.liveFeedStartOfTodayUtc(orgTimezoneId, now);

  static bool shouldRemoveFromLiveFeed(
    Activity activity,
    DateTime startOfTodayUtc,
  ) {
    return activity.archived || activity.createdAt.isBefore(startOfTodayUtc);
  }

  Future<List<String>> _scanAllKeysMatching(String pattern) async {
    final keys = <String>{};
    var cursor = '0';
    do {
      final reply = await _cmd.send_object([
        'SCAN',
        cursor,
        'MATCH',
        pattern,
        'COUNT',
        '500',
      ]);
      if (reply is! List || reply.length < 2) {
        break;
      }
      cursor = reply[0].toString();
      final batch = reply[1];
      if (batch is List) {
        for (final k in batch) {
          keys.add(k.toString());
        }
      }
    } while (cursor != '0');
    return keys.toList();
  }

  /// Returns removed counts for [keyStr] (archive vs calendar staleness).
  Future<({int dropped, int archived, int staleByDate})> _purgeLiveFeedListKey(
    String keyStr,
    DateTime startOfTodayUtc,
  ) async {
    final raw = await _cmd.send_object(['LRANGE', keyStr, 0, -1]);
    if (raw is! List) {
      return (dropped: 0, archived: 0, staleByDate: 0);
    }

    final kept = <String>[];
    var dropped = 0;
    var archived = 0;
    var staleByDate = 0;
    for (final entry in raw) {
      final activity = _decodeActivity(entry);
      if (activity == null) {
        kept.add(entry.toString());
        continue;
      }
      if (activity.archived) {
        dropped++;
        archived++;
        continue;
      }
      if (activity.createdAt.isBefore(startOfTodayUtc)) {
        dropped++;
        staleByDate++;
        continue;
      }
      kept.add(entry.toString());
    }

    if (dropped == 0) {
      return (dropped: 0, archived: 0, staleByDate: 0);
    }

    await _cmd.send_object(['DEL', keyStr]);
    if (kept.isNotEmpty) {
      await _cmd.send_object(['RPUSH', keyStr, ...kept]);
    }
    return (dropped: dropped, archived: archived, staleByDate: staleByDate);
  }

  /// Deprecated name: the midnight job removes **archived** and **pre-today**
  /// rows. Prefer [purgeStaleLiveFeedActivities].
  Future<Map<String, int>> purgeArchivedActivities() async {
    return purgeStaleLiveFeedActivities();
  }

  /// --- REDIS STREAMS ---

  /// Adds a raw event to the ingestion stream.
  Future<void> addToStream(String provider, Map<String, dynamic> data) async {
    await _cmd.send_object([
      'XADD',
      'dab:stream:events',
      '*',
      'provider',
      provider,
      'payload',
      jsonEncode(data),
    ]);
  }

  /// Attempts to reserve a Slack event id for one-time processing.
  ///
  /// Returns true if the event id was not seen recently and is now reserved.
  /// Returns false when the id already exists (retry/duplicate delivery).
  @override
  Future<bool> reserveSlackEventId(
    String eventId, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    final key = 'slack:event:$eventId';
    final result = await _cmd.send_object([
      'SET',
      key,
      '1',
      'NX',
      'EX',
      ttl.inSeconds,
    ]);
    return result != null;
  }

  /// Attempts to reserve a GitHub webhook delivery id for one-time processing.
  ///
  /// Returns true when the delivery was not seen recently and is now reserved.
  /// Returns false on duplicate webhook delivery retries.
  @override
  Future<bool> reserveGitHubDeliveryId(
    String deliveryId, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    final key = 'github:delivery:$deliveryId';
    final result = await _cmd.send_object([
      'SET',
      key,
      '1',
      'NX',
      'EX',
      ttl.inSeconds,
    ]);
    return result != null;
  }

  /// Attempts to reserve a provider-scoped live-ingestion event id for
  /// one-time processing (`SET NX EX` on `ingest:{provider}:{eventId}`).
  ///
  /// Shared by all webhook / gateway ingestion paths that do not have a
  /// dedicated legacy key format. Returns true when the event was not seen
  /// recently and is now reserved; false on duplicate deliveries.
  @override
  Future<bool> reserveIngestionEventId(
    String provider,
    String eventId, {
    Duration ttl = const Duration(hours: 24),
  }) async {
    final key = 'ingest:$provider:$eventId';
    final result = await _cmd.send_object([
      'SET',
      key,
      '1',
      'NX',
      'EX',
      ttl.inSeconds,
    ]);
    return result != null;
  }

  static const Duration liveIngestSuccessTtl = Duration(days: 7);

  /// Records a successful live-ingestion event for [providerId] (webhook or gateway).
  @override
  Future<void> recordLiveIngestSuccess(String providerId) async {
    final key = 'live:last_ingest:${providerId.trim().toLowerCase()}';
    await _cmd.send_object([
      'SET',
      key,
      DateTime.now().toUtc().toIso8601String(),
      'EX',
      liveIngestSuccessTtl.inSeconds,
    ]);
  }

  /// Returns the last successful live-ingestion instant for [providerId], if any.
  @override
  Future<DateTime?> getLiveIngestLastSuccess(String providerId) async {
    final key = 'live:last_ingest:${providerId.trim().toLowerCase()}';
    final raw = await _cmd.send_object(['GET', key]);
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString())?.toUtc();
  }

  /// Sets [key] to [value] with an expiry. Used for OAuth state.
  Future<void> setEx(String key, String value, Duration ttl) async {
    await _cmd.send_object(['SET', key, value, 'EX', ttl.inSeconds]);
  }

  /// GET then DEL [key]. Returns null when missing.
  Future<String?> getAndDelete(String key) async {
    final raw = await _cmd.send_object(['GET', key]);
    if (raw == null) return null;
    await _cmd.send_object(['DEL', key]);
    return raw.toString();
  }

  /// --- HELPERS ---

  String _encodeActivity(Activity activity) {
    return jsonEncode({
      'data': [activity.toMap()],
      'meta': {
        'dataType': 'list:activity',
        'syncToken': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      },
    });
  }

  Activity? _decodeActivity(Object? rawEntry) {
    try {
      final decoded = jsonDecode(rawEntry.toString());
      if (decoded is! Map<String, dynamic>) return null;

      // Current fan-out payload stores an envelope with data[0] = Activity map.
      final envelopeData = decoded['data'];
      if (envelopeData is List && envelopeData.isNotEmpty) {
        final first = envelopeData.first;
        if (first is Map<String, dynamic>) {
          return ActivityMapper.fromMap(first);
        }
      }

      // Defensive fallback: accept direct activity payload if present.
      return ActivityMapper.fromMap(decoded);
    } catch (_) {
      return null;
    }
  }

  String _getDateKey(DateTime dt) =>
      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
}
