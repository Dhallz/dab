import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/activity/activity.dart';
import '../../repositories/abs_i_activity_repository.dart';

class GetLiveActivities {
  final IActivityRepository repository;

  GetLiveActivities(this.repository);

  Future<Either<AppFailure, List<Activity>>> execute({
    int limit = 50,
    bool global = false,
  }) {
    return repository.getLiveActivities(limit: limit, global: global);
  }
}
