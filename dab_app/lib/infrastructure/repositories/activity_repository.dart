import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failures.dart';
import '../../../domain/entities/activity/activity.dart';
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
      return _mapAndNormalizeActivities(jsonList);
    });
  }

  @override
  Future<Either<AppFailure, List<Activity>>> searchActivities({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? users,
    bool authoredOnly = true,
  }) {
    return guardedCall(() async {
      final response = await _remoteDataSource.searchActivities(
        startDate: startDate,
        endDate: endDate,
        users: users,
        authoredOnly: authoredOnly,
      );

      final List<dynamic> jsonList = _getEnvelopeData(response);
      return _mapAndNormalizeActivities(jsonList);
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

  List<Activity> _mapAndNormalizeActivities(List<dynamic> jsonList) {
    final activities = jsonList
        .map((json) => ActivityMapper.fromMap(json))
        .map(_normalizeActivityProvider)
        .toList();

    activities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return activities;
  }

  Activity _normalizeActivityProvider(Activity activity) {
    final provider = activity.provider;

    if (provider is! SlackMessageProvider) {
      return activity;
    }

    final normalizedProvider = provider.copyWith(
      workspaceId: _normalizeSlackValue(provider.workspaceId),
      channelId: _normalizeSlackValue(provider.channelId),
      threadTs: _normalizeSlackValue(provider.threadTs),
      messageTs: _normalizeSlackValue(provider.messageTs),
    );

    return activity.copyWith(provider: normalizedProvider);
  }

  String? _normalizeSlackValue(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
