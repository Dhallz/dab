import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/entities/user.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Orchestrates the parallel fetching and aggregation of activities.
/// CONTRACT: Returns a sorted, deduplicated list of Activities or a Failure.
/// CONSTRAINTS: Must use [UnifiedActivityFetcher] for technical fan-out.
///
/// This UseCase is the primary entry point for the Dashboard and Search 
/// controllers to retrieve fresh data from external sources.
class FetchRemoteActivities {
  final UnifiedActivityFetcher _fetcher;

  FetchRemoteActivities(this._fetcher);

  /// [ARCH: APPLICATION_ENTRY]
  /// ROLE: Executes the activity aggregation flow.
  /// CONTRACT: Returns [Right] with activities or [Left] with [Failure].
  Future<Either<Failure, List<Activity>>> execute({
    required List<User> targetUsers,
    required DateTime startDate,
    required DateTime endDate,
    required bool authoredOnly,
  }) async {
    try {
      if (targetUsers.isEmpty) return const Right([]);

      final aggregatedActivities = await _fetcher.fetchAll(
        users: targetUsers,
        start: startDate,
        end: endDate,
        authoredOnly: authoredOnly,
      );

      // Deduplicate by ID just in case
      final uniqueActivitiesMap = <String, Activity>{};
      for (var activity in aggregatedActivities) {
        uniqueActivitiesMap[activity.id] = activity;
      }
      
      final sortedActivities = uniqueActivitiesMap.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(sortedActivities);
    } catch (e) {
      return Left(DatabaseFailure('Failed to fetch remote activities: $e'));
    }
  }
}
