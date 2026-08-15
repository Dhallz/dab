import 'dart:convert';

import '../../domain/entities/user/oauth_state_payload.dart';
import '../../domain/ports/i_oauth_state_store.dart';
import '../database/redis/redis_service.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Redis-backed one-time OAuth state (`oauth:state:{id}`).
class RedisOauthStateStore implements IOauthStateStore {
  RedisOauthStateStore(this._redis);

  final RedisService _redis;

  @override
  Future<void> put(
    String stateId,
    OauthStatePayload payload, {
    Duration ttl = const Duration(minutes: 10),
  }) {
    return _redis.setEx(
      'oauth:state:$stateId',
      jsonEncode(payload.toMap()),
      ttl,
    );
  }

  @override
  Future<OauthStatePayload?> take(String stateId) async {
    final raw = await _redis.getAndDelete('oauth:state:$stateId');
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      final payload = OauthStatePayload.fromMap(
        Map<String, dynamic>.from(map),
      );
      if (payload.userId.isEmpty ||
          payload.providerId.isEmpty ||
          payload.codeVerifier.isEmpty) {
        return null;
      }
      return payload;
    } catch (_) {
      return null;
    }
  }
}
