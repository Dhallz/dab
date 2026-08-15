import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Orchestrator for multi-source activity synchronization.
/// CONTRACT: Aggregates activities from all registered connectors via [RegisteredConnectorPair].
/// CONSTRAINTS: Must parallelize requests and handle individual source failures gracefully.
///
/// This service is the high-level entry point for fetching data from multiple
/// external platforms (GitHub, Phorge) by coordinating their specific Sources.
class UnifiedActivityFetcher {
  final ConnectorRegistry _registry;
  final AbsIProviderConfigRepository _configRepo;
  final IUserRepository _userRepo;

  /// Structured log sink (e.g. `sl<LoggingService>().record`); keeps Application free of I/O types.
  final void Function(
    String message, {
    String level,
    Map<String, dynamic>? extra,
  }) _log;

  UnifiedActivityFetcher(
    this._registry,
    this._configRepo,
    this._userRepo,
    this._log,
  );

  /// Aggregates and synchronizes activities from all registered sources.
  ///
  /// Flow:
  /// 1. Filters [users] for source-specific identifiers.
  /// 2. Iterates over all pairs in the [_registry].
  /// 3. Triggers [source.fetchRawData] in parallel.
  /// 4. Maps raw rows to Domain [Activity] entities via each [RegisteredConnectorPair.mapItemToActivities].
  /// 5. Flattens and sorts the final results by [createdAt] descending.
  Future<List<Activity>> fetchAll({
    required List<User> users,
    required DateTime start,
    required DateTime end,
    required bool authoredOnly,
    Set<String>? providerIds,
  }) async {
    if (users.isEmpty) return [];

    // Fetch all provider configurations to check for active status.
    final configsResult = await _configRepo.getConfigs();
    if (configsResult.isLeft()) {
      final failure = configsResult.getLeft().toNullable()!;
      _log(
        'UnifiedActivityFetcher: provider configs unavailable; skipping all connectors',
        level: 'WARNING',
        extra: {'failure': failure.message},
      );
    }
    final activeProviderIds = configsResult.fold(
      (_) => <String>{},
      (configs) => configs.where((c) => c.isActive).map((c) => c.id).toSet(),
    );

    // Fan-out: Trigger requests for all registered connector pairs simultaneously.
    final aggregationTasks = _registry.allPairs
        .where((pair) {
          if (!activeProviderIds.contains(pair.providerId)) return false;
          if (providerIds != null && !providerIds.contains(pair.providerId)) {
            return false;
          }
          return true;
        })
        .map((pair) async {
          try {
            final identitiesResult = await _userRepo
                .getIdentitiesForUsersAndProvider(
                  users.map((u) => u.id),
                  pair.providerId,
                );
            final identities = identitiesResult.getOrElse((_) => []);
            final linkedIdentitiesByUserId = {
              for (final identity in identities)
                if (identity.status == UserIdentityStatus.linked)
                  identity.userId: identity,
            };

            final usersForConnector = users
                .where((u) => linkedIdentitiesByUserId.containsKey(u.id))
                .map((u) {
                  final identity = linkedIdentitiesByUserId[u.id]!;
                  if (pair.providerId == 'phorge') {
                    return u.copyWith(
                      phorgePhid: identity.externalId,
                      phorgeUsername: identity.externalUsername,
                    );
                  }
                  return u;
                })
                .toList();
            if (usersForConnector.isEmpty) {
              return <Activity>[];
            }

            final rawDataList = await pair.fetchRawData(
              usersForConnector,
              start,
              end,
              authoredOnly,
            );

            return rawDataList
                .expand(
                  (item) =>
                      pair.mapItemToActivities(item, usersForConnector),
                )
                .toList();
          } catch (e) {
            // Individual source failure SHOULD NOT break the entire aggregation.
            _log(
              'UnifiedActivityFetcher: connector fetch failed',
              level: 'WARNING',
              extra: {
                'provider': pair.providerId,
                'error': e.toString(),
              },
            );
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
