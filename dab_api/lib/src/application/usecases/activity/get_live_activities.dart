import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../infrastructure/database/redis/redis_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves Redis-backed live activities for dashboard consumption.
/// CONTRACT: Reads from Redis materialized live feeds; when the user-specific
/// Redis list is empty (e.g. ephemeral Redis wiped on deploy), falls back to
/// PostgreSQL rows for **today (UTC)** so the dashboard stays populated.
/// CONSTRAINTS: Global scope remains Redis-only. Does not invoke external providers.
class GetLiveActivities {
  final RedisService _redisService;
  final AbsIActivityRepository _activityRepository;

  GetLiveActivities(this._redisService, this._activityRepository);

  Future<Either<DatabaseFailure, List<Activity>>> execute({
    required String userId,
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  }) async {
    final normalizedLimit = limit.clamp(1, 100);
    try {
      var activities = await _redisService.getLiveActivities(
        userId: userId,
        limit: normalizedLimit,
        global: global,
        includeArchived: includeArchived,
      );
      if (!global && activities.isEmpty) {
        final fallback = await _activityRepository.getActivitiesByUser(
          userId,
          createdOnOrAfterUtc: RedisService.liveFeedStartOfTodayUtc(),
          limit: normalizedLimit,
        );
        activities =
            fallback.getOrElse((_) => const <Activity>[]);
      }

      return Right(activities);
    } catch (error) {
      return Left(
        DatabaseFailure('Failed to fetch live activities from Redis: $error'),
      );
    }
  }
}
