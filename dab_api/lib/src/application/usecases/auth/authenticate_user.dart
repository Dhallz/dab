import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
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
    final accessToken = _jwtProvider.generateToken({'sub': user.id, 'email': user.email});
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
    });
  }
}
