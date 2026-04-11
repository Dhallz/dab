import '../../../domain/entities/group/group.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves all defined groups (Custom and Provider-linked).
/// CONTRACT: Returns a List of [Group] entities.
/// CONSTRAINTS: Throws an Exception if the database query fails.
class GetGroups {
  final IUserRepository _repo;

  GetGroups(this._repo);

  /// Executes the retrieval operation.
  Future<List<Group>> execute() async {
    final result = await _repo.getGroups();
    return result.getOrElse((f) => throw Exception(f.message));
  }
}
