import '../../../domain/entities/user.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves the complete user directory.
/// CONTRACT: Returns a List of all registered DAB [User] entities.
/// CONSTRAINTS: Throws on database failure (legacy pattern remaining for now).
class GetUsers {
  final IUserRepository _repo;

  GetUsers(this._repo);

  /// Executes the retrieval operation.
  /// 
  /// Returns all users recorded in the [IUserRepository].
  Future<List<User>> execute() async {
    final result = await _repo.getUsers();
    return result.getOrElse((f) => throw Exception(f.message));
  }
}
