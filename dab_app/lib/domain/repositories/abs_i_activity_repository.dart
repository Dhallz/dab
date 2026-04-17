import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_search_query.dart';

abstract class IActivityRepository {
  Future<Either<AppFailure, List<Activity>>> getRecentActivities();
  Future<Either<AppFailure, List<Activity>>> getLiveActivities({
    int limit = 50,
    bool global = false,
  });
  Future<Either<AppFailure, List<Activity>>> searchActivities(
    ActivitySearchQuery query,
  );
  Stream<Activity> watchActivities();
}
