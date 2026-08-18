import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_activity_source.dart';

/// [ARCH: APPLICATION]
/// ROLE: Converts one raw connector payload row into normalized [Activity]s.
typedef ActivityMapping<T> =
    List<Activity> Function(T item, List<User> usersForConnector);

/// [ARCH: APPLICATION]
/// ROLE: Pairs an [AbsIActivitySource] with a Postgres-safe [providerId] and mapping closure.
/// CONTRACT: [mapItemToActivities] must be pure Domain logic ([T] is the source row type).

class TypedConnectorPair<T> {
  final AbsIActivitySource<T> source;

  /// Wire id aligning with [`ProviderConfig.id`] (`github`, `jira`, `phorge`, …).
  final String providerId;

  final ActivityMapping<T> mapItemToActivities;

  TypedConnectorPair({
    required this.source,
    required this.providerId,
    required this.mapItemToActivities,
  });
}

/// Type-erased connector row used when [UnifiedActivityFetcher] iterates all
/// providers. [ConnectorRegistry.register] wraps each [TypedConnectorPair] so
/// we never widen a [TypedConnectorPair] to a generic [dynamic] row type: a concrete mapper
/// `(GitHubCommitDto, …) → …` is not a subtype of `(dynamic, …) → …` on the
/// first parameter (contravariance), which caused runtime subtype errors for
/// every connector.
///
/// [fetchRawData] returns materialized rows; [mapItemToActivities] casts each
/// row back to the registration type [T].
class RegisteredConnectorPair {
  RegisteredConnectorPair({
    required this.providerId,
    required this.fetchRawData,
    required this.mapItemToActivities,
  });

  final String providerId;

  final Future<List<Object?>> Function(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) fetchRawData;

  final List<Activity> Function(Object? item, List<User> users)
      mapItemToActivities;
}

/// [ARCH: APPLICATION]
/// ROLE: Central registry for all activity connectors used by [UnifiedActivityFetcher].
/// CONSTRAINTS: Register pairs only via [registerActivityConnectors] during bootstrap.

class ConnectorRegistry {
  final List<RegisteredConnectorPair> _pairs = [];

  void register<T>(TypedConnectorPair<T> pair) {
    _pairs.add(
      RegisteredConnectorPair(
        providerId: pair.providerId,
        fetchRawData: (users, start, end, authoredOnly) async {
          final rows = await pair.source.fetchRawData(
            users,
            start,
            end,
            authoredOnly,
          );
          return List<Object?>.from(rows);
        },
        mapItemToActivities: (Object? item, List<User> users) =>
            pair.mapItemToActivities(item as T, users),
      ),
    );
  }

  List<RegisteredConnectorPair> get allPairs => List.unmodifiable(_pairs);
}
