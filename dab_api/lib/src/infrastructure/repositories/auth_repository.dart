import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/core/failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/abs_i_auth_repository.dart';
import '../database/app_database.dart';

class AuthRepository implements AbsIAuthRepository {
  final AppDatabase _db;
  AuthRepository(this._db);

  @override
  Future<Either<DatabaseFailure, User?>> findByEmail(String email) async {
    try {
      final user = await (_db.select(
        _db.usersTable,
      )..where((u) => u.email.equals(email))).getSingleOrNull();
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Error finding user by email: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, User?>> findById(String id) async {
    try {
      final user = await (_db.select(
        _db.usersTable,
      )..where((u) => u.id.equals(id))).getSingleOrNull();
      return Right(user);
    } catch (e) {
      return Left(DatabaseFailure('Error finding user by ID: $e'));
    }
  }

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
              role: Value(user.role),
              phorgePhid: Value(user.phorgePhid),
              phorgeUsername: Value(user.phorgeUsername),
              createdAt: user.createdAt,
              updatedAt: Value(user.updatedAt),
            ),
          );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error creating user: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<User>>> findUsersWithPhorge() async {
    try {
      final users = await (_db.select(
        _db.usersTable,
      )..where((u) => u.phorgePhid.isNotNull())).get();
      return Right(users);
    } catch (e) {
      return Left(DatabaseFailure('Error finding users with phorge: $e'));
    }
  }

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
              expiresAt: session.expiresAt,
              deviceInfo: Value(session.deviceInfo),
            ),
          );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Error creating session: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, Session?>> findSessionByToken(
    String token,
  ) async {
    try {
      final session =
          await (_db.select(_db.sessionsTable)
                ..where((s) => s.refreshToken.equals(token))
                ..limit(1))
              .getSingleOrNull();
      return Right(session);
    } catch (e) {
      return Left(DatabaseFailure('Error finding session: $e'));
    }
  }

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
}
