import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';

class GetRecentActivities {
  final IActivityRepository repository;

  GetRecentActivities(this.repository);

  Future<Either<AppFailure, List<Activity>>> execute() =>
      repository.getRecentActivities();
}
