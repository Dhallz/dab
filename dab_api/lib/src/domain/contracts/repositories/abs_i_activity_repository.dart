import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/activity/activity.dart';

abstract class AbsIActivityRepository {
  Future<Either<DatabaseFailure, void>> createActivity(Activity activity);

  /// Inserts or replaces [activity] by primary key so last-edited heartbeats
  /// update in place instead of stacking.
  Future<Either<DatabaseFailure, void>> upsertActivity(Activity activity);
  Future<Either<DatabaseFailure, List<Activity>>> getRecentActivities({
    int limit = 50,
  });
  Future<Either<DatabaseFailure, List<Activity>>> getActivitiesByUser(
    String userId,
  );
}
