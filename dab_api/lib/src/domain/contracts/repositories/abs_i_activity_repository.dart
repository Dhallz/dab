import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/activity/activity.dart';

abstract class AbsIActivityRepository {
  Future<Either<DatabaseFailure, void>> createActivity(Activity activity);
  Future<Either<DatabaseFailure, List<Activity>>> getRecentActivities({
    int limit = 50,
  });
  Future<Either<DatabaseFailure, List<Activity>>> getActivitiesByUser(
    String userId,
  );
}
