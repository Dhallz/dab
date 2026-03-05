import '../domain/entities/provider_metadata.dart';
import '../domain/repositories/abs_i_provider_metadata_repository.dart';

class MetadataService {
  final AbsIProviderMetadataRepository _repo;

  MetadataService({required AbsIProviderMetadataRepository repo})
    : _repo = repo;

  Future<List<ProviderMetadata>> getMetadata(String userId) async {
    final result = await _repo.getMetadata(userId);
    return result.match(
      (f) => throw Exception(f.message),
      (metadata) => metadata,
    );
  }
}
