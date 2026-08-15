import 'package:fpdart/fpdart.dart';

import '../core/failures/failure.dart';
import '../entities/provider/provider_config.dart';
import '../entities/user/provider_whoami_result.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Validates provider credentials via whoami and optional watch-list
/// discovery.
/// CONTRACT: Read-only. Never logs tokens. Application use cases depend on
/// this port, not the infrastructure probe.
abstract interface class IProviderIdentityProbe {
  /// Verifies credentials for [providerId] and returns whoami plus optional
  /// watch-list discovery. Read-only; never logs tokens.
  Future<Either<Failure, ProviderWhoamiResult>> probe({
    required String providerId,
    required Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  });
}
