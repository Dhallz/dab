import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../config/config.dart';

class JwtProvider {
  final Config _config = Config();

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
