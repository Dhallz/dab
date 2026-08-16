import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/git_watch_list.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads personal git inbox watches for Settings.
class ListMyGitWatches {
  final IUserRepository repository;

  ListMyGitWatches(this.repository);

  Future<Either<AppFailure, GitWatchList>> execute({
    required String providerId,
  }) => repository.listMyGitWatches(providerId: providerId);
}
