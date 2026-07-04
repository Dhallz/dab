import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../entities/provider/provider_config.dart';
import '../entities/provider/provider_connectivity_report.dart';
import '../entities/system/system_status.dart';

abstract interface class IProviderConfigRepository {
  Future<Either<AppFailure, List<ProviderConfig>>> getProviderConfigs();
  Future<Either<AppFailure, void>> saveProviderConfig(ProviderConfig config);

  /// Checks if the system is fully configured (at least one Admin and one Provider).
  Future<Either<AppFailure, SystemStatus>> getSystemStatus();
  Future<Either<AppFailure, ProviderConnectivityReport>> testProviderConfig(
    ProviderConfig config,
  );

  /// Retrieves key-value system settings (e.g. allowed_domain_enabled, allowed_domain).
  Future<Either<AppFailure, Map<String, String>>> getSystemSettings();

  /// Saves key-value system settings.
  Future<Either<AppFailure, void>> saveSystemSettings(Map<String, String> settings);
}
