import '../usecases/activity/fetch_remote_activities.dart';
import '../usecases/activity/get_live_activities.dart';
import '../usecases/activity/get_recent_activities.dart';
import '../usecases/activity/ingest_slack_event.dart';
import '../usecases/activity/log_activity.dart';
import '../usecases/activity/search_activities.dart';

class ActivityUseCases {
  final FetchRemoteActivities fetchRemoteActivities;
  final GetLiveActivities getLiveActivities;
  final GetRecentActivities getRecentActivities;
  final IngestSlackEvent ingestSlackEvent;
  final LogActivity logActivity;
  final SearchActivities searchActivities;

  ActivityUseCases({
    required this.fetchRemoteActivities,
    required this.getLiveActivities,
    required this.getRecentActivities,
    required this.ingestSlackEvent,
    required this.logActivity,
    required this.searchActivities,
  });
}
