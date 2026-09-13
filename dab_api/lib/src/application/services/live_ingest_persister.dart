import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures/failure.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/contracts/ports/abs_i_live_feed_store.dart';
import '../../domain/contracts/ports/abs_i_presence_broadcaster.dart';
import '../../domain/contracts/repositories/abs_i_activity_repository.dart';
import '../usecases/activity/ingestion_result.dart';
import 'activity_live_publisher.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Shared persist + Redis fan-out tail for live ingest use cases.
/// CONTRACT: Inserts each [Activity], skips duplicate-key failures, emits
/// live-feed fan-out, and records ingest success when at least one row is new.
/// [replaceExisting] upserts by id and replaces Redis copies (last-edited).
/// CONSTRAINTS: Does not map DTOs or apply provider filters — callers pass
/// already-shaped activities. Duplicate detection is message-based.
class LiveIngestPersister {
  LiveIngestPersister({
    required AbsIActivityRepository activities,
    required AbsILiveFeedStore liveFeed,
    required AbsIPresenceBroadcaster presence,
    ActivityLivePublisher? livePublisher,
  }) : _activities = activities,
       _liveFeed = liveFeed,
       _presence = presence,
       _livePublisher = livePublisher;

  final AbsIActivityRepository _activities;
  final AbsILiveFeedStore _liveFeed;
  final AbsIPresenceBroadcaster _presence;
  final ActivityLivePublisher? _livePublisher;

  /// Persists [activities] and fans them out.
  ///
  /// When every insert is a duplicate (or the list is empty), returns
  /// [IngestionResult.ignored] with [emptyReason] and does not record
  /// ingest success. Non-duplicate database failures surface as [Left].
  Future<Either<Failure, IngestionResult>> persist({
    required List<Activity> activities,
    required String providerId,
    required String emptyReason,
    String logTag = 'INGEST',
    void Function(Activity activity)? onInserted,
    bool replaceExisting = false,
  }) async {
    var ingestedCount = 0;
    for (final activity in activities) {
      final createResult = replaceExisting
          ? await _activities.upsertActivity(activity)
          : await _activities.createActivity(activity);
      if (createResult.isLeft()) {
        final message = createResult
            .getLeft()
            .toNullable()!
            .message
            .toLowerCase();
        if (!replaceExisting && _isDuplicateViolation(message)) {
          continue;
        }
        return Left(createResult.getLeft().toNullable()!);
      }
      ingestedCount++;
      onInserted?.call(activity);
      await ActivityLivePublisher.emit(
        redis: _liveFeed,
        presence: _presence,
        activity: activity,
        publisher: _livePublisher,
        replaceExisting: replaceExisting,
      );
      print(
        '[$logTag] ingest_complete activity_id=${activity.id} user_id=${activity.userId}',
      );
    }

    if (ingestedCount == 0) {
      return Right(IngestionResult.ignored(emptyReason));
    }
    await _liveFeed.recordLiveIngestSuccess(providerId);
    return const Right(IngestionResult.ingested());
  }

  bool _isDuplicateViolation(String message) {
    return message.contains('duplicate') ||
        message.contains('unique constraint') ||
        message.contains('already exists');
  }
}
