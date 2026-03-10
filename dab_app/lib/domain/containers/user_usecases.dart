import 'package:fpdart/fpdart.dart' hide Group;

import '../core/failures.dart';
import '../entities/group.dart';
import '../entities/user.dart';
import '../repositories/abs_i_user_repository.dart';

class UserUseCases {
  final IUserRepository _repo;

  UserUseCases(this._repo);

  Future<Either<AppFailure, List<User>>> getUsers() => _repo.getUsers();
  Future<Either<AppFailure, User>> getUser(String id) => _repo.getUser(id);
  Future<Either<AppFailure, List<Group>>> getGroups() => _repo.getGroups();
  Future<Either<AppFailure, Group>> saveGroup(Group group) =>
      _repo.saveGroup(group);
  Future<Either<AppFailure, void>> deleteGroup(String id) =>
      _repo.deleteGroup(id);
}
