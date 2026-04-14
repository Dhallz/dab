import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_search_query.dart';
import '../../objectbox.g.dart';
import '../core/local/objectbox_store.dart';
import '../core/local/records/explorer_activity_record.dart';
import '../core/local/records/explorer_cache_meta_record.dart';
import '../core/local/records/explorer_coverage_record.dart';
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

  Future<void> upsertActivities(Iterable<Activity> activities) async {
    _ensureCacheMetadata();
    final records = activities
        .map((activity) => activity.toExplorerRecord())
        .toList();
    if (records.isEmpty) return;
    _activityBox.putMany(records);
  }

  Future<Set<String>> getCoveredKeys({
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> users,
    required Set<String> providers,
  }) async {
    if (users.isEmpty || providers.isEmpty) return const {};

    final startKey = _dayKeyFromDate(startDate);
    final endKey = _dayKeyFromDate(endDate);
    final startEpoch = _dayEpochFromDayKey(startKey);
    final endEpoch = _dayEpochFromDayKey(endKey);
    final query = _coverageBox
        .query(ExplorerCoverageRecord_.dayEpochMs.between(startEpoch, endEpoch))
        .build();
    final records = query.find();
    query.close();

    return records
        .where((record) => users.contains(record.userId))
        .where((record) => providers.contains(record.providerKey))
        .map((record) => record.coverageKey)
        .toSet();
  }

  Future<void> markCoverage(Iterable<String> keys) async {
    _ensureCacheMetadata();
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final records = keys
        .map((key) => _coverageRecordFromKey(key, now))
        .whereType<ExplorerCoverageRecord>()
        .toList();
    if (records.isEmpty) return;
    _coverageBox.putMany(records);
  }

  Future<List<Activity>> searchByDate({
    required DateTime date,
    List<String> users = const [],
    Set<String> providers = const {},
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: date,
        endDate: date,
        users: users,
        providers: providers,
      ),
    );
  }

  Future<List<Activity>> searchByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    List<String> users = const [],
    Set<String> providers = const {},
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
      ),
    );
  }

  Future<List<Activity>> searchByProviders({
    required Set<String> providers,
    DateTime? startDate,
    DateTime? endDate,
    List<String> users = const [],
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
      ),
    );
  }

  Future<List<Activity>> searchByUsers({
    required List<String> users,
    DateTime? startDate,
    DateTime? endDate,
    Set<String> providers = const {},
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
      ),
    );
  }

  Future<List<Activity>> searchByDateRangeProvidersUsers({
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> providers,
    required List<String> users,
  }) {
    return searchActivities(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: users,
        providers: providers,
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
    final startBoundary = DateTime(start.year, start.month, start.day);
    final endBoundary = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
    final startEpoch = startBoundary.millisecondsSinceEpoch;
    final endEpoch = endBoundary.millisecondsSinceEpoch;

    return _activityBox
        .query(
          ExplorerActivityRecord_.createdAtEpochMs.between(
            startEpoch,
            endEpoch,
          ),
        )
        .build();
  }
}

ExplorerCoverageRecord? _coverageRecordFromKey(
  String key,
  int fetchedAtEpochMs,
) {
  final parts = key.split('|');
  if (parts.length != 3) return null;

  return ExplorerCoverageRecord(
    coverageKey: key,
    dayKey: parts[0],
    dayEpochMs: _dayEpochFromDayKey(parts[0]),
    userId: parts[1],
    providerKey: parts[2],
    lastFetchedAtEpochMs: fetchedAtEpochMs,
  );
}

String _dayKeyFromDate(DateTime value) {
  final normalized = value.toLocal();
  final month = normalized.month.toString().padLeft(2, '0');
  final day = normalized.day.toString().padLeft(2, '0');
  return '${normalized.year}-$month-$day';
}

int _dayEpochFromDayKey(String dayKey) {
  final parts = dayKey.split('-');
  if (parts.length != 3) return 0;

  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return 0;

  return DateTime(year, month, day).millisecondsSinceEpoch;
}
