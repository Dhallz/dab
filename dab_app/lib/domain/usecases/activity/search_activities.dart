import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_search_query.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';

class SearchActivities {
  final IActivityRepository repository;

  SearchActivities(this.repository);

  Future<Either<AppFailure, List<Activity>>> execute(
    ActivitySearchQuery query,
  ) {
    return repository.searchActivities(query);
  }
}
