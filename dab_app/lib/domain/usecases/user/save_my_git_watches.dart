import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/git_watch_list.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Saves personal git inbox watches onto the caller's credential.
class SaveMyGitWatches {
  final IUserRepository repository;

  SaveMyGitWatches(this.repository);

  Future<Either<AppFailure, GitWatchList>> execute({
    required String providerId,
    required List<String> repos,
    List<String> branches = const [],
  }) => repository.saveMyGitWatches(
    providerId: providerId,
    repos: repos,
    branches: branches,
  );
}
