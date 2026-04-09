import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves all users in the system.
/// CONTRACT: Returns a list of all [User] entities.
/// CONSTRAINTS: Restricted to Admin Console use.
class FindAllUsers {
  final AbsIAuthRepository _repo;

  FindAllUsers(this._repo);

  Future<Either<Failure, List<User>>> execute() async {
    return _repo.findAllUsers();
  }
}
