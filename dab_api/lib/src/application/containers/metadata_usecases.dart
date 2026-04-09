import '../usecases/metadata/get_provider_configs.dart';
import '../usecases/metadata/get_provider_metadata.dart';
import '../usecases/metadata/get_system_status.dart';
import '../usecases/metadata/save_provider_config.dart';

class MetadataUseCases {
  final GetProviderConfigs getProviderConfigs;
  final GetProviderMetadata getProviderMetadata;
  final GetSystemStatus getSystemStatus;
  final SaveProviderConfig saveProviderConfig;

  MetadataUseCases({
    required this.getProviderConfigs,
    required this.getProviderMetadata,
    required this.getSystemStatus,
    required this.saveProviderConfig,
  });
}
