import '../domain/entities/provider_config.dart';
import '../domain/entities/provider_metadata.dart';
import '../domain/repositories/abs_i_provider_config_repository.dart';
import '../domain/repositories/abs_i_provider_metadata_repository.dart';

class MetadataService {
  final AbsIProviderMetadataRepository _metadataRepo;
  final AbsIProviderConfigRepository _configRepo;

  MetadataService({
    required AbsIProviderMetadataRepository repo,
    required AbsIProviderConfigRepository configRepo,
  }) : _metadataRepo = repo,
       _configRepo = configRepo;

  Future<List<ProviderMetadata>> getMetadata(String userId) async {
    final result = await _metadataRepo.getMetadata(userId);
    return result.match(
      (f) => throw Exception(f.message),
      (metadata) => metadata,
    );
  }

  Future<List<ProviderConfig>> getConfigs() async {
    final result = await _configRepo.getConfigs();
    return result.match(
      (f) => throw Exception(f.message),
      (configs) => configs,
    );
  }
}
