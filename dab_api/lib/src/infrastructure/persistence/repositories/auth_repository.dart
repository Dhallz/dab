import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/entities/user/user_role.dart';
import '../../domain/repositories/abs_i_auth_repository.dart';
import '../database/app_database.dart';
import '../database/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persistence implementation for Authentication and User identity.
/// CONTRACT: Implements [AbsIAuthRepository] using the [AppDatabase] (Drift/Postgres).
/// CONSTRAINTS: Must handle low-level database exceptions and map them to [DatabaseFailure].
///
/// This repository acts as the bridge between the high-level [User] and [Session]
/// entities and the low-level relational tables.
class AuthRepository implements AbsIAuthRepository {
  final AppDatabase _db;
  AuthRepository(this._db);

  /// Finds a user by their unique email address.
  @override
  Future<Either<DatabaseFailure, User?>> findByEmail(String email) async {
    try {
      final row = await (_db.select(
        _db.usersTable,
      )..where((u) => u.email.equals(email))).getSingleOrNull();
      return Right(row != null ? userFromUsersRow(row) : null);
    } catch (e) {
      return Left(DatabaseFailure('Error finding user by email: $e'));
    }
  }

  /// Finds a user by their unique internal ID.
  @override
  Future<Either<DatabaseFailure, User?>> findById(String id) async {
    try {
      final row = await (_db.select(
        _db.usersTable,
      )..where((u) => u.id.equals(id))).getSingleOrNull();
      return Right(row != null ? userFromUsersRow(row) : null);
    } catch (e) {
      return Left(DatabaseFailure('Error finding user by ID: $e'));
    }
  }

  /// Persists a new user identity.
  @override
  Future<Either<DatabaseFailure, void>> createUser(User user) async {
    try {
      await _db
          .into(_db.usersTable)
          .insert(
            UsersTableCompanion.insert(
              id: user.id,
              name: user.name,
              email: user.email,
              passwordHash: user.passwordHash,
              role: Value(user.role.name),
              phorgePhid: Value(user.phorgePhid),
              phorgeUsername: Value(user.phorgeUsername),
              createdAt: toPgDateTime(user.createdAt),
              updatedAt: Value(toPgDateTimeOrNull(user.updatedAt)),
            ),
          );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error creating user: $e'));
    }
  }

  /// Retrieves users who have an associated Phorge identity.
  @override
  Future<Either<DatabaseFailure, List<User>>> findUsersWithPhorge() async {
    try {
      final rows = await (_db.select(
        _db.usersTable,
      )..where((u) => u.phorgePhid.isNotNull())).get();
      return Right(rows.map(userFromUsersRow).toList());
    } catch (e) {
      return Left(DatabaseFailure('Error finding users with phorge: $e'));
    }
  }

  /// Records a new authentication session.
  @override
  Future<Either<DatabaseFailure, void>> createSession(Session session) async {
    try {
      await _db
          .into(_db.sessionsTable)
          .insert(
            SessionsTableCompanion.insert(
              id: session.id,
              userId: session.userId,
              refreshToken: session.refreshToken,
              expiresAt: toPgDateTime(session.expiresAt),
              deviceInfo: Value(session.deviceInfo),
            ),
          );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error creating session: $e'));
    }
  }

  /// Retrieves a session by its refresh token.
  @override
  Future<Either<DatabaseFailure, Session?>> findSessionByToken(
    String token,
  ) async {
    try {
      final row =
          await (_db.select(_db.sessionsTable)
                ..where((s) => s.refreshToken.equals(token))
                ..limit(1))
              .getSingleOrNull();
      return Right(row != null ? sessionFromSessionsRow(row) : null);
    } catch (e) {
      return Left(DatabaseFailure('Error finding session: $e'));
    }
  }

  /// Removes a specific session (Logout/Invalidation).
  @override
  Future<Either<DatabaseFailure, void>> deleteSession(String token) async {
    try {
      await (_db.delete(
        _db.sessionsTable,
      )..where((s) => s.refreshToken.equals(token))).go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error deleting session: $e'));
    }
  }

  /// Removes all sessions for a specific user (Security purge).
  @override
  Future<Either<DatabaseFailure, void>> deleteUserSessions(
    String userId,
  ) async {
    try {
      await (_db.delete(
        _db.sessionsTable,
      )..where((s) => s.userId.equals(userId))).go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error deleting user sessions: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, int>> countAdmins() async {
    try {
      final query = _db.select(_db.usersTable)
        ..where((u) => u.role.equals(UserRole.admin.name));
      final users = await query.get();
      return Right(users.length);
    } catch (e) {
      return Left(DatabaseFailure('Error counting admins: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<User>>> findAllUsers() async {
    try {
      final rows = await _db.select(_db.usersTable).get();
      return Right(rows.map(userFromUsersRow).toList());
    } catch (e) {
      return Left(DatabaseFailure('Error retrieving all users: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, void>> updateUserRole(
    String userId,
    UserRole role,
  ) async {
    try {
      await (_db.update(_db.usersTable)..where((u) => u.id.equals(userId)))
          .write(UsersTableCompanion(role: Value(role.name)));
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error updating user role: $e'));
    }
  }
}
