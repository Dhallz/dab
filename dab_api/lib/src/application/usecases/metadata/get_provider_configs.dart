import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves the static configuration for all Platform Providers.
/// CONTRACT: Returns a List of [ProviderConfig] entities.
/// CONSTRAINTS: Throws an Exception if the repository operation fails.
class GetProviderConfigs {
  final AbsIProviderConfigRepository _configRepo;

  GetProviderConfigs(this._configRepo);

  /// Executes the configuration retrieval.
  Future<List<ProviderConfig>> execute() async {
    final result = await _configRepo.getConfigs();
    if (result.isLeft()) throw Exception(result.getLeft().toNullable()!.message);
    return result.getRight().toNullable()!;
  }
}
