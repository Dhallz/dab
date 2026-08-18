import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads Follow picker rows for the Dashboard Following search.
class ListMyFollowCandidates {
  final IUserRepository repository;

  ListMyFollowCandidates(this.repository);

  Future<Either<AppFailure, List<FollowCandidate>>> execute({
    String query = '',
  }) => repository.listMyFollowCandidates(query: query);
}
