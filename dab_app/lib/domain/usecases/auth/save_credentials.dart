import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../repositories/abs_i_auth_repository.dart';

class SaveCredentials {
  final IAuthRepository _repository;

  SaveCredentials(this._repository);

  Future<Either<AppFailure, Unit>> execute({
    required String email,
    required String password,
  }) {
    return _repository.saveCredentials(email, password);
  }
}
