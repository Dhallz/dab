import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import 'package:dab_api/src/domain/ports/i_activity_source.dart';

/// [ARCH: APPLICATION]
/// ROLE: Pairs an [IActivitySource] with its [IActivityMapper] for one payload type [T].
/// CONTRACT: Source output type must match mapper input type (enforced at [register]).

class TypedConnectorPair<T> {
  final IActivitySource<T> source;
  final IActivityMapper<T> mapper;

  TypedConnectorPair({
    required this.source,
    required this.mapper,
  });
}

/// [ARCH: APPLICATION]
/// ROLE: Central registry for all activity connectors used by [UnifiedActivityFetcher].
/// CONSTRAINTS: Register pairs only via [registerActivityConnectors] during bootstrap.

class ConnectorRegistry {
  final List<TypedConnectorPair<dynamic>> _pairs = [];

  void register<T>(IActivitySource<T> source, IActivityMapper<T> mapper) {
    _pairs.add(TypedConnectorPair<T>(source: source, mapper: mapper));
  }

  List<TypedConnectorPair<dynamic>> get allPairs => List.unmodifiable(_pairs);
}
