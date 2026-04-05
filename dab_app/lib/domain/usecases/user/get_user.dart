import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

class GetUser {
  final IUserRepository repository;

  GetUser(this.repository);

  Future<Either<AppFailure, User>> execute(String id) => repository.getUser(id);
}
