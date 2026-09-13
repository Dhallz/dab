import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/git_branch_list.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads unique branch names on selected git inbox repos for Settings.
class ListMyGitBranches {
  final IUserRepository repository;

  ListMyGitBranches(this.repository);

  Future<Either<AppFailure, GitBranchList>> execute({
    required String providerId,
    List<String> repos = const [],
  }) => repository.listMyGitBranches(providerId: providerId, repos: repos);
}
