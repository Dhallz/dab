import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../repositories/abs_i_auth_repository.dart';

class GetSavedCredentials {
  final IAuthRepository _repository;

  GetSavedCredentials(this._repository);

  Future<Either<AppFailure, Map<String, String>?>> execute() {
    return _repository.getSavedCredentials();
  }
}
