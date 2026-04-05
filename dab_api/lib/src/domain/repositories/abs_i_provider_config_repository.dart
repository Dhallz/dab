import 'package:fpdart/fpdart.dart';
import '../core/failure.dart';
import '../entities/provider_config.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Abstract contract for Platform Configuration retrieval.
/// CONTRACT: Provides access to environment-specific platform settings.
/// CONSTRAINTS: Implementation resides in Infrastructure layer (ProviderConfigRepository).
abstract interface class AbsIProviderConfigRepository {
  /// Fetches the static configurations for all supported providers.
  Future<Either<Failure, List<ProviderConfig>>> getConfigs();
}
