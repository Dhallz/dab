import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failures.dart';
import '../../../domain/entities/activity.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../datasources/activity_remote_data_source.dart';
import '../repositories/core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of Activity retrieval and synchronization in the Client.
/// CONTRACT: Implements [IActivityRepository].
/// CONSTRAINTS: Bridges [ActivityRemoteDataSource] (API) to Domain Entities. Handles envelope stripping.
/// 
/// This repository manages the lifecycle of activities from fetching historical 
/// data to watching real-time streams via WebSockets.
class ActivityRepository extends Repository implements IActivityRepository {
  final ActivityRemoteDataSource _remoteDataSource;

  ActivityRepository(this._remoteDataSource);

  @override
  Future<Either<AppFailure, List<Activity>>> getRecentActivities() {
    return guardedCall(() async {
      final response = await _remoteDataSource.getRecentActivities();
      final List<dynamic> jsonList = _getEnvelopeData(response);
      return jsonList.map((json) => ActivityMapper.fromMap(json)).toList();
    });
  }

  @override
  Future<Either<AppFailure, List<Activity>>> searchActivities({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? users,
    bool authoredOnly = true,
  }) {
    print('DEBUG: ActivityRepository.searchActivities entry');
    return guardedCall(() async {
      print(
        'DEBUG: ActivityRepository.searchActivities calling remoteDataSource',
      );
      final response = await _remoteDataSource.searchActivities(
        startDate: startDate,
        endDate: endDate,
        users: users,
        authoredOnly: authoredOnly,
      );

      print(
        'DEBUG: ActivityRepository.searchActivities response: ${response.statusCode}',
      );
      final List<dynamic> jsonList = _getEnvelopeData(response);
      print(
        'DEBUG: ActivityRepository.searchActivities jsonList length: ${jsonList.length}',
      );
      return jsonList.map((json) => ActivityMapper.fromMap(json)).toList();
    });
  }

  List<dynamic> _getEnvelopeData(Response response) {
    if (response.statusCode == 304 || response.data == null) return [];

    final dynamic data = response.data;
    final Map<String, dynamic> map;

    if (data is Map<String, dynamic>) {
      map = data;
    } else {
      map = jsonDecode(data.toString());
    }

    return map['data'] ?? [];
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
          // Log or handle error appropriately
        });
  }
}
