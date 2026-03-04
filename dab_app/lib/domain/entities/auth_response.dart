import 'package:dart_mappable/dart_mappable.dart';

part 'auth_response.mapper.dart';

@MappableClass()
class AuthResponse with AuthResponseMappable {
  final String accessToken;
  final String refreshToken;
  final String userId;

  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
  });
}
