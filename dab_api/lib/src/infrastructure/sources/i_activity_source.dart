import 'package:dab_api/src/domain/entities/user.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Raw I/O Handler for external system integration.
/// CONTRACT: Fetches raw protocol-specific data (DTOs) from APIs (GitHub, Phorge).
/// CONSTRAINTS: Must be READ-ONLY. Must not contain business logic for activity mapping.
///
/// This interface defines a "Source" of raw data. A "Provider" in DAB refers 
/// to the entire platform (e.g., Phabricator), whereas this Source specifically 
/// handles the technical fetch of a data type (Tasks, Revisions).
abstract interface class IActivitySource<T> {
  /// Fetches raw data from the external source for the given [users] 
  /// within the [start] and [end] time window.
  /// 
  /// If [authoredOnly] is true, the source should optimize for direct 
  /// transaction searching by user identifiers. If false (Explorer mode), 
  /// it should discover all activities in the current project context.
  ///
  /// Returns a list of raw data objects (usually DTOs or Bundles).
  Future<List<T>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  );
}
