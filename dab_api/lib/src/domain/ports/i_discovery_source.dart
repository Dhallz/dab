import 'package:fpdart/fpdart.dart';

import '../core/failures/failure.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Heuristic identity discovery against an external provider.
/// CONTRACT: Resolves `(name, email)` to an external principal id where possible.
abstract interface class IDiscoverySource {
  /// Searches for a user identity on the external platform.
  Future<Either<Failure, String?>> lookupExternalId(String name, String email);
}
