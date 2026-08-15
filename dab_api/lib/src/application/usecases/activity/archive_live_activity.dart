import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/contracts/ports/i_live_feed_store.dart';
import '../../../domain/contracts/ports/i_presence_broadcaster.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Marks a live-feed activity as archived for the requesting user.
/// CONTRACT: Rewrites the corresponding Redis entry in place and broadcasts
/// an `ACTIVITY_ARCHIVED` event to the user's WebSocket sessions.
/// CONSTRAINTS: Operates exclusively on Redis live feed entries. Does not
/// touch the persistent `activities` table. Returns [NotFoundFailure] when the
/// activity is no longer present in the caller's live feed.
class ArchiveLiveActivity {
  final ILiveFeedStore _redis;
  final IPresenceBroadcaster _presence;

  ArchiveLiveActivity(this._redis, this._presence);

  Future<Either<Failure, Activity>> execute({
    required String userId,
    required String activityId,
  }) async {
    try {
      final updated = await _redis.setActivityArchiveFlag(
        userId: userId,
        activityId: activityId,
        archived: true,
      );
      if (updated == null) {
        return Left(
          NotFoundFailure(
            'Activity $activityId is not present in the live feed.',
          ),
        );
      }
      _presence.broadcastToUser(userId, 'ACTIVITY_ARCHIVED', {
        'id': activityId,
        'userId': userId,
        'archived': true,
      });
      return Right(updated);
    } catch (error) {
      return Left(DatabaseFailure('Failed to archive activity: $error'));
    }
  }
}
