import '../repositories/abs_i_provider_config_repository.dart';
import '../usecases/metadata/get_provider_configs.dart';

class MetadataUseCases {
  final GetProviderConfigs getProviderConfigs;

  MetadataUseCases(IProviderConfigRepository repository)
    : getProviderConfigs = GetProviderConfigs(repository);
}
