import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import '../../../infrastructure/core/security/jwt_provider.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Refreshes a short-lived Access Token using a long-lived Refresh Token.
/// CONTRACT: Validates the session, rotates the refresh token, and returns new credentials.
/// CONSTRAINTS: Must implement "Token Rotation" (old refresh token is invalidated).
class RefreshToken {
  final AbsIAuthRepository _repo;
  final JwtProvider _jwtProvider;
  final _uuid = const Uuid();

  RefreshToken(this._repo, this._jwtProvider);

  /// Executes the token refresh logic.
  ///
  /// 1. Verifies the [refreshToken] exists in the database.
  /// 2. Checks for expiration.
  /// 3. Deletes the old session.
  /// 4. Generates a new Access Token and a new Refresh Token.
  /// 5. Persists the new session.
  Future<Either<AuthFailure, Map<String, String>>> execute(
    String refreshToken,
  ) async {
    final sessionResult = await _repo.findSessionByToken(refreshToken);

    if (sessionResult.isLeft()) {
      final f = sessionResult.getLeft().toNullable()!;
      return Left(AuthFailure('Database error: ${f.message}'));
    }

    final session = sessionResult.getRight().toNullable();
    if (session == null) {
      return const Left(AuthFailure('Invalid refresh token'));
    }

    // Security check: If token is expired, kill the session and deny access.
    if (session.expiresAt.isBefore(DateTime.now())) {
      await _repo.deleteSession(refreshToken);
      return const Left(AuthFailure('Refresh token expired'));
    }

    final userResult = await _repo.findById(session.userId);
    if (userResult.isLeft()) {
      final f = userResult.getLeft().toNullable()!;
      return Left(AuthFailure('Database error: ${f.message}'));
    }

    final user = userResult.getRight().toNullable();
    if (user == null) {
      return const Left(AuthFailure('User not found'));
    }

    // Token Rotation: Always invalidate the old token after single use.
    await _repo.deleteSession(refreshToken);

    final newAccessToken = _jwtProvider.generateToken({
      'sub': user.id,
      'email': user.email,
      'role': user.role.name,
    });
    final newRefreshToken = _uuid.v4();

    final newSession = Session(
      id: _uuid.v4(),
      userId: user.id,
      refreshToken: newRefreshToken,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    final createResult = await _repo.createSession(newSession);
    if (createResult.isLeft()) {
      final failure = createResult.getLeft().toNullable()!;
      return Left(
        AuthFailure('Failed to create new session: ${failure.message}'),
      );
    }

    return Right({
      'accessToken': newAccessToken,
      'refreshToken': newRefreshToken,
      'userId': user.id,
      'name': user.name,
      'email': user.email,
      'avatarUrl': user.avatarUrl ?? '',
      'role': user.role.name,
    });
  }
}
