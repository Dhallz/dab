import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../repositories/abs_i_api_origin_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Load the last DAB API origin for the login form.
class GetApiOrigin {
  final IApiOriginRepository _repository;

  GetApiOrigin(this._repository);

  Future<Either<AppFailure, String>> execute() {
    return _repository.getOrigin();
  }
}
