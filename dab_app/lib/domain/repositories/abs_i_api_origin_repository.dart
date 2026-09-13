import 'package:fpdart/fpdart.dart';

import '../core/failures.dart';
import 'core/abs_i_repository.dart';

/// [ARCH: DOMAIN_REPOSITORY]
/// ROLE: Persist and apply the DAB API origin used by REST and WebSocket.
abstract interface class IApiOriginRepository extends IRepository {
  /// Stored origin, or the compile-time / local Docker default.
  Future<Either<AppFailure, String>> getOrigin();

  /// Validates, persists, retargets HTTP/WS, and clears tokens if the host changed.
  Future<Either<AppFailure, String>> setOrigin(String raw);
}
