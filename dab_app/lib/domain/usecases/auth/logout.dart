import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../repositories/abs_i_auth_repository.dart';

class Logout {
  final IAuthRepository _repository;

  Logout(this._repository);

  Future<Either<AppFailure, Unit>> execute() {
    return _repository.logout();
  }
}
