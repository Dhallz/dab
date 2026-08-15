import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/provider/provider_config.dart';
import '../../entities/user/jira_project.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Lists Jira Cloud projects visible to merged user/org credentials.
abstract interface class IJiraProjectCatalog {
  Future<Either<Failure, List<JiraProject>>> listAccessible({
    required Map<String, dynamic> settings,
    ProviderConfig? orgConfig,
  });
}
