import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../entities/activity/activity.dart';

abstract class AbsIActivityRepository {
  Future<Either<DatabaseFailure, void>> createActivity(Activity activity);
  Future<Either<DatabaseFailure, List<Activity>>> getRecentActivities({
    int limit = 50,
  });
  Future<Either<DatabaseFailure, List<Activity>>> getActivitiesByUser(
    String userId, {
    /// When set (UTC), excludes rows strictly before this instant.
    DateTime? createdOnOrAfterUtc,

    /// When set, caps how many rows are read after ordering (newest first).
    int? limit,
  });
}
