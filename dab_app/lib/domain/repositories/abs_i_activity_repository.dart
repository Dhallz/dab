import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/activity.dart';

abstract class IActivityRepository {
  Future<Either<AppFailure, List<Activity>>> getRecentActivities();
  Future<Either<AppFailure, List<Activity>>> searchActivities({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? users,
    bool authoredOnly = true,
  });
  Stream<Activity> watchActivities();
}
