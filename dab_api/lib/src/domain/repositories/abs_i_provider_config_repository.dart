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

  /// Counts the total number of active configurations in the database.
  Future<Either<Failure, int>> countActiveConfigs();

  /// Saves or updates a provider configuration.
  Future<Either<Failure, ProviderConfig>> saveConfig(ProviderConfig config);
}
