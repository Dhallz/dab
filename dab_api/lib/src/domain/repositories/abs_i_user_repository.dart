import 'package:fpdart/fpdart.dart' hide Group;
import '../core/failure.dart';
import '../entities/group.dart';
import '../entities/user.dart';

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
}
