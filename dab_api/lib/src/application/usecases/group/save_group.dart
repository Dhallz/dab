import '../../../domain/entities/group.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Persists or updates a Group structure.
/// CONTRACT: Saves the [Group] entity and its membership associations.
/// CONSTRAINTS: Throws an Exception if the database operation fails.
class SaveGroup {
  final IUserRepository _repo;

  SaveGroup(this._repo);

  /// Executes the save operation.
  /// 
  /// Returns the saved [Group] entity (potentially with updated IDs or timestamps).
  Future<Group> execute(Group group) async {
    final result = await _repo.saveGroup(group);
    if (result.isLeft()) throw Exception(result.getLeft().toNullable()!.message);
    return result.getRight().toNullable()!;
  }
}
