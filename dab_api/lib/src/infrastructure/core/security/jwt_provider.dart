import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../../domain/ports/i_access_token_issuer.dart';
import '../config/config.dart';

/// [ARCH: INFRASTRUCTURE_SECURITY]
/// ROLE: Signs and verifies HS256 access tokens.
class JwtProvider implements IAccessTokenIssuer {
  final Config _config = Config();

  @override
  String generateToken(Map<String, dynamic> payload) {
    final jwt = JWT(payload);
    return jwt.sign(
      SecretKey(_config.jwtSecret),
      algorithm: JWTAlgorithm.HS256,
      expiresIn: Duration(minutes: _config.jwtExpiryMinutes),
    );
  }

  JWT? verifyToken(String token) {
    try {
      return JWT.verify(
        token,
        SecretKey(_config.jwtSecret),
        checkHeaderType: true,
      );
    } catch (e) {
      return null;
    }
  }
}
