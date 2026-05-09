import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../entities/phorge/phorge_directory_user.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Read-only access to the Phorge user directory for provisioning.
/// CONTRACT: Implemented by infrastructure; returns domain [PhorgeDirectoryUser] rows.

abstract interface class PhorgeUserDirectoryPort {
  Future<Either<Failure, List<PhorgeDirectoryUser>>> fetchDirectoryUsers();
}
