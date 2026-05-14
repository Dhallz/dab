import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves the complete user directory.
/// CONTRACT: Returns all registered DAB [User] entities or a [DatabaseFailure].
class GetUsers {
  final IUserRepository _repo;

  GetUsers(this._repo);

  Future<Either<DatabaseFailure, List<User>>> execute() async {
    return _repo.getUsers();
  }
}
