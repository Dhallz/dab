import 'dart:convert';

import 'package:redis/redis.dart';

import '../../../domain/entities/activity.dart';
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
    await _cmd.send_object(['LPUSH', 'activities:global', activityJson]);
    await _cmd.send_object(['LTRIM', 'activities:global', 0, 499]);

    // 2. Per-User Feed
    await _cmd.send_object([
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

  String _getDateKey(DateTime dt) =>
      "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
}
