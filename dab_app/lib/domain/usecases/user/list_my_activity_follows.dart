import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads the caller's Dashboard object Follow pins.
class ListMyActivityFollows {
  final IUserRepository repository;

  ListMyActivityFollows(this.repository);

  Future<Either<AppFailure, List<ActivityFollow>>> execute() =>
      repository.listMyActivityFollows();
}
