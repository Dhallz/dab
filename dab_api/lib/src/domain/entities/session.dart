import 'package:dart_mappable/dart_mappable.dart';

part 'session.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Represents an active authentication session.
/// CONTRACT: Tracks refresh tokens and expiration for security hygiene.
/// CONSTRAINTS: Must be persisted in the `sessions` table.
@MappableClass()
class Session with SessionMappable {
  /// Unique identifier (UUID).
  final String id;
  
  /// The internal user ID this session belongs to.
  final String userId;
  
  /// The secure token used to issue new short-lived JWTs.
  final String refreshToken;
  
  /// Point in time when this session must be manually re-authenticated.
  final DateTime expiresAt;
  
  /// Textual representation of the device/browser origin.
  final String? deviceInfo;

  Session({
    required this.id,
    required this.userId,
    required this.refreshToken,
    required this.expiresAt,
    this.deviceInfo,
  });
}
