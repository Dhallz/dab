import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Saves or updates a platform provider configuration.
/// CONTRACT: Validates the configuration and persists it via the repository.
class SaveProviderConfig {
  final AbsIProviderConfigRepository _repo;

  SaveProviderConfig(this._repo);

  Future<Either<Failure, ProviderConfig>> execute(ProviderConfig config) async {
    // Basic validation could be added here
    if (config.id.isEmpty || config.baseUrl.isEmpty) {
      return const Left(
        ValidationFailure(
          'Invalid provider configuration: ID and Base URL are required',
        ),
      );
    }
    return _repo.saveConfig(config);
  }
}
