import '../../domain/repositories/abs_i_provider_config_repository.dart';
import '../usecases/metadata/get_provider_configs.dart';
import '../usecases/metadata/get_system_status.dart';

class MetadataUseCases {
  final GetProviderConfigs getProviderConfigs;
  final GetSystemStatus getSystemStatus;

  MetadataUseCases(IProviderConfigRepository repository)
    : getProviderConfigs = GetProviderConfigs(repository),
      getSystemStatus = GetSystemStatus(repository);
}
