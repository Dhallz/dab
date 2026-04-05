import '../../../domain/entities/user.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves users belonging to a specific group.
/// CONTRACT: Returns a List of [User] entities matching the [groupId].
/// CONSTRAINTS: Implementation relies on the many-to-many group mapping in Infrastructure.
class GetUsersByGroup {
  final IUserRepository _repo;

  GetUsersByGroup(this._repo);

  /// Executes the retrieval of users by group.
  /// 
  /// Throws an [Exception] if the database query fails.
  Future<List<User>> execute(String groupId) async {
    final result = await _repo.getUsersByGroup(groupId);
    return result.getOrElse((f) => throw Exception(f.message));
  }
}
