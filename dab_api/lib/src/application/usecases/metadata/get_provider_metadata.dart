import '../../../domain/entities/provider/provider_metadata.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_provider_metadata_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves dynamic platform metadata (Tags, Projects, Columns).
/// CONTRACT: Returns a List of [ProviderMetadata] specific to the [userId].
/// CONSTRAINTS: Omits metadata for providers that are inactive in [ProviderConfig] (deep deactivation).
class GetProviderMetadata {
  final AbsIProviderMetadataRepository _metadataRepo;
  final AbsIProviderConfigRepository _configRepo;

  GetProviderMetadata(this._metadataRepo, this._configRepo);

  /// Executes the metadata retrieval for a specific user.
  Future<List<ProviderMetadata>> execute(String userId) async {
    final result = await _metadataRepo.getMetadata(userId);
    if (result.isLeft()) throw Exception(result.getLeft().toNullable()!.message);
    final all = result.getRight().toNullable()!;

    final configsResult = await _configRepo.getConfigs();
    final activeIds = configsResult.fold(
      (_) => <String>{},
      (configs) => configs
          .where((c) => c.isActive)
          .map((c) => c.id.toLowerCase())
          .toSet(),
    );

    return all
        .where((m) => activeIds.contains(m.provider.toLowerCase()))
        .toList();
  }
}
