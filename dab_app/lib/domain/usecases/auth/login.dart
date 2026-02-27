import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/auth_response.dart';
import '../../repositories/abs_i_auth_repository.dart';

class Login {
  final IAuthRepository _repository;

  Login(this._repository);

  Future<Either<AppFailure, AuthResponse>> execute({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
