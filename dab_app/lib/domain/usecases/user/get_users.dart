import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

class GetUsers {
  final IUserRepository repository;

  GetUsers(this.repository);

  Future<Either<AppFailure, List<User>>> execute() => repository.getUsers();
}
