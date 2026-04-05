import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';

class SearchActivities {
  final IActivityRepository repository;

  SearchActivities(this.repository);

  Future<Either<AppFailure, List<Activity>>> execute({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? users,
    bool authoredOnly = true,
  }) {
    return repository.searchActivities(
      startDate: startDate,
      endDate: endDate,
      users: users,
      authoredOnly: authoredOnly,
    );
  }
}
