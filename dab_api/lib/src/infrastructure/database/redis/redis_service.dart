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
  Future<List<Activity>> getLiveActivities({
    required String userId,
    int limit = 50,
    bool global = false,
  }) async {
    final normalizedLimit = limit.clamp(1, 100);
    final key = global ? 'activities:global' : 'activities:user:$userId';
    final raw = await _cmd.send_object(['LRANGE', key, 0, normalizedLimit - 1]);

    if (raw is! List) return const [];

    final decoded = <Activity>[];
    for (final entry in raw) {
      final activity = _decodeActivity(entry);
      if (activity != null) {
        decoded.add(activity);
      }
    }
    return decoded;
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
