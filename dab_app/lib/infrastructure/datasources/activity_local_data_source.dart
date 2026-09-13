import '../../domain/entities/activity/explorer_cache_clear_request.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_search_query.dart';
import '../../domain/core/org_calendar.dart';
import '../core/local/records/explorer_activity_record.dart';
import '../core/local/records/explorer_cache_meta_record.dart';
import '../core/local/records/explorer_coverage_record.dart';
import '../../objectbox.g.dart';
import '../core/local/objectbox_store.dart';
import 'activity_search_query_mapper.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Local ObjectBox persistence for explorer activity search and coverage metadata.
/// CONTRACT: Queries and upserts cached activity data using the shared [ActivitySearchQuery] contract.
/// CONSTRAINTS: Owns all ObjectBox access for activity cache features.
class ActivityLocalDataSource {
  final ObjectBoxStore _store;

  ActivityLocalDataSource(this._store);

  Box<ExplorerActivityRecord> get _activityBox =>
      _store.store.box<ExplorerActivityRecord>();

  Box<ExplorerCoverageRecord> get _coverageBox =>
      _store.store.box<ExplorerCoverageRecord>();

  Box<ExplorerCacheMetaRecord> get _metaBox =>
      _store.store.box<ExplorerCacheMetaRecord>();

  Future<ExplorerCacheClearResult> clearExplorerCache({
    ExplorerCacheClearRequest? request,
  }) async {
    if (request == null) {
      final activityCount = _activityBox.count();
      final coverageCount = _coverageBox.count();
      _activityBox.removeAll();
      _coverageBox.removeAll();
      return ExplorerCacheClearResult(
        removedActivities: activityCount,
        removedCoverageRecords: coverageCount,
      );
    }

    final providers = request.providerIds
        .map((id) => id.trim().toLowerCase())
        .where((id) => id.isNotEmpty)
        .toSet();
    if (providers.isEmpty) {
      return const ExplorerCacheClearResult(
        removedActivities: 0,
        removedCoverageRecords: 0,
      );
    }

    final window = orgDateWindowEpochMs(
      request.orgTimezoneId,
      request.startDate,
      request.endDate,
    );

    final activityQuery = _activityBox
        .query(
          ExplorerActivityRecord_.createdAtEpochMs.between(
            window.startEpochMs,
            window.endEpochMsExclusive - 1,
          ),
        )
        .build();
    final activities = activityQuery.find();
    activityQuery.close();

    final activityIds = activities
        .where((record) => providers.contains(record.providerKey.toLowerCase()))
        .map((record) => record.id)
        .toList();
    if (activityIds.isNotEmpty) {
      _activityBox.removeMany(activityIds);
    }

    final coverageQuery = _coverageBox
        .query(
          ExplorerCoverageRecord_.dayEpochMs.between(
            window.startEpochMs,
            window.endEpochMsExclusive - 1,
          ),
        )
        .build();
    final coverageRows = coverageQuery.find();
    coverageQuery.close();

    final coverageIds = coverageRows
        .where((record) => providers.contains(record.providerKey.toLowerCase()))
        .map((record) => record.id)
        .toList();
    if (coverageIds.isNotEmpty) {
      _coverageBox.removeMany(coverageIds);
    }

    return ExplorerCacheClearResult(
      removedActivities: activityIds.length,
      removedCoverageRecords: coverageIds.length,
    );
  }

  Future<List<Activity>> searchActivities(ActivitySearchQuery query) async {
    _ensureCacheMetadata();
    final dateQuery = _queryByDateRange(query);
    final records = dateQuery.find();
    dateQuery.close();
    final filtered = records
        .where(
          (record) =>
              ActivitySearchQueryMapper.matchesLocalRecord(record, query),
        )
        .toList();

    filtered.sort(
      (a, b) => query.sortDescending
          ? b.createdAtEpochMs.compareTo(a.createdAtEpochMs)
          : a.createdAtEpochMs.compareTo(b.createdAtEpochMs),
    );

    final limited = query.limit != null && query.limit! > 0
        ? filtered.take(query.limit!).toList()
        : filtered;

    return limited.map((record) => record.toDomain).toList();
  }

  Future<void> upsertActivities(
    Iterable<Activity> activities, {
    required String orgTimezoneId,
  }) async {
    _ensureCacheMetadata();
    final records = activities
        .map((activity) => activity.toExplorerRecord(orgTimezoneId))
        .toList();
    if (records.isEmpty) return;
    _activityBox.putMany(records);
  }

  Future<Set<String>> getCoveredKeys({
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> users,
    required Set<String> providers,
    required String orgTimezoneId,
  }) async {
    if (users.isEmpty || providers.isEmpty) return const {};

    final window = orgDateWindowEpochMs(orgTimezoneId, startDate, endDate);
    final query = _coverageBox
        .query(
          ExplorerCoverageRecord_.dayEpochMs.between(
            window.startEpochMs,
            window.endEpochMsExclusive - 1,
          ),
        )
        .build();
    final records = query.find();
    query.close();

    return records
        .where((record) => users.contains(record.userId))
        .where((record) => providers.contains(record.providerKey))
        .map((record) => record.coverageKey)
        .toSet();
  }

  Future<void> markCoverage(
    Iterable<String> keys, {
    required String orgTimezoneId,
  }) async {
    _ensureCacheMetadata();
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final records = keys
        .map((key) => _coverageRecordFromKey(key, now, orgTimezoneId))
        .whereType<ExplorerCoverageRecord>()
        .toList();
    if (records.isEmpty) return;
    _coverageBox.putMany(records);
  }

  Future<List<Activity>> searchByDate({
    required DateTime date,
    List<String> users = const [],
    Set<String> providers = const {},
    String orgTimezoneId = kDefaultOrgTimezoneId,
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: date,
        endDate: date,
        users: users,
        providers: providers,
        orgTimezoneId: orgTimezoneId,
      ),
    );
  }

  Future<List<Activity>> searchByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    List<String> users = const [],
    Set<String> providers = const {},
    String orgTimezoneId = kDefaultOrgTimezoneId,
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
        orgTimezoneId: orgTimezoneId,
      ),
    );
  }

  Future<List<Activity>> searchByProviders({
    required Set<String> providers,
    DateTime? startDate,
    DateTime? endDate,
    List<String> users = const [],
    String orgTimezoneId = kDefaultOrgTimezoneId,
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
        orgTimezoneId: orgTimezoneId,
      ),
    );
  }

  Future<List<Activity>> searchByUsers({
    required List<String> users,
    DateTime? startDate,
    DateTime? endDate,
    Set<String> providers = const {},
    String orgTimezoneId = kDefaultOrgTimezoneId,
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
        orgTimezoneId: orgTimezoneId,
      ),
    );
  }

  Future<List<Activity>> searchByDateRangeProvidersUsers({
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> providers,
    required List<String> users,
    String orgTimezoneId = kDefaultOrgTimezoneId,
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
        orgTimezoneId: orgTimezoneId,
      ),
    );
  }

  void _ensureCacheMetadata() {
    final query = _metaBox.query().build();
    final existing = query.findFirst();
    query.close();
    if (existing != null) return;
    _metaBox.put(
      ExplorerCacheMetaRecord(
        cacheSchemaVersion: 1,
        lastMigrationAtEpochMs: DateTime.now().toUtc().millisecondsSinceEpoch,
      ),
    );
  }

  Query<ExplorerActivityRecord> _queryByDateRange(ActivitySearchQuery query) {
    if (query.startDate == null && query.endDate == null) {
      return _activityBox.query().build();
    }

    final start = query.startDate ?? query.endDate!;
    final end = query.endDate ?? query.startDate!;
    final window = orgDateWindowEpochMs(query.orgTimezoneId, start, end);

    return _activityBox
        .query(
          ExplorerActivityRecord_.createdAtEpochMs.between(
            window.startEpochMs,
            window.endEpochMsExclusive - 1,
          ),
        )
        .build();
  }
}

ExplorerCoverageRecord? _coverageRecordFromKey(
  String key,
  int fetchedAtEpochMs,
  String orgTimezoneId,
) {
  final parts = key.split('|');
  if (parts.length != 3) return null;

  return ExplorerCoverageRecord(
    coverageKey: key,
    dayKey: parts[0],
    dayEpochMs: orgDayEpochMsFromDayKey(orgTimezoneId, parts[0]),
    userId: parts[1],
    providerKey: parts[2],
    lastFetchedAtEpochMs: fetchedAtEpochMs,
  );
}
