import 'package:dart_mappable/dart_mappable.dart';

part 'auth_response.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Payload representing a successful authentication event.
/// CONTRACT: Immutable container for session tokens and user profile basics.
/// CONSTRAINTS: Must be serializable via [AuthResponseMappable].
@MappableClass()
class AuthResponse with AuthResponseMappable {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
  });
}
