import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';

/// [ARCH: APPLICATION]
/// ROLE: Converts one raw connector payload row into normalized [Activity]s.
typedef ActivityMapping<T> =
    List<Activity> Function(T item, List<User> usersForConnector);

/// [ARCH: APPLICATION]
/// ROLE: Pairs an [IActivitySource] with a Postgres-safe [providerId] and mapping closure.
/// CONTRACT: [mapItemToActivities] must be pure Domain logic ([T] is the source row type).

class TypedConnectorPair<T> {
  final IActivitySource<T> source;

  /// Wire id aligning with [`ProviderConfig.id`] (`github`, `jira`, `phorge`, …).
  final String providerId;

  final ActivityMapping<T> mapItemToActivities;

  TypedConnectorPair({
    required this.source,
    required this.providerId,
    required this.mapItemToActivities,
  });
}

/// [ARCH: APPLICATION]
/// ROLE: Central registry for all activity connectors used by [UnifiedActivityFetcher].
/// CONSTRAINTS: Register pairs only via [registerActivityConnectors] during bootstrap.

class ConnectorRegistry {
  final List<TypedConnectorPair<dynamic>> _pairs = [];

  void register<T>(TypedConnectorPair<T> pair) {
    _pairs.add(pair);
  }

  List<TypedConnectorPair<dynamic>> get allPairs => List.unmodifiable(_pairs);
}
