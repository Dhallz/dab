import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/user/user.dart';
import '../../repositories/abs_i_auth_repository.dart';

class CheckAuthStatus {
  final IAuthRepository _repository;

  CheckAuthStatus(this._repository);

  Future<Either<AppFailure, User>> execute() {
    return _repository.checkAuthStatus();
  }
}
