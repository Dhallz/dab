import '../usecases/activity/fetch_remote_activities.dart';
import '../usecases/activity/get_recent_activities.dart';
import '../usecases/activity/log_activity.dart';
import '../usecases/activity/search_activities.dart';

class ActivityUseCases {
  final FetchRemoteActivities fetchRemoteActivities;
  final GetRecentActivities getRecentActivities;
  final LogActivity logActivity;
  final SearchActivities searchActivities;

  ActivityUseCases({
    required this.fetchRemoteActivities,
    required this.getRecentActivities,
    required this.logActivity,
    required this.searchActivities,
  });
}
