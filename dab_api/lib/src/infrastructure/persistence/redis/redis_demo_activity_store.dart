import 'dart:convert';

import 'package:redis/redis.dart';

import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/contracts/ports/abs_i_demo_activity_store.dart';
import 'redis_client.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Redis-backed demo search slice (`demo:search:{userId}:{date}`).
class RedisDemoActivityStore implements AbsIDemoActivityStore {
  RedisDemoActivityStore(this._client);

  final RedisClient _client;

  Command get _cmd => _client.command;

  @override
  Future<void> replaceDay({
    required String userId,
    required String date,
    required List<Activity> activities,
  }) async {
    final key = _key(userId, date);
    await _cmd.send_object(['DEL', key]);
    if (activities.isEmpty) return;
    await _cmd.send_object([
      'RPUSH',
      key,
      for (final activity in activities) _encode(activity),
    ]);
  }

  @override
  Future<List<Activity>> list({
    required List<String> userIds,
    required DateTime start,
    required DateTime end,
    Set<String>? providerIds,
    required bool authoredOnly,
  }) async {
    final startUtc = start.toUtc();
    final endUtc = end.toUtc();
    final wantedProviders = providerIds
        ?.map((id) => id.trim().toLowerCase())
        .where((id) => id.isNotEmpty)
        .toSet();
    final authors = {for (final id in userIds) if (id.trim().isNotEmpty) id};
    final out = <Activity>[];
    for (final userId in authors) {
      for (final date in _dateKeys(startUtc, endUtc)) {
        final raw = await _cmd.send_object(['LRANGE', _key(userId, date), 0, -1]);
        if (raw is! List) continue;
        for (final entry in raw) {
          final activity = _decode(entry);
          if (activity == null) continue;
          if (activity.createdAt.isBefore(startUtc)) continue;
          if (activity.createdAt.isAfter(endUtc)) continue;
          final providerId =
              (activity.provider.followProviderId ??
                      activity.provider.name)
                  .trim()
                  .toLowerCase();
          if (wantedProviders != null &&
              wantedProviders.isNotEmpty &&
              !wantedProviders.contains(providerId)) {
            continue;
          }
          if (authoredOnly) {
            final sender = activity.senderUserId?.trim() ?? '';
            if (!authors.contains(sender)) continue;
          }
          out.add(activity);
        }
      }
    }
    return out;
  }

  String _key(String userId, String date) => 'demo:search:$userId:$date';

  Iterable<String> _dateKeys(DateTime start, DateTime end) sync* {
    var cursor = DateTime.utc(start.year, start.month, start.day)
        .subtract(const Duration(days: 1));
    final last = DateTime.utc(end.year, end.month, end.day)
        .add(const Duration(days: 1));
    while (!cursor.isAfter(last)) {
      final mm = cursor.month.toString().padLeft(2, '0');
      final dd = cursor.day.toString().padLeft(2, '0');
      yield '${cursor.year}-$mm-$dd';
      cursor = cursor.add(const Duration(days: 1));
    }
  }

  String _encode(Activity activity) {
    return jsonEncode({
      'data': [activity.toMap()],
      'meta': {
        'dataType': 'list:activity',
        'syncToken': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      },
    });
  }

  Activity? _decode(Object? rawEntry) {
    try {
      final decoded = jsonDecode(rawEntry.toString());
      if (decoded is! Map<String, dynamic>) return null;
      final envelopeData = decoded['data'];
      if (envelopeData is List && envelopeData.isNotEmpty) {
        final first = envelopeData.first;
        if (first is Map<String, dynamic>) {
          return ActivityMapper.fromMap(first);
        }
      }
      return ActivityMapper.fromMap(decoded);
    } catch (_) {
      return null;
    }
  }
}
