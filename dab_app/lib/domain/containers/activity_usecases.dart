import '../repositories/abs_i_activity_repository.dart';

class ActivityUseCases {
  final IActivityRepository repository;

  ActivityUseCases(this.repository);

  Future<void> getRecent() => repository.getRecentActivities();
  Stream<dynamic> watch() => repository.watchActivities();
}
