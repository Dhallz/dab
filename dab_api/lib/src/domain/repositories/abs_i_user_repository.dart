import 'package:fpdart/fpdart.dart' hide Group;

import '../core/failure.dart';
import '../entities/group.dart';
import '../entities/user.dart';

abstract class IUserRepository {
  Future<Either<DatabaseFailure, List<User>>> getUsers();
  Future<Either<DatabaseFailure, User>> getUser(String id);
  Future<Either<DatabaseFailure, List<User>>> getUsersByGroup(String groupId);

  Future<Either<DatabaseFailure, List<Group>>> getGroups();
  Future<Either<DatabaseFailure, Group>> saveGroup(Group group);
  Future<Either<DatabaseFailure, void>> deleteGroup(String id);
}
