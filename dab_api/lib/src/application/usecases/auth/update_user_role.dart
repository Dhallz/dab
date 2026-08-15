import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/contracts/repositories/abs_i_auth_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Updates a user's role in the system.
/// CONTRACT: Modifies the [role] attribute for the specified [userId].
/// CONSTRAINTS: Restricted to Admin Console use.
class UpdateUserRole {
  final AbsIAuthRepository _repo;

  UpdateUserRole(this._repo);

  Future<Either<Failure, void>> execute(String userId, UserRole role) async {
    return _repo.updateUserRole(userId, role);
  }
}
