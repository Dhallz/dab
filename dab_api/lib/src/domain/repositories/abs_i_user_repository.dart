import 'package:fpdart/fpdart.dart' hide Group;
import '../core/failure.dart';
import '../entities/group.dart';
import '../entities/user.dart';
import '../entities/user_identity.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Abstract contract for User and Group persistence.
/// CONTRACT: Defines the business operations for user directory management.
/// CONSTRAINTS: Implementation resides in Infrastructure layer (UserRepository).
abstract class IUserRepository {
  /// Fetches all registered users.
  Future<Either<DatabaseFailure, List<User>>> getUsers();
  
  /// Fetches a single user by their unique UUID.
  Future<Either<DatabaseFailure, User>> getUser(String id);
  
  /// Attempts to find a user by their registered email.
  Future<Either<DatabaseFailure, User?>> findByEmail(String email);
  
  /// Fetches all users belonging to a specific group.
  Future<Either<DatabaseFailure, List<User>>> getUsersByGroup(String groupId);

  /// Creates or updates a user record.
  Future<Either<DatabaseFailure, void>> saveUser(User user);

  /// Fetches all groups (Custom and Provider).
  Future<Either<DatabaseFailure, List<Group>>> getGroups();
  
  /// Creates or updates a group and its membership associations.
  Future<Either<DatabaseFailure, Group>> saveGroup(Group group);
  
  /// Permanently removes a custom group.
  Future<Either<DatabaseFailure, void>> deleteGroup(String id);

  /// Links a DAB user to an external provider identity.
  Future<Either<DatabaseFailure, UserIdentity>> linkIdentity(UserIdentity identity);

  /// Fetches all linked identities for a specific user.
  Future<Either<DatabaseFailure, List<UserIdentity>>> getIdentities(String userId);

  /// Fetches a specific identity for a user and provider.
  Future<Either<DatabaseFailure, UserIdentity?>> getIdentity(String userId, String providerId);

  /// Fetches all identities (for admin overview).
  Future<Either<DatabaseFailure, List<UserIdentity>>> getAllIdentities();
}
