import 'package:dab_api/src/domain/mappers/i_activity_mapper.dart';
import 'package:dab_api/src/infrastructure/sources/i_activity_source.dart';

/// [ARCH: APPLICATION]
/// ROLE: A structural container pairing a Source (I/O) with a Mapper (Logic).
/// CONTRACT: Encapsulates the complete "Connector Pair" for a specific data source.
///
/// This generic class ensures type-safety between the raw data fetched by the 
/// [source] and the transformation logic in the [mapper].
class ConnectorPair<T> {
  /// The infrastructure component responsible for raw I/O.
  final IActivitySource<T> source;
  
  /// The domain component responsible for business logic mapping.
  final IActivityMapper<T> mapper;

  ConnectorPair({
    required this.source,
    required this.mapper,
  });
}

/// [ARCH: APPLICATION]
/// ROLE: Central Registry for all active Activity connectors.
/// CONTRACT: Stores and exposes all [ConnectorPair]s for the [UnifiedActivityFetcher].
/// CONSTRAINTS: This is the single source of truth for "active" connectors. 
///
/// This registry enables the "Open-Closed" principle: to add a new connector 
/// (e.g. Phorge Tasks), you simply register a new [ConnectorPair] here during 
/// system initialization in the Service Locator.
class ConnectorRegistry {
  final List<ConnectorPair> _pairs = [];

  /// Registers a new [source] and [mapper] pair into the system.
  /// 
  /// The generic type [T] ensures that the source's output matches the mapper's input.
  void register<T>(IActivitySource<T> source, IActivityMapper<T> mapper) {
    _pairs.add(ConnectorPair<T>(source: source, mapper: mapper));
  }

  /// Returns an unmodifiable list of all registered [ConnectorPair]s.
  /// 
  /// Used by the [UnifiedActivityFetcher] to iterate and aggregate activities.
  List<ConnectorPair> get allPairs => List.unmodifiable(_pairs);
}
