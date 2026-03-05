import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../datasources/activity_remote_data_source.dart';
import '../repositories/core/repository.dart';

class ActivityRepository extends Repository implements IActivityRepository {
  final ActivityRemoteDataSource _remoteDataSource;

  ActivityRepository(this._remoteDataSource);

  @override
  Future<Either<AppFailure, List<Activity>>> getRecentActivities() {
    return guardedCall(() async {
      final response = await _remoteDataSource.getRecentActivities();

      // Handle the Vegas Pattern 304 Not Modified
      if (response.statusCode == 304) {
        // Here we would ideally load from the local ObjectBox cache
        // For the sake of this prototype assuming no new data, we return empty list
        // Or we should fetch from ObjectBox if implemented. For now:
        return []; // TODO: Implement reading from ObjectBox cache when 304
      }

      // Parse the Envelope Pattern
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> jsonList = responseData['data'] ?? [];

      return jsonList.map((json) => ActivityMapper.fromMap(json)).toList();
    });
  }

  @override
  Stream<Activity> watchActivities() {
    return _remoteDataSource
        .watchActivities()
        .map((event) {
          final Map<String, dynamic> json = jsonDecode(event);
          if (json['type'] == 'ACTIVITY_RECEIVED') {
            return ActivityMapper.fromMap(json['data']);
          }
          throw Exception('Unknown event type');
        })
        .handleError((e) {
          print('Error watching activities: $e');
        });
  }
}
