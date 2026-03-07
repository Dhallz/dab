import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../entities/provider_config.dart';
import '../../repositories/abs_i_provider_config_repository.dart';

class GetProviderConfigs {
  final IProviderConfigRepository _repository;

  GetProviderConfigs(this._repository);

  Future<Either<AppFailure, List<ProviderConfig>>> execute() {
    return _repository.getProviderConfigs();
  }
}
