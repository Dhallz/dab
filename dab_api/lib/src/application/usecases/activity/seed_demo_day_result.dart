/// [ARCH: APPLICATION]
/// ROLE: Outcome of [SeedDemoDay].
class SeedDemoDayResult {
  final String date;
  final String userId;
  final int activityCount;
  final int followCount;
  final int reportLineCount;
  final bool dashboardVisible;
  final List<String> providers;
  final int userCount;
  final int createdUserCount;
  final List<String> userIds;
  final int groupCount;

  const SeedDemoDayResult({
    required this.date,
    required this.userId,
    required this.activityCount,
    required this.followCount,
    required this.reportLineCount,
    required this.dashboardVisible,
    required this.providers,
    this.userCount = 1,
    this.createdUserCount = 0,
    this.userIds = const [],
    this.groupCount = 0,
  });

  Map<String, dynamic> toMap() => {
    'date': date,
    'userId': userId,
    'activityCount': activityCount,
    'followCount': followCount,
    'reportLineCount': reportLineCount,
    'dashboardVisible': dashboardVisible,
    'providers': providers,
    'userCount': userCount,
    'createdUserCount': createdUserCount,
    'userIds': userIds.isEmpty ? [userId] : userIds,
    'groupCount': groupCount,
  };
}
