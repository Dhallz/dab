import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/provider/provider_config.dart';
import '../../entities/user/git_branch_list.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Lists Bitbucket branch names for Settings inbox watches. Read-only.
abstract interface class AbsIBitbucketBranchCatalog {
  Future<Either<Failure, GitBranchList>> listBranches({
    required Map<String, dynamic> settings,
    required List<String> repos,
    ProviderConfig? orgConfig,
  });
}
