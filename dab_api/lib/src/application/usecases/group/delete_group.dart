import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Permanently removes a custom group.
/// CONTRACT: Completes with unit or [DatabaseFailure].
class DeleteGroup {
  final IUserRepository _repo;

  DeleteGroup(this._repo);

  Future<Either<DatabaseFailure, void>> execute(String id) async {
    return _repo.deleteGroup(id);
  }
}
