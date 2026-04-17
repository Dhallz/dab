import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../infrastructure/database/redis/redis_service.dart';
import '../../../infrastructure/websockets/presence_service.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Restores an archived live-feed activity to visible state.
/// CONTRACT: Rewrites the corresponding Redis entry in place with
/// `archived=false` and broadcasts an `ACTIVITY_UNARCHIVED` event to the
/// user's WebSocket sessions.
/// CONSTRAINTS: Operates exclusively on Redis live feed entries. Returns
/// [NotFoundFailure] when the activity is no longer present in the caller's
/// live feed (typically because the daily midnight purge already ran).
class UnarchiveLiveActivity {
  final RedisService _redis;
  final PresenceService _presence;

  UnarchiveLiveActivity(this._redis, this._presence);

  Future<Either<Failure, Activity>> execute({
    required String userId,
    required String activityId,
  }) async {
    try {
      final updated = await _redis.setActivityArchiveFlag(
        userId: userId,
        activityId: activityId,
        archived: false,
      );
      if (updated == null) {
        return Left(
          NotFoundFailure(
            'Activity $activityId is not present in the live feed.',
          ),
        );
      }
      _presence.broadcastToUser(userId, 'ACTIVITY_UNARCHIVED', {
        'id': activityId,
        'userId': userId,
        'archived': false,
      });
      return Right(updated);
    } catch (error) {
      return Left(DatabaseFailure('Failed to unarchive activity: $error'));
    }
  }
}
