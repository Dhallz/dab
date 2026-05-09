import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import 'fetch_remote_activities.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Orchestrates on-demand activity search by user and time range.
/// CONTRACT: Runs [FetchRemoteActivities] only — **`GET /activities/search`** aggregates
/// provider APIs via [UnifiedActivityFetcher]. **Does not** query PostgreSQL; ingested rows
/// on disk are surfaced elsewhere (`GET /activities`, live Redis fan-out).
/// CONSTRAINTS: Only searches for valid DAB users. Returns an empty list on fetch failure.
class SearchActivities {
  final AbsIAuthRepository _authRepo;
  final FetchRemoteActivities _fetchRemoteActivities;

  SearchActivities(this._authRepo, this._fetchRemoteActivities);

  /// 1. Resolves all [targetUserIds] into full [User] entities.
  /// 2. Delegates the parallel protocol I/O to [FetchRemoteActivities].
  Future<List<Activity>> execute({
    required List<String> targetUserIds,
    required DateTime startDate,
    required DateTime endDate,
    required bool authoredOnly,
  }) async {
    List<User> targetUsers = [];

    for (final userId in targetUserIds) {
      final userResult = await _authRepo.findById(userId);
      userResult.map((u) {
        if (u != null) targetUsers.add(u);
      });
    }

    if (targetUsers.isEmpty) return [];

    final result = await _fetchRemoteActivities.execute(
      targetUsers: targetUsers,
      startDate: startDate,
      endDate: endDate,
      authoredOnly: authoredOnly,
    );

    return result.getOrElse((_) => []);
  }
}
