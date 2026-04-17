import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/activity/activity.dart';
import '../../repositories/abs_i_activity_repository.dart';

class ArchiveLiveActivity {
  final IActivityRepository repository;

  ArchiveLiveActivity(this.repository);

  Future<Either<AppFailure, Activity>> execute(String id) {
    return repository.archiveLiveActivity(id);
  }
}
