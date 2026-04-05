import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures.dart';
import '../../../domain/entities/group.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

class SaveGroup {
  final IUserRepository repository;

  SaveGroup(this.repository);

  Future<Either<AppFailure, Group>> execute(Group group) =>
      repository.saveGroup(group);
}
