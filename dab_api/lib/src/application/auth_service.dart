import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../domain/core/failure.dart';
import '../domain/entities/session.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/abs_i_auth_repository.dart';
import '../infrastructure/config/config.dart';

class AuthService {
  final Config _config = Config();
  final AbsIAuthRepository _repo;
  final _uuid = const Uuid();

  AuthService(this._repo);

  String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  Future<Either<AuthFailure, Map<String, String>>> register(
    String name,
    String email,
    String password,
  ) async {
    // 1. Domain Guard
    final domain = email.split('@').last;
    if (domain != _config.allowedDomain) {
      return Left(
        AuthFailure(
          'Registration restricted to ${_config.allowedDomain} domain',
        ),
      );
    }

    final findResult = await _repo.findByEmail(email);

    return findResult.match(
      (f) => Left(AuthFailure('Database error: ${f.message}')),
      (existing) async {
        if (existing != null) {
          return const Left(AuthFailure('User already exists'));
        }

        final role =
            (email.toLowerCase() == _config.initialAdminEmail.toLowerCase())
            ? 'Admin'
            : 'Standard';

        final user = User(
          id: _uuid.v4(),
          name: name,
          email: email,
          passwordHash: _hashPassword(password),
          role: role,
          createdAt: DateTime.now(),
        );

        final createResult = await _repo.createUser(user);
        return createResult.match(
          (f) => Left(AuthFailure('Error creating user: ${f.message}')),
          (_) async => Right(await _createSessionAndGetTokens(user)),
        );
      },
    );
  }

  Future<Either<AuthFailure, Map<String, String>>> login(
    String email,
    String password,
  ) async {
    final findResult = await _repo.findByEmail(email);

    return findResult.match(
      (f) => Left(AuthFailure('Database error: ${f.message}')),
      (user) async {
        if (user == null || !BCrypt.checkpw(password, user.passwordHash)) {
          return const Left(AuthFailure('Invalid credentials'));
        }
        return Right(await _createSessionAndGetTokens(user));
      },
    );
  }

  Future<Map<String, String>> _createSessionAndGetTokens(User user) async {
    final accessToken = generateToken({'sub': user.id, 'email': user.email});
    final refreshToken = _uuid.v4();

    final session = Session(
      id: _uuid.v4(),
      userId: user.id,
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    await _repo.createSession(session);

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': user.id,
    };
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
