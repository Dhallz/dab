import '../usecases/metadata/get_provider_configs.dart';
import '../usecases/metadata/get_provider_capabilities.dart';
import '../usecases/metadata/get_provider_metadata.dart';
import '../usecases/metadata/get_system_status.dart';
import '../usecases/metadata/save_provider_config.dart';
import '../usecases/metadata/get_system_settings.dart';
import '../usecases/metadata/save_system_settings.dart';

class MetadataUseCases {
  final GetProviderConfigs getProviderConfigs;
  final GetProviderCapabilities getProviderCapabilities;
  final GetProviderMetadata getProviderMetadata;
  final GetSystemStatus getSystemStatus;
  final SaveProviderConfig saveProviderConfig;
  final GetSystemSettings getSystemSettings;
  final SaveSystemSettings saveSystemSettings;

  MetadataUseCases({
    required this.getProviderConfigs,
    required this.getProviderCapabilities,
    required this.getProviderMetadata,
    required this.getSystemStatus,
    required this.saveProviderConfig,
    required this.getSystemSettings,
    required this.saveSystemSettings,
  });
}
