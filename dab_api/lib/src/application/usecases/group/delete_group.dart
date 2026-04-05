import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Removes a Group from the system.
/// CONTRACT: Permanently deletes the [Group] record and its memberships.
/// CONSTRAINTS: Throws an Exception if the deletion operation fails.
class DeleteGroup {
  final IUserRepository _repo;

  DeleteGroup(this._repo);

  /// Executes the deletion of a group by ID.
  Future<void> execute(String id) async {
    final result = await _repo.deleteGroup(id);
    if (result.isLeft()) throw Exception(result.getLeft().toNullable()!.message);
  }
}
