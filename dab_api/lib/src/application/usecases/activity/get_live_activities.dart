import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/contracts/ports/abs_i_live_feed_store.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Serves **`GET /activities/live`** for the Dashboard.
/// CONTRACT: Reads **only** from Redis (`activities:user:{id}`, `activities:global`).
/// CONSTRAINTS: **No** Postgres and **no** provider polling here — ephemeral Redis means
/// the live slice can legitimately be empty. Explorer historical views use **`SearchActivities`**
/// / **`GET /activities/search`** (not this use case).
class GetLiveActivities {
  final AbsILiveFeedStore _redisService;

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
