import '../../entities/activity/activity.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Demo-seeded activities for Explorer / Insights / Reports search.
/// CONTRACT: Independent of live provider APIs and linked identities.
/// CONSTRAINTS: Presentation never reads this store; [UnifiedActivityFetcher]
/// unions [list] into search results.
abstract interface class AbsIDemoActivityStore {
  /// Replaces the seeded search slice for [userId] on org-calendar [date].
  Future<void> replaceDay({
    required String userId,
    required String date,
    required List<Activity> activities,
  });

  /// Activities whose [Activity.userId] is in [userIds] and [createdAt] falls
  /// in \[start, end\]. [providerIds] are ingest ids (`github`, `jira`, …).
  /// When [authoredOnly] is true, only rows whose [Activity.senderUserId] is
  /// in [userIds] are returned.
  Future<List<Activity>> list({
    required List<String> userIds,
    required DateTime start,
    required DateTime end,
    Set<String>? providerIds,
    required bool authoredOnly,
  });
}
