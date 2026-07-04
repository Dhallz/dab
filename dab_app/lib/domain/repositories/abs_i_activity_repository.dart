import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_live_event.dart';
import '../../domain/entities/activity/activity_search_query.dart';
import '../../domain/entities/activity/explorer_cache_clear_request.dart';

abstract class IActivityRepository {
  Future<Either<AppFailure, List<Activity>>> getRecentActivities();
  Future<Either<AppFailure, List<Activity>>> getLiveActivities({
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  });
  Future<Either<AppFailure, List<Activity>>> searchActivities(
    ActivitySearchQuery query,
  );

  /// Archives a live-feed activity for the authenticated user.
  /// Returns [AppFailure] (typically ServerFailure with 404) when the entry
  /// is no longer present in the user's Redis live feed.
  Future<Either<AppFailure, Activity>> archiveLiveActivity(String id);

  /// Restores an archived live-feed activity to visible state.
  Future<Either<AppFailure, Activity>> unarchiveLiveActivity(String id);

  /// Streams live feed events — new activities + archive/unarchive mutations.
  Stream<ActivityLiveEvent> watchActivities();

  /// Clears Explorer ObjectBox activity and coverage cache.
  /// When [request] is omitted, removes all cached activities and coverage rows.
  Future<Either<AppFailure, ExplorerCacheClearResult>> clearExplorerCache({
    ExplorerCacheClearRequest? request,
  });
}
