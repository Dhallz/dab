import '../../entities/user/oauth_state_payload.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: One-time OAuth state (PKCE verifier + user binding) with TTL.
abstract interface class AbsIOauthStateStore {
  Future<void> put(
    String stateId,
    OauthStatePayload payload, {
    Duration ttl = const Duration(minutes: 10),
  });

  /// Returns and deletes the payload, or null if missing/expired.
  Future<OauthStatePayload?> take(String stateId);
}
