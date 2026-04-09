import 'package:fpdart/fpdart.dart' hide Group;

import '../../domain/entities/group.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/user_identity.dart';
import '../core/failures.dart';

abstract class IUserRepository {
  Future<Either<AppFailure, List<User>>> getUsers();
  Future<Either<AppFailure, User>> getUser(String id);
  Future<Either<AppFailure, List<Group>>> getGroups();
  Future<Either<AppFailure, Group>> saveGroup(Group group);
  Future<Either<AppFailure, void>> deleteGroup(String id);
  
  /// Admin: Fetch all platform identity candidates.
  Future<Either<AppFailure, List<UserIdentity>>> getIdentities();
  
  /// Admin: Link a candidate identity to a DAB user.
  Future<Either<AppFailure, UserIdentity>> linkIdentity({
    required String userId,
    required String providerId,
    required String externalId,
  });

  /// Admin: Update a user's globally defined role.
  Future<Either<AppFailure, void>> updateUserRole({
    required String userId,
    required String role,
  });
}
