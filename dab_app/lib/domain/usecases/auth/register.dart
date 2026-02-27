import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/auth_response.dart';
import '../../repositories/abs_i_auth_repository.dart';

class Register {
  final IAuthRepository _repository;

  Register(this._repository);

  Future<Either<AppFailure, AuthResponse>> execute({
    required String email,
    required String password,
    required String name,
  }) {
    return _repository.register(email: email, password: password, name: name);
  }
}
