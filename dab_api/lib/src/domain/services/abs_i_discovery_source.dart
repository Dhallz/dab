import 'package:fpdart/fpdart.dart';
import '../../domain/core/failure.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Interface for sources that support heuristic user discovery.
/// CONTRACT: Fetches a unique identifier (PHID/ID) from the platform 
///            based on user metadata (name/email).
abstract interface class IDiscoverySource {
  /// Searches for a user identity on the external platform.
  Future<Either<Failure, String?>> lookupExternalId(String name, String email);
}
