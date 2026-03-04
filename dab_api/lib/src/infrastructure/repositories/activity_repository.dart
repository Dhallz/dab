import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/core/failure.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/activity_provider.dart';
import '../../domain/repositories/abs_i_activity_repository.dart';
import '../database/app_database.dart';

class ActivityRepository implements AbsIActivityRepository {
  final AppDatabase _db;
  ActivityRepository(this._db);

  @override
  Future<Either<DatabaseFailure, void>> createActivity(
    Activity activity,
  ) async {
    return _db.transaction(() async {
      try {
        // 1. Insert into base activities table
        await _db
            .into(_db.activitiesTable)
            .insert(
              ActivitiesTableCompanion.insert(
                id: activity.id,
                userId: activity.userId,
                providerName: activity.provider.name,
                title: activity.title,
                content: activity.content,
                url: Value(activity.url),
                createdAt: activity.createdAt,
              ),
            );

        // 2. Insert into specific provider table if applicable
        final provider = activity.provider;
        if (provider is PhorgeTaskProvider) {
          await _db
              .into(_db.activityPhorgeTable)
              .insert(
                ActivityPhorgeTableCompanion.insert(
                  activityId: activity.id,
                  taskPhid: Value(provider.taskPhid),
                  tags: Value(provider.tags),
                ),
              );
        } else if (provider is PhorgeRevisionProvider) {
          await _db
              .into(_db.activityPhorgeTable)
              .insert(
                ActivityPhorgeTableCompanion.insert(
                  activityId: activity.id,
                  revisionId: Value(provider.revisionId),
                ),
              );
        }
        // Add more providers here (GitHub, Slack, etc.)

        return const Right(null);
      } catch (e) {
        return Left(DatabaseFailure('Error creating activity: $e'));
      }
    });
  }

  @override
  Future<Either<DatabaseFailure, List<Activity>>> getRecentActivities({
    int limit = 50,
  }) async {
    try {
      final query = _db.select(_db.activitiesTable).join([
        leftOuterJoin(
          _db.activityPhorgeTable,
          _db.activityPhorgeTable.activityId.equalsExp(_db.activitiesTable.id),
        ),
      ]);

      query.orderBy([
        OrderingTerm(
          expression: _db.activitiesTable.createdAt,
          mode: OrderingMode.desc,
        ),
      ]);
      query.limit(limit);

      final rows = await query.get();
      return Right(rows.map(_mapRowToActivity).toList());
    } catch (e) {
      return Left(DatabaseFailure('Error fetching recent activities: $e'));
    }
  }

  @override
  Future<Either<DatabaseFailure, List<Activity>>> getActivitiesByUser(
    String userId,
  ) async {
    try {
      final query = _db.select(_db.activitiesTable).join([
        leftOuterJoin(
          _db.activityPhorgeTable,
          _db.activityPhorgeTable.activityId.equalsExp(_db.activitiesTable.id),
        ),
      ]);

      query.where(_db.activitiesTable.userId.equals(userId));
      query.orderBy([
        OrderingTerm(
          expression: _db.activitiesTable.createdAt,
          mode: OrderingMode.desc,
        ),
      ]);

      final rows = await query.get();
      return Right(rows.map(_mapRowToActivity).toList());
    } catch (e) {
      return Left(DatabaseFailure('Error fetching user activities: $e'));
    }
  }

  Activity _mapRowToActivity(TypedResult row) {
    final activityData = row.readTable(_db.activitiesTable);
    final phorgeData = row.readTableOrNull(_db.activityPhorgeTable);

    ActivityProvider provider;
    final pName = activityData.providerName.toLowerCase();

    if (pName == 'phorge' && phorgeData != null) {
      if (phorgeData.taskPhid != null) {
        provider = PhorgeTaskProvider(
          taskPhid: phorgeData.taskPhid,
          tags: phorgeData.tags,
        );
      } else if (phorgeData.revisionId != null) {
        provider = PhorgeRevisionProvider(revisionId: phorgeData.revisionId);
      } else {
        provider = const GenericProvider(name: 'Phorge', category: 'unknown');
      }
    } else if (pName == 'github') {
      provider = const GitHubCommitProvider();
    } else {
      provider = GenericProvider(name: activityData.providerName);
    }

    return Activity(
      id: activityData.id,
      userId: activityData.userId,
      provider: provider,
      title: activityData.title,
      content: activityData.content,
      url: activityData.url,
      createdAt: activityData.createdAt,
    );
  }
}
