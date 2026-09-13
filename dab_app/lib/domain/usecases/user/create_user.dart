import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Creates a new user account on behalf of an administrator.
/// CONTRACT: The only account creation path after bootstrap. The API enforces
/// the allowed-domain restriction when domain validation is enabled.
class CreateUser {
  final IUserRepository repository;

  CreateUser(this.repository);

  Future<Either<AppFailure, User>> execute({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.standard,
  }) =>
      repository.createUser(
        name: name,
        email: email,
        password: password,
        role: role,
      );
}
