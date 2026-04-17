import '../repositories/abs_i_activity_repository.dart';
import '../usecases/activity/get_live_activities.dart';
import '../usecases/activity/get_recent_activities.dart';
import '../usecases/activity/search_activities.dart';
import '../usecases/activity/watch_activities.dart';

class ActivityUseCases {
  final GetRecentActivities getRecentActivities;
  final GetLiveActivities getLiveActivities;
  final SearchActivities searchActivities;
  final WatchActivities watchActivities;

  ActivityUseCases(IActivityRepository repository)
    : getRecentActivities = GetRecentActivities(repository),
      getLiveActivities = GetLiveActivities(repository),
      searchActivities = SearchActivities(repository),
      watchActivities = WatchActivities(repository);
}
