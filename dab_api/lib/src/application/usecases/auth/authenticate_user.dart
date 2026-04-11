import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import '../../../infrastructure/config/config.dart';
import '../../../infrastructure/security/jwt_provider.dart';
import 'login_user.dart';

class AuthenticateUser {
  final AbsIAuthRepository _repo;
  final LoginUser _loginUser;
  final JwtProvider _jwtProvider;
  final _uuid = const Uuid();

  AuthenticateUser(this._repo, this._loginUser, this._jwtProvider);

  Future<Either<AuthFailure, Map<String, String>>> execute(String email, String password) async {
    final loginResult = await _loginUser.execute(email, password);
    
    if (loginResult.isLeft()) {
      return Left(loginResult.getLeft().toNullable()!);
    }

    final user = loginResult.getRight().toNullable()!;

    // Bootstrap lock: with zero admins, only the configured initial admin may obtain a session.
    final adminCountResult = await _repo.countAdmins();
    final adminCount = adminCountResult.getOrElse((_) => 0);
    if (adminCount == 0) {
      final config = Config();
      final isInitialAdmin =
          user.email.toLowerCase() == config.initialAdminEmail.toLowerCase();
      if (!isInitialAdmin) {
        return Left(
          BootstrapLockFailure(
            'Bootstrap Lock: System not configured. Only the initial admin '
            '(${config.initialAdminEmail}) can log in.',
          ),
        );
      }
    }

    final accessToken = _jwtProvider.generateToken({
      'sub': user.id,
      'email': user.email,
      'role': user.role.name,
    });
    final refreshToken = _uuid.v4();

    final session = Session(
      id: _uuid.v4(),
      userId: user.id,
      refreshToken: refreshToken,
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );

    final createResult = await _repo.createSession(session);
    if (createResult.isLeft()) {
      final failure = createResult.getLeft().toNullable()!;
      return Left(AuthFailure('Failed to create session: ${failure.message}'));
    }

    return Right({
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'userId': user.id,
      'name': user.name,
      'email': user.email,
      'avatarUrl': user.avatarUrl ?? '',
      'role': user.role.name,
    });
  }
}
