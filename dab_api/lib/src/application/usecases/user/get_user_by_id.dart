import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Fetches a single User entity by its internal identifier.
/// CONTRACT: [NotFoundFailure] or [DatabaseFailure] on failure.

class GetUserById {
  final IUserRepository _repo;

  GetUserById(this._repo);

  Future<Either<Failure, User>> execute(String id) async {
    return _repo.getUser(id);
  }
}
