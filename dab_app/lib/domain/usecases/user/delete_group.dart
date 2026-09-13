import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

class DeleteGroup {
  final IUserRepository repository;

  DeleteGroup(this.repository);

  Future<Either<AppFailure, void>> execute(String id) =>
      repository.deleteGroup(id);
}
