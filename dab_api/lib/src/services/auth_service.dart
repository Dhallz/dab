import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';

import '../domain/entities/session.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';
import '../infrastructure/config/config.dart';
import '../infrastructure/database/sql_auth_repository.dart';

class AuthService {
  final Config _config = Config();
  final AuthRepository _repo = SqlAuthRepository();
  final _uuid = const Uuid();

  String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  Future<User?> register(String email, String password) async {
    final existing = await _repo.findByEmail(email);
    if (existing != null) return null;

    final user = User(
      id: _uuid.v4(),
      email: email,
      passwordHash: _hashPassword(password),
      createdAt: DateTime.now(),
    );

    await _repo.createUser(user);
    return user;
  }

  Future<Map<String, String>?> login(String email, String password) async {
    final user = await _repo.findByEmail(email);
    if (user == null || !BCrypt.checkpw(password, user.passwordHash)) {
      return null;
    }

    final accessToken = generateToken({'sub': user.id, 'email': user.email});
    final refreshToken = _uuid.v4();

    final session = Session(
      id: _uuid.v4(),
      userId: user.id,
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    await _repo.createSession(session);

    return {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

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

  Future<void> logout(String refreshToken) async {
    await _repo.deleteSession(refreshToken);
  }
}
