import '../../../domain/entities/activity/activity_live_event.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';

class WatchActivities {
  final IActivityRepository repository;

  WatchActivities(this.repository);

  Stream<ActivityLiveEvent> execute() => repository.watchActivities();
}
