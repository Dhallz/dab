import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves the static configuration for all Platform Providers.
/// CONTRACT: Returns [ProviderConfig] list or [Failure].
class GetProviderConfigs {
  final AbsIProviderConfigRepository _configRepo;

  GetProviderConfigs(this._configRepo);

  Future<Either<Failure, List<ProviderConfig>>> execute() async {
    return _configRepo.getConfigs();
  }
}
