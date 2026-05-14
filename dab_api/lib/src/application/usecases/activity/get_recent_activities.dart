import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves a paginated list of recent activities from local persistence.
/// CONTRACT: Fetches unified [Activity] entities from the primary database.
/// CONSTRAINTS: Does NOT trigger remote fetching. Used for immediate UI hydration.
class GetRecentActivities {
  final AbsIActivityRepository _repo;

  GetRecentActivities(this._repo);

  /// Executes the retrieval of recent activities.
  ///
  /// Returns a [List<Activity>] ordered by occurrence date (descending),
  /// or a [DatabaseFailure] if the persistence layer is unreachable.
  Future<Either<DatabaseFailure, List<Activity>>> execute() async {
    return await _repo.getRecentActivities();
  }
}
