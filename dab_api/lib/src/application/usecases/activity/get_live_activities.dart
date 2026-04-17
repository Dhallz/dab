import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../infrastructure/database/redis/redis_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves Redis-backed live activities for dashboard consumption.
/// CONTRACT: Reads from Redis materialized live feeds only.
/// CONSTRAINTS: Must not query Postgres or external providers.
class GetLiveActivities {
  final RedisService _redisService;

  GetLiveActivities(this._redisService);

  Future<Either<DatabaseFailure, List<Activity>>> execute({
    required String userId,
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  }) async {
    try {
      final activities = await _redisService.getLiveActivities(
        userId: userId,
        limit: limit,
        global: global,
        includeArchived: includeArchived,
      );
      return Right(activities);
    } catch (error) {
      return Left(
        DatabaseFailure('Failed to fetch live activities from Redis: $error'),
      );
    }
  }
}
