import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/domain/entities/activity.dart';
import 'package:dab_api/src/domain/entities/user.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Orchestrator for multi-source activity synchronization.
/// CONTRACT: Aggregates activities from all registered [ConnectorPair]s.
/// CONSTRAINTS: Must parallelize requests and handle individual source failures gracefully.
///
/// This service is the high-level entry point for fetching data from multiple 
/// external platforms (GitHub, Phorge) by coordinating their specific Sources.
class UnifiedActivityFetcher {
  final ConnectorRegistry _registry;

  UnifiedActivityFetcher(this._registry);

  /// Aggregates and synchronizes activities from all registered sources.
  /// 
  /// Flow:
  /// 1. Filters [users] for source-specific identifiers.
  /// 2. Iterates over all [ConnectorPair]s in the [_registry].
  /// 3. Triggers [source.fetchRawData] in parallel.
  /// 4. Maps raw results to Domain [Activity] entities via [mapper.mapToActivities].
  /// 5. Flattens and sorts the final results by [createdAt] descending.
  Future<List<Activity>> fetchAll({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
  }) async {
    final validUsers = users.where((u) => u.phorgePhid != null).toList();
    if (validUsers.isEmpty) return [];

    // Fan-out: Trigger requests for all registered connector pairs simultaneously.
    final aggregationTasks = _registry.allPairs.map((pair) async {
      try {
        final rawDataList = await pair.source.fetchRawData(
          validUsers,
          start,
          end,
          authoredOnly,
        );
        
        // Transform the raw DTOs into high-level Domain Activities.
        return rawDataList
            .expand((item) => pair.mapper.mapToActivities(item, validUsers))
            .toList();
      } catch (e) {
        // Individual source failure SHOULD NOT break the entire aggregation.
        // We log the error and return an empty list for this pair.
        print('UnifiedActivityFetcher: Error fetching from ${pair.mapper.providerName}: $e');
        return <Activity>[];
      }
    });

    final results = await Future.wait(aggregationTasks);
    // Flatten the List<List<Activity>> into a single List<Activity>
    final allActivities = results.expand((list) => list).toList();

    // Temporal Sort: Ensure the most recent activity is first.
    allActivities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return allActivities;
  }
}
