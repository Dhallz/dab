import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failures.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/entities/activity/explorer_cache_clear_request.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_category.dart';
import '../../../domain/entities/activity/activity_live_event.dart';
import '../../../domain/entities/activity/activity_search_query.dart';
import '../../../domain/repositories/abs_i_activity_repository.dart';
import '../datasources/activity_local_data_source.dart';
import '../datasources/activity_remote_data_source.dart';
import '../datasources/activity_search_query_mapper.dart';
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
  final ActivityLocalDataSource _localDataSource;

  ActivityRepository(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<AppFailure, List<Activity>>> getRecentActivities() {
    return guardedCall(() async {
      final response = await _remoteDataSource.getRecentActivities();
      final List<dynamic> jsonList = _getEnvelopeData(response);
      return _mapAndNormalizeActivities(jsonList);
    });
  }

  @override
  Future<Either<AppFailure, List<Activity>>> getLiveActivities({
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  }) {
    return guardedCall(() async {
      final response = await _remoteDataSource.getLiveActivities(
        limit: limit,
        global: global,
        includeArchived: includeArchived,
      );
      if (response.statusCode == 304) {
        return const <Activity>[];
      }
      final List<dynamic> jsonList = _getEnvelopeData(response);
      return _mapAndNormalizeActivities(jsonList);
    });
  }

  @override
  Future<Either<AppFailure, Activity>> archiveLiveActivity(String id) {
    return guardedCall(() async {
      final response = await _remoteDataSource.archiveLiveActivity(id);
      return _decodeTriageEnvelope(response);
    });
  }

  @override
  Future<Either<AppFailure, Activity>> unarchiveLiveActivity(String id) {
    return guardedCall(() async {
      final response = await _remoteDataSource.unarchiveLiveActivity(id);
      return _decodeTriageEnvelope(response);
    });
  }

  Activity _decodeTriageEnvelope(Response response) {
    final data = response.data;
    final Map<String, dynamic> envelope = data is Map<String, dynamic>
        ? data
        : jsonDecode(data.toString());
    final payload = envelope['data'];
    if (payload is! Map<String, dynamic>) {
      throw StateError('Triage response missing activity payload');
    }
    return _normalizeActivityProvider(ActivityMapper.fromMap(payload));
  }

  @override
  Future<Either<AppFailure, List<Activity>>> searchActivities(
    ActivitySearchQuery query,
  ) {
    return guardedCall(() async {
      final normalizedQuery = _normalizeQuery(query);

      if (!_isPastDateWindow(normalizedQuery)) {
        final mappedActivities = await _fetchRemoteMappedActivities(
          normalizedQuery,
        );
        return _filterAndSortByQuery(mappedActivities, normalizedQuery);
      }

      final localActivities = await _localDataSource.searchActivities(
        normalizedQuery,
      );
      final missingCoverageKeys = await _getMissingCoverageKeys(
        normalizedQuery,
      );
      if (missingCoverageKeys.isEmpty) return localActivities;

      // Store the full API payload; provider/category filters apply on local read.
      final mappedActivities = await _fetchRemoteMappedActivities(
        normalizedQuery,
      );
      await _localDataSource.upsertActivities(
        mappedActivities,
        orgTimezoneId: normalizedQuery.orgTimezoneId,
      );
      await _localDataSource.markCoverage(
        missingCoverageKeys,
        orgTimezoneId: normalizedQuery.orgTimezoneId,
      );

      return _localDataSource.searchActivities(normalizedQuery);
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
  Stream<ActivityLiveEvent> watchActivities() {
    return _remoteDataSource
        .watchActivities()
        .map(_decodeLiveEvent)
        .where((event) => event != null)
        .cast<ActivityLiveEvent>();
  }

  ActivityLiveEvent? _decodeLiveEvent(dynamic event) {
    try {
      final dynamic decoded = event is String ? jsonDecode(event) : event;
      if (decoded is! Map<String, dynamic>) {
        print(
          '[LIVE_CLIENT] ws_decode_skip reason=non_map runtime=${decoded.runtimeType}',
        );
        return null;
      }
      final type = decoded['type']?.toString();
      final payload = decoded['data'];

      switch (type) {
        case 'ACTIVITY_RECEIVED':
          if (payload is! Map<String, dynamic>) {
            print(
              '[LIVE_CLIENT] ws_decode_skip reason=payload_non_map runtime=${payload.runtimeType}',
            );
            return null;
          }
          final activity = _normalizeActivityProvider(
            ActivityMapper.fromMap(payload),
          );
          print(
            '[LIVE_CLIENT] ws_activity_received activity_id=${activity.id} user_id=${activity.userId} provider=${activity.provider.name}',
          );
          return ActivityReceivedEvent(activity);
        case 'ACTIVITY_ARCHIVED':
        case 'ACTIVITY_UNARCHIVED':
          if (payload is! Map<String, dynamic>) return null;
          final id = payload['id']?.toString();
          final userId = payload['userId']?.toString() ?? '';
          if (id == null) return null;
          print('[LIVE_CLIENT] ws_triage type=$type activity_id=$id');
          return type == 'ACTIVITY_ARCHIVED'
              ? ActivityArchivedEvent(activityId: id, userId: userId)
              : ActivityUnarchivedEvent(activityId: id, userId: userId);
        default:
          print('[LIVE_CLIENT] ws_decode_skip reason=event_type type=$type');
          return null;
      }
    } catch (error) {
      print('[LIVE_CLIENT] ws_decode_error error=$error raw=$event');
      return null;
    }
  }

  List<Activity> _mapAndNormalizeActivities(List<dynamic> jsonList) {
    final activities = jsonList
        .map((json) => ActivityMapper.fromMap(json))
        .map(_normalizeActivityProvider)
        .toList();

    activities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return activities;
  }

  Future<List<Activity>> _fetchRemoteMappedActivities(
    ActivitySearchQuery query,
  ) async {
    final response = await _remoteDataSource.searchActivities(query);
    final List<dynamic> jsonList = _getEnvelopeData(response);
    return _mapAndNormalizeActivities(jsonList);
  }

  List<Activity> _filterAndSortByQuery(
    List<Activity> activities,
    ActivitySearchQuery query,
  ) {
    final filtered = activities
        .where(
          (activity) =>
              ActivitySearchQueryMapper.matchesActivity(activity, query),
        )
        .toList();

    filtered.sort(
      (a, b) => query.sortDescending
          ? b.createdAt.compareTo(a.createdAt)
          : a.createdAt.compareTo(b.createdAt),
    );

    if (query.limit != null && query.limit! > 0) {
      return filtered.take(query.limit!).toList();
    }
    return filtered;
  }

  @override
  Future<Either<AppFailure, ExplorerCacheClearResult>> clearExplorerCache({
    ExplorerCacheClearRequest? request,
  }) {
    return guardedCall(() async {
      return _localDataSource.clearExplorerCache(request: request);
    });
  }

  bool _isPastDateWindow(ActivitySearchQuery query) {
    final end = query.endDate ?? query.startDate;
    if (end == null) return false;

    final todayKey = orgDayKeyFromUtc(
      query.orgTimezoneId,
      DateTime.now().toUtc(),
    );
    final endKey = orgCalendarDayString(query.orgTimezoneId, end);
    return endKey.compareTo(todayKey) < 0;
  }

  Future<Set<String>> _getMissingCoverageKeys(ActivitySearchQuery query) async {
    final dateRange = _resolveRange(query);
    if (dateRange == null) return const {};

    final users = query.normalizedUsers;
    if (users.isEmpty) return const {};

    final providers = query.normalizedCoverageProviders.isNotEmpty
        ? query.normalizedCoverageProviders
        : query.normalizedProviders;
    if (providers.isEmpty) return const {};

    final expected = _buildCoverageKeys(
      startDate: dateRange.$1,
      endDate: dateRange.$2,
      users: users,
      providers: providers,
      orgTimezoneId: query.orgTimezoneId,
    );
    if (expected.isEmpty) return const {};

    final covered = await _localDataSource.getCoveredKeys(
      startDate: dateRange.$1,
      endDate: dateRange.$2,
      users: users,
      providers: providers,
      orgTimezoneId: query.orgTimezoneId,
    );
    return expected.difference(covered);
  }

  Set<String> _buildCoverageKeys({
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> users,
    required Set<String> providers,
    required String orgTimezoneId,
  }) {
    final keys = <String>{};
    var cursor = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    while (!cursor.isAfter(end)) {
      final dayKey = orgCalendarDayString(orgTimezoneId, cursor);
      for (final user in users) {
        for (final provider in providers) {
          keys.add('$dayKey|$user|$provider');
        }
      }
      cursor = cursor.add(const Duration(days: 1));
    }
    return keys;
  }

  (DateTime, DateTime)? _resolveRange(ActivitySearchQuery query) {
    final start = query.startDate;
    final end = query.endDate;
    if (start == null && end == null) return null;

    final resolvedStart = start ?? end!;
    final resolvedEnd = end ?? start!;
    if (resolvedStart.isBefore(resolvedEnd)) {
      return (resolvedStart, resolvedEnd);
    }
    return (resolvedEnd, resolvedStart);
  }

  ActivitySearchQuery _normalizeQuery(ActivitySearchQuery query) {
    final users = query.normalizedUsers.toList()..sort();
    final providers = query.normalizedProviders;
    final coverageProviders = query.normalizedCoverageProviders;
    final categories = Set<ActivityCategory>.from(query.categories);
    final normalizedRange = _resolveRange(query);
    return ActivitySearchQuery(
      startDate: normalizedRange?.$1,
      endDate: normalizedRange?.$2,
      users: users,
      providers: providers,
      coverageProviders: coverageProviders,
      categories: categories,
      text: query.normalizedText,
      authoredOnly: query.authoredOnly,
      sortDescending: query.sortDescending,
      limit: query.limit,
      cursor: query.cursor,
      orgTimezoneId: query.orgTimezoneId,
    );
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
