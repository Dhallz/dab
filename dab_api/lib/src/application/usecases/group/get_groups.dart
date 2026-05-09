import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failure.dart';
import '../../../domain/entities/group/group.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves all organizational groups.
/// CONTRACT: Returns [Group] list or [DatabaseFailure].
class GetGroups {
  final IUserRepository _repo;

  GetGroups(this._repo);

  Future<Either<DatabaseFailure, List<Group>>> execute() async {
    return _repo.getGroups();
  }
}
