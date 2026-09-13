import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../repositories/abs_i_api_origin_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Point the client at a DAB API before login or register.
class SetApiOrigin {
  final IApiOriginRepository _repository;

  SetApiOrigin(this._repository);

  Future<Either<AppFailure, String>> execute(String raw) {
    return _repository.setOrigin(raw);
  }
}
