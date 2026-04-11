import '../../../domain/entities/provider/provider_metadata.dart';
import '../../../domain/repositories/abs_i_provider_metadata_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves dynamic platform metadata (Tags, Projects, Columns).
/// CONTRACT: Returns a List of [ProviderMetadata] specific to the [userId].
/// CONSTRAINTS: Throws an Exception if the repository operation fails.
class GetProviderMetadata {
  final AbsIProviderMetadataRepository _metadataRepo;

  GetProviderMetadata(this._metadataRepo);

  /// Executes the metadata retrieval for a specific user.
  Future<List<ProviderMetadata>> execute(String userId) async {
    final result = await _metadataRepo.getMetadata(userId);
    if (result.isLeft()) throw Exception(result.getLeft().toNullable()!.message);
    return result.getRight().toNullable()!;
  }
}
