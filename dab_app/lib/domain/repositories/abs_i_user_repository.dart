import 'package:fpdart/fpdart.dart' hide Group;

import '../../domain/entities/group.dart';
import '../../domain/entities/user.dart';
import '../core/failures.dart';

abstract class IUserRepository {
  Future<Either<AppFailure, List<User>>> getUsers();
  Future<Either<AppFailure, User>> getUser(String id);
  Future<Either<AppFailure, List<Group>>> getGroups();
  Future<Either<AppFailure, Group>> saveGroup(Group group);
  Future<Either<AppFailure, void>> deleteGroup(String id);
}
