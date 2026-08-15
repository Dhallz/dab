import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/linear_team_watch_list.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Saves instance Linear `teamKeys` from Settings.
class SaveMyLinearTeams {
  final IUserRepository repository;

  SaveMyLinearTeams(this.repository);

  Future<Either<AppFailure, LinearTeamWatchList>> execute({
    required List<String> teamKeys,
  }) => repository.saveMyLinearTeams(teamKeys: teamKeys);
}
