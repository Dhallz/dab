import 'package:dart_mappable/dart_mappable.dart';

part 'auth_response.mapper.dart';

@MappableClass()
class AuthResponse with AuthResponseMappable {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String name;
  final String email;
  final String? avatarUrl;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
}
