import '../../../domain/entities/user/user.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Fetches a single User entity by its internal identifier.
/// CONTRACT: Returns a [User] matching the provided [id].
/// CONSTRAINTS: Throws an Exception if the user is not found or DB fails.
class GetUserById {
  final IUserRepository _repo;

  GetUserById(this._repo);

  /// Executes the lookup operation.
  Future<User> execute(String id) async {
    final result = await _repo.getUser(id);
    return result.getOrElse((f) => throw Exception(f.message));
  }
}
