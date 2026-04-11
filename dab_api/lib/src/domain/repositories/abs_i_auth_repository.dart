import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../entities/session.dart';
import '../entities/user/user.dart';
import '../entities/user/user_role.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Abstract contract for Authentication and User persistence.
/// CONTRACT: Defines how the system retrieves and stores Identity data.
/// CONSTRAINTS: Implementation must handle relational mapping (Drift/Postgres).
abstract class AbsIAuthRepository {
  /// Retrieves a user by their unique email address.
  Future<Either<DatabaseFailure, User?>> findByEmail(String email);

  /// Retrieves a user by their internal UUID.
  Future<Either<DatabaseFailure, User?>> findById(String id);

  /// Persists a new user record.
  Future<Either<DatabaseFailure, void>> createUser(User user);

  /// Retrieves all users that have a linked Phorge identity.
  Future<Either<DatabaseFailure, List<User>>> findUsersWithPhorge();

  /// Persists a new authentication session (refresh token).
  Future<Either<DatabaseFailure, void>> createSession(Session session);

  /// Retrieves a session by its refresh token string.
  Future<Either<DatabaseFailure, Session?>> findSessionByToken(String token);

  /// Invalidates a specific session by token.
  Future<Either<DatabaseFailure, void>> deleteSession(String token);

  /// Invalidates all active sessions for a specific user (Logout Everywhere).
  Future<Either<DatabaseFailure, void>> deleteUserSessions(String userId);

  /// Returns the number of users with the 'Admin' role.
  Future<Either<Failure, int>> countAdmins();

  /// Retrieves all registered users.
  /// Used for Admin Console user management.
  Future<Either<Failure, List<User>>> findAllUsers();

  /// Updates a user's role (e.g., [UserRole.admin] or [UserRole.standard]).
  Future<Either<Failure, void>> updateUserRole(String userId, UserRole role);
}
