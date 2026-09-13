import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/contracts/repositories/abs_i_activity_follow_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists the caller's Dashboard object Follow pins.
class ListMyActivityFollows {
  ListMyActivityFollows(this._follows);

  final AbsIActivityFollowRepository _follows;

  Future<Either<Failure, List<ActivityFollow>>> execute({
    required String userId,
  }) {
    return _follows.listForUser(userId);
  }
}
