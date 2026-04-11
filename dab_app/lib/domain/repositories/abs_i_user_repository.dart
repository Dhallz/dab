import 'package:fpdart/fpdart.dart' hide Group;

import '../../domain/entities/group/group.dart';
import '../../domain/entities/user/user.dart';
import '../../domain/entities/user/user_role.dart';
import '../../domain/entities/user/user_identity.dart';
import '../../domain/entities/user/user_identity_status.dart';
import '../core/failures.dart';

abstract class IUserRepository {
  Future<Either<AppFailure, List<User>>> getUsers();
  Future<Either<AppFailure, User>> getUser(String id);
  Future<Either<AppFailure, List<Group>>> getGroups();
  Future<Either<AppFailure, Group>> saveGroup(Group group);
  Future<Either<AppFailure, void>> deleteGroup(String id);
  
  /// Admin: Fetch all platform identity candidates.
  Future<Either<AppFailure, List<UserIdentity>>> getIdentities();

  /// Admin: Count of identities in [pending] or [failed] state (for shell badge).
  Future<Either<AppFailure, int>> getIdentityResolutionSummary();
  
  /// Admin: Link a candidate identity to a DAB user.
  Future<Either<AppFailure, UserIdentity>> linkIdentity({
    required String userId,
    required String providerId,
    required String externalId,
    String? externalUsername,
  });

  /// Admin: Approve or reject a candidate identity (DAB-40).
  Future<Either<AppFailure, UserIdentity>> resolveIdentity({
    required String userId,
    required String providerId,
    required UserIdentityStatus status,
  });

  /// Admin: Update a user's globally defined role.
  Future<Either<AppFailure, void>> updateUserRole({
    required String userId,
    required UserRole role,
  });
}
