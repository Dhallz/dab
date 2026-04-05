import '../../../domain/entities/activity.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';

class WatchActivities {
  final IActivityRepository repository;

  WatchActivities(this.repository);

  Stream<Activity> execute() => repository.watchActivities();
}
