import '../usecases/metadata/get_provider_configs.dart';
import '../usecases/metadata/get_provider_metadata.dart';

class MetadataUseCases {
  final GetProviderConfigs getProviderConfigs;
  final GetProviderMetadata getProviderMetadata;

  MetadataUseCases({
    required this.getProviderConfigs,
    required this.getProviderMetadata,
  });
}
