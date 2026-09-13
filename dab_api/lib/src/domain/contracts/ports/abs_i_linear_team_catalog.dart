import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/provider/provider_config.dart';
import '../../entities/user/linear_team.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Lists Linear teams visible to merged user/org credentials.
abstract interface class AbsILinearTeamCatalog {
  Future<Either<Failure, List<LinearTeam>>> listAccessible({
    required Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  });
}
