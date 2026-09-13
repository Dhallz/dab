/// [ARCH: DOMAIN]
/// ROLE: Parameters for selective Explorer ObjectBox cache eviction.
/// CONTRACT: [startDate] and [endDate] are org-calendar picker days (date-only semantics).
/// CONSTRAINTS: [providerIds] must be non-empty when clearing a scoped range.
class ExplorerCacheClearRequest {
  final DateTime startDate;
  final DateTime endDate;
  final Set<String> providerIds;
  final String orgTimezoneId;

  const ExplorerCacheClearRequest({
    required this.startDate,
    required this.endDate,
    required this.providerIds,
    required this.orgTimezoneId,
  });
}

/// [ARCH: DOMAIN]
/// ROLE: Outcome of an Explorer cache clear operation.
class ExplorerCacheClearResult {
  final int removedActivities;
  final int removedCoverageRecords;

  const ExplorerCacheClearResult({
    required this.removedActivities,
    required this.removedCoverageRecords,
  });

  int get totalRemoved => removedActivities + removedCoverageRecords;
}
