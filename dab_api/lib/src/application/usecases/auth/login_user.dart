import 'package:bcrypt/bcrypt.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Authenticates a user using email and password.
/// CONTRACT: Validates credentials and returns the [User] entity if successful.
/// CONSTRAINTS: Must use [BCrypt] for password verification. 
/// 
/// This use case is the first step in the login flow, handles lookup 
/// and cryptographic validation before tokens are issued.
class LoginUser {
  final AbsIAuthRepository _repo;

  LoginUser(this._repo);

  /// Performs the login operation.
  /// 
  /// Returns a [User] on success, or an [AuthFailure] on:
  /// - User not found.
  /// - Password mismatch.
  /// - Database connectivity issues.
  Future<Either<AuthFailure, User>> execute(
    String email,
    String password,
  ) async {
    final findResult = await _repo.findByEmail(email);

    if (findResult.isLeft()) {
      return Left(AuthFailure('Database error: ${findResult.getLeft().toNullable()!.message}'));
    }

    final user = findResult.getRight().toNullable();
    
    // Cryptographic verification of the provided password against the stored hash.
    if (user == null || !BCrypt.checkpw(password, user.passwordHash)) {
      return const Left(AuthFailure('Invalid credentials'));
    }
    
    return Right(user);
  }
}
