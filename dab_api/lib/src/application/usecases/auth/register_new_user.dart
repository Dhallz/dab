import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/session.dart';
import '../../../domain/contracts/ports/abs_i_access_token_issuer.dart';
import '../../../domain/contracts/repositories/abs_i_auth_repository.dart';
import 'register_user.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Orchestrates User Creation followed by immediate Session generation.
/// CONTRACT: Returns full access credentials for a newly registered user.
/// CONSTRAINTS: Depends on [RegisterUser] for identity persistence.
class RegisterNewUser {
  final AbsIAuthRepository _repo;
  final RegisterUser _registerUser;
  final AbsIAccessTokenIssuer _jwtProvider;
  final _uuid = const Uuid();

  RegisterNewUser(this._repo, this._registerUser, this._jwtProvider);

  /// Registers a user and returns a logged-in state.
  ///
  /// 1. Calls [RegisterUser] to create the identity record.
  /// 2. Generates initial Access/Refresh tokens.
  /// 3. Persists the first session.
  Future<Either<AuthFailure, Map<String, String>>> execute(
    String name,
    String email,
    String password,
  ) async {
    final registerResult = await _registerUser.execute(name, email, password);

    if (registerResult.isLeft()) {
      return Left(registerResult.getLeft().toNullable()!);
    }

    final user = registerResult.getRight().toNullable()!;
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

    final result = await _repo.createSession(session);
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
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
