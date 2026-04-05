import 'package:fpdart/fpdart.dart';
import '../../domain/core/failure.dart';
import '../../domain/entities/provider_metadata.dart';
import '../../domain/repositories/abs_i_provider_metadata_repository.dart';
import '../sources/phorge/phorge_project_source.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Persistence and Retrieval of dynamic provider metadata (Tags, Projects).
/// CONTRACT: Implements [AbsIProviderMetadataRepository].
/// CONSTRAINTS: Currently hardcodes User PHID (Legacy lookup missing). Bridges Sources to Metadata Entities.
class ProviderMetadataRepository implements AbsIProviderMetadataRepository {
  final PhorgeProjectSource _projectSource;

  ProviderMetadataRepository({required PhorgeProjectSource projectSource})
    : _projectSource = projectSource;

  /// Retrieves metadata relevant to the specified user across all providers.
  /// 
  /// Flow:
  /// 1. Uses [PhorgeProjectSource] to fetch active sprint tags.
  /// 2. Maps [PhorgeProject] DTOs to unified [ProviderMetadata] entities.
  @override
  Future<Either<Failure, List<ProviderMetadata>>> getMetadata(
    String userId,
  ) async {
    try {
      // TODO: Resolve real User PHID from AbsIAuthRepository.
      // Currently using a placeholder PHID for the Sprint lookup.
      final phorgeProjects = await _projectSource.fetchActiveSprintProjects(
        'PHID-USER-1234',
      );

      final List<ProviderMetadata> metadata = phorgeProjects.map((p) {
        return ProviderMetadata(
          id: p.phid,
          name: p.name,
          provider: 'Phorge',
          type: 'tag',
          color: p.color,
          icon: p.icon,
        );
      }).toList();

      return right(metadata);
    } catch (e) {
      return left(
        DatabaseFailure('Failed to fetch metadata from providers: $e'),
      );
    }
  }
}
