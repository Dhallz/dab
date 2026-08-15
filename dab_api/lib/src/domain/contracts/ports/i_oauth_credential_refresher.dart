import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Refreshes expired per-user OAuth access tokens and persists the result.
/// CONTRACT: Returns the current user settings map (possibly unchanged).
abstract interface class IOauthCredentialRefresher {
  /// Loads the user's credential, refreshes when expired or [force] is true,
  /// and returns settings ready to overlay onto org config.
  Future<Either<Failure, Map<String, dynamic>>> ensureFresh({
    required String userId,
    required String providerId,
    bool force = false,
  });
}
