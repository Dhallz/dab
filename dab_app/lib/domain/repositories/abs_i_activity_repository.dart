import 'package:fpdart/fpdart.dart';
import '../../domain/core/failures.dart';
import '../../domain/entities/activity.dart';

abstract class IActivityRepository {
  Future<Either<AppFailure, List<Activity>>> getRecentActivities();
  Stream<Activity> watchActivities();
}
