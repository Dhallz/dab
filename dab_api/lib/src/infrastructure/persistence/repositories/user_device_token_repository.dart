import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_device_token.dart';
import '../../../domain/contracts/repositories/abs_i_user_device_token_repository.dart';
import '../postgres/app_database.dart';
import '../postgres/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persists per-user FCM/APNs device tokens.
class UserDeviceTokenRepository implements AbsIUserDeviceTokenRepository {
  UserDeviceTokenRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Either<Failure, UserDeviceToken>> upsert(UserDeviceToken token) async {
    try {
      final now = DateTime.now().toUtc();
      await _db
          .into(_db.userDeviceTokensTable)
          .insert(
            UserDeviceTokensTableCompanion.insert(
              id: token.id,
              userId: token.userId,
              platform: token.platform,
              token: token.token,
              createdAt: Value(toPgDateTime(token.createdAt)),
              updatedAt: Value(toPgDateTime(now)),
            ),
            onConflict: DoUpdate(
              (_) => UserDeviceTokensTableCompanion(
                platform: Value(token.platform),
                updatedAt: Value(toPgDateTime(now)),
              ),
              target: [
                _db.userDeviceTokensTable.userId,
                _db.userDeviceTokensTable.token,
              ],
            ),
          );
      return Right(
        UserDeviceToken(
          id: token.id,
          userId: token.userId,
          platform: token.platform,
          token: token.token,
          createdAt: token.createdAt,
          updatedAt: now,
        ),
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to save device token: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> delete({
    required String userId,
    required String token,
  }) async {
    try {
      await (_db.delete(_db.userDeviceTokensTable)..where(
            (t) => t.userId.equals(userId) & t.token.equals(token),
          ))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete device token: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> listTokensForUser(String userId) async {
    try {
      final rows = await (_db.select(
        _db.userDeviceTokensTable,
      )..where((t) => t.userId.equals(userId))).get();
      return Right([
        for (final row in rows)
          if (row.token.trim().isNotEmpty) row.token.trim(),
      ]);
    } catch (e) {
      return Left(DatabaseFailure('Failed to list device tokens: $e'));
    }
  }
}
