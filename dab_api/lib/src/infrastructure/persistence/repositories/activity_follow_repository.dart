import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import '../postgres/app_database.dart';
import '../postgres/drift_row_mappers.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persists Dashboard object Follow pins.
class ActivityFollowRepository implements AbsIActivityFollowRepository {
  ActivityFollowRepository(this._db);

  final AppDatabase _db;

  @override
  Future<Either<Failure, List<ActivityFollow>>> listForUser(
    String userId,
  ) async {
    try {
      final rows = await (_db.select(
        _db.activityFollowsTable,
      )..where((t) => t.userId.equals(userId))).get();
      return Right(rows.map(_map).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to list activity follows: $e'));
    }
  }

  @override
  Future<Either<Failure, ActivityFollow>> upsert(ActivityFollow follow) async {
    try {
      final now = DateTime.now().toUtc();
      await _db
          .into(_db.activityFollowsTable)
          .insert(
            ActivityFollowsTableCompanion.insert(
              id: follow.id,
              userId: follow.userId,
              providerId: follow.providerId,
              objectKey: follow.objectKey,
              title: Value(follow.title),
              url: Value(follow.url),
              createdAt: Value(follow.createdAt.toPgDateTime()),
              updatedAt: Value(now.toPgDateTime()),
            ),
            onConflict: DoUpdate(
              (_) => ActivityFollowsTableCompanion(
                title: follow.title == null
                    ? const Value.absent()
                    : Value(follow.title),
                url: follow.url == null
                    ? const Value.absent()
                    : Value(follow.url),
                updatedAt: Value(now.toPgDateTime()),
              ),
              target: [
                _db.activityFollowsTable.userId,
                _db.activityFollowsTable.providerId,
                _db.activityFollowsTable.objectKey,
              ],
            ),
          );
      return Right(follow.copyWith(updatedAt: now));
    } catch (e) {
      return Left(DatabaseFailure('Failed to save activity follow: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> delete({
    required String userId,
    required String providerId,
    required String objectKey,
  }) async {
    try {
      await (_db.delete(_db.activityFollowsTable)..where(
            (t) =>
                t.userId.equals(userId) &
                t.providerId.equals(providerId) &
                t.objectKey.equals(objectKey),
          ))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete activity follow: $e'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> userIdsFor({
    required String providerId,
    required String objectKey,
  }) async {
    try {
      final rows =
          await (_db.select(_db.activityFollowsTable)..where(
                (t) =>
                    t.providerId.equals(providerId) &
                    t.objectKey.equals(objectKey),
              ))
              .get();
      return Right(rows.map((row) => row.userId).toList());
    } catch (e) {
      return Left(DatabaseFailure('Failed to load activity followers: $e'));
    }
  }

  ActivityFollow _map(ActivityFollowsTableData row) {
    return ActivityFollow(
      id: row.id,
      userId: row.userId,
      providerId: row.providerId,
      objectKey: row.objectKey,
      title: row.title,
      url: row.url,
      createdAt: row.createdAt.dateTime,
      updatedAt: row.updatedAt?.dateTime,
    );
  }
}
