import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads Linear teams for the Settings watch-list picker.
class ListMyLinearTeams {
  final IUserRepository repository;

  ListMyLinearTeams(this.repository);

  Future<Either<AppFailure, LinearTeamWatchList>> execute() =>
      repository.listMyLinearTeams();
}
