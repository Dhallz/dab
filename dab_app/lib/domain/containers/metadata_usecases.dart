import '../../domain/repositories/abs_i_provider_config_repository.dart';
import '../usecases/metadata/get_provider_configs.dart';
import '../usecases/metadata/get_system_status.dart';
import '../usecases/metadata/get_system_settings.dart';
import '../usecases/metadata/save_system_settings.dart';

class MetadataUseCases {
  final GetProviderConfigs getProviderConfigs;
  final GetSystemStatus getSystemStatus;
  final GetSystemSettings getSystemSettings;
  final SaveSystemSettings saveSystemSettings;

  MetadataUseCases(IProviderConfigRepository repository)
    : getProviderConfigs = GetProviderConfigs(repository),
      getSystemStatus = GetSystemStatus(repository),
      getSystemSettings = GetSystemSettings(repository),
      saveSystemSettings = SaveSystemSettings(repository);
}
