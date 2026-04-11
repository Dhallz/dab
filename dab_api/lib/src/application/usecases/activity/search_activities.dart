import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import 'fetch_remote_activities.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Orchestrates on-demand activity search by user and time range.
/// CONTRACT: Resolves internal User entities and triggers [FetchRemoteActivities].
/// CONSTRAINTS: Only searches for valid DAB users. Returns an empty list on failure.
///
/// This use case acts as a higher-level coordinator that prepares
/// the context (User entities) for the parallel fetching engine.
class SearchActivities {
  final AbsIAuthRepository _authRepo;
  final FetchRemoteActivities _fetchRemoteActivities;

  SearchActivities(this._authRepo, this._fetchRemoteActivities);

  /// Executes the search operation.
  ///
  /// 1. Resolves all [targetUserIds] into full [User] entities.
  /// 2. Delegates the parallel protocol I/O to [FetchRemoteActivities].
  /// 3. Returns the aggregated results.
  Future<List<Activity>> execute({
    required List<String> targetUserIds,
    required DateTime startDate,
    required DateTime endDate,
    required bool authoredOnly,
  }) async {
    List<User> targetUsers = [];

    // Preparation Phase: Resolve IDs to Entities
    for (final userId in targetUserIds) {
      final userResult = await _authRepo.findById(userId);
      userResult.map((u) {
        if (u != null) targetUsers.add(u);
      });
    }

    if (targetUsers.isEmpty) return [];

    // Orchestration Phase: Coordinate the fetch
    final result = await _fetchRemoteActivities.execute(
      targetUsers: targetUsers,
      startDate: startDate,
      endDate: endDate,
      authoredOnly: authoredOnly,
    );

    return result.getOrElse((_) => []);
  }
}
