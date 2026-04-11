import 'package:fpdart/fpdart.dart';
import '../../domain/core/failure.dart';
import '../../domain/entities/provider/provider_metadata.dart';
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

      // --- Scaffolded Providers ---
      metadata.addAll([
        ProviderMetadata(id: 'slack-global', name: 'Slack', provider: 'Slack', type: 'message', color: '#4A154B', icon: 'slack'),
        ProviderMetadata(id: 'teams-global', name: 'MS Teams', provider: 'Teams', type: 'message', color: '#6264A7', icon: 'teams'),
        ProviderMetadata(id: 'jira-global', name: 'Jira', provider: 'Jira', type: 'issue', color: '#0052CC', icon: 'jira'),
        ProviderMetadata(id: 'linear-global', name: 'Linear', provider: 'Linear', type: 'issue', color: '#5E6AD2', icon: 'linear'),
        ProviderMetadata(id: 'discord-global', name: 'Discord', provider: 'Discord', type: 'message', color: '#5865F2', icon: 'discord'),
      ]);

      return right(metadata);
    } catch (e) {
      return left(
        DatabaseFailure('Failed to fetch metadata from providers: $e'),
      );
    }
  }
}
