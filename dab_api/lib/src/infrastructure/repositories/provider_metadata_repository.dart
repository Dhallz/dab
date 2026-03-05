import 'package:fpdart/fpdart.dart';

import '../../domain/core/failure.dart';
import '../../domain/entities/provider_metadata.dart';
import '../../domain/repositories/abs_i_provider_metadata_repository.dart';
import '../connectors/phorge/phorge_connector.dart';

class ProviderMetadataRepository implements AbsIProviderMetadataRepository {
  final PhorgeConnector _phorgeConnector;

  ProviderMetadataRepository({required PhorgeConnector phorgeConnector})
    : _phorgeConnector = phorgeConnector;

  @override
  Future<Either<Failure, List<ProviderMetadata>>> getMetadata(
    String userId,
  ) async {
    try {
      // For now, hardcode userPhid since we don't have user object mapped.
      // In reality, this would lookup User from UserId.
      final phorgeProjects = await _phorgeConnector.fetchAllProjects(
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
