import 'dart:convert';

import 'package:redis/redis.dart';

import '../../../domain/entities/activity/activity.dart';
import 'redis_client.dart';

class RedisService {
  final RedisClient _client;

  RedisService(this._client);

  Command get _cmd => _client.command;

  /// --- VEGAS PATTERN (VERSION CLOCK) ---

  /// Increments the global DAB version counter.
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
  /// is true are filtered out before the limit is applied. The [limit] is the
  /// upper bound on the **returned** list, so we over-read internally to avoid
  /// starving the result when many entries are archived.
  Future<List<Activity>> getLiveActivities({
    required String userId,
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  }) async {
    final normalizedLimit = limit.clamp(1, 100);
    final key = global ? 'activities:global' : 'activities:user:$userId';
    // Over-read so filtering by `archived` can still fill up to the limit.
    final fetchSize = includeArchived ? normalizedLimit : 100;
    final raw = await _cmd.send_object(['LRANGE', key, 0, fetchSize - 1]);

    if (raw is! List) return const [];

    final decoded = <Activity>[];
    for (final entry in raw) {
      final activity = _decodeActivity(entry);
      if (activity == null) continue;
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
      await _cmd.send_object([
        'LSET',
        key,
        index,
        _encodeActivity(updated),
      ]);
      print(
        '[TRIAGE_PIPELINE] redis_flag activity_id=$activityId user_id=$userId archived=$archived position=$index',
      );
      return updated;
    }

    return null;
  }

  /// Removes every archived entry from every per-user live-feed key.
  ///
  /// Intended for the daily midnight reset. Rebuilds each list by decoding all
  /// entries, dropping those with `archived == true`, and rewriting the key in
  /// a single `DEL` + `RPUSH` cycle so the remaining entries preserve their
  /// original ordering.
  ///
  /// Returns a map of `userFeedKey -> removedCount` for observability.
  Future<Map<String, int>> purgeArchivedActivities() async {
    final removed = <String, int>{};
    final scan = await _cmd.send_object([
      'SCAN',
      '0',
      'MATCH',
      'activities:user:*',
      'COUNT',
      '500',
    ]);
    if (scan is! List || scan.length < 2) return removed;

    final keys = scan[1];
    if (keys is! List) return removed;

    for (final key in keys) {
      final keyStr = key.toString();
      final raw = await _cmd.send_object(['LRANGE', keyStr, 0, -1]);
      if (raw is! List) continue;

      final kept = <String>[];
      var dropped = 0;
      for (final entry in raw) {
        final activity = _decodeActivity(entry);
        if (activity == null) {
          // Preserve undecodable entries as-is so we don't eat them by mistake.
          kept.add(entry.toString());
          continue;
        }
        if (activity.archived) {
          dropped++;
          continue;
        }
        kept.add(entry.toString());
      }

      if (dropped == 0) continue;

      await _cmd.send_object(['DEL', keyStr]);
      if (kept.isNotEmpty) {
        await _cmd.send_object(['RPUSH', keyStr, ...kept]);
      }
      removed[keyStr] = dropped;
    }

    if (removed.isNotEmpty) {
      print(
        '[TRIAGE_PIPELINE] purge_complete keys=${removed.length} total_removed=${removed.values.fold(0, (a, b) => a + b)}',
      );
    }
    return removed;
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
