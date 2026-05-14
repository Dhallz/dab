import 'package:fpdart/fpdart.dart';

import '../core/failures/failure.dart';
import '../entities/provider/provider_metadata.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Abstract contract for User-specific Platform Metadata retrieval.
/// CONTRACT: Provides access to dynamic platform components (e.g., Tags, Projects).
/// CONSTRAINTS: Implementation resides in Infrastructure layer.
abstract interface class AbsIProviderMetadataRepository {
  /// Fetches the metadata available to a specific user on registered platforms.
  Future<Either<Failure, List<ProviderMetadata>>> getMetadata(String userId);
}
