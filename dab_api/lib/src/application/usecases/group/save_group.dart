import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/group/group.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Persists or updates a Group structure.
/// CONTRACT: Returns the saved [Group] or [DatabaseFailure].
class SaveGroup {
  final IUserRepository _repo;

  SaveGroup(this._repo);

  Future<Either<DatabaseFailure, Group>> execute(Group group) async {
    return _repo.saveGroup(group);
  }
}
