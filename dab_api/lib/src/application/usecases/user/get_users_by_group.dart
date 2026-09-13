import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves users belonging to a specific group.
/// CONTRACT: Returns users for [groupId] or [DatabaseFailure].
class GetUsersByGroup {
  final IUserRepository _repo;

  GetUsersByGroup(this._repo);

  Future<Either<DatabaseFailure, List<User>>> execute(String groupId) async {
    return _repo.getUsersByGroup(groupId);
  }
}
