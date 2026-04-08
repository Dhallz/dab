import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../entities/provider_config.dart';

abstract interface class IProviderConfigRepository {
  Future<Either<AppFailure, List<ProviderConfig>>> getProviderConfigs();
  Future<Either<AppFailure, void>> saveProviderConfig(ProviderConfig config);
  /// Checks if the system is fully configured (at least one Admin and one Provider).
  Future<Either<AppFailure, bool>> getSystemStatus();
  Future<Either<AppFailure, String>> testProviderConfig(ProviderConfig config);
}
