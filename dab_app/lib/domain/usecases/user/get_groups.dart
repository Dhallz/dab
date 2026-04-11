import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures.dart';
import '../../../domain/entities/group/group.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

class GetGroups {
  final IUserRepository repository;

  GetGroups(this.repository);

  Future<Either<AppFailure, List<Group>>> execute() => repository.getGroups();
}
