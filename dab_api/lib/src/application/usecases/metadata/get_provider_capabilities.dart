import '../../../application/services/provider_capability_catalog.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Exposes provider live-ingestion capabilities for dashboard strategy.
/// CONTRACT: Returns capability metadata for configured providers.
/// CONSTRAINTS: Must be read-only and configuration-driven.
class GetProviderCapabilities {
  final AbsIProviderConfigRepository _configRepository;
  final ProviderCapabilityCatalog _capabilityCatalog;

  GetProviderCapabilities(this._configRepository, this._capabilityCatalog);

  Future<List<Map<String, dynamic>>> execute() async {
    final configsResult = await _configRepository.getConfigs();
    final configuredIds = configsResult.fold(
      (_) => <String>{},
      (configs) => configs.map((config) => config.id.toLowerCase()).toSet(),
    );
    final activeIds = configsResult.fold(
      (_) => <String>{},
      (configs) => configs
          .where((config) => config.isActive)
          .map((config) => config.id.toLowerCase())
          .toSet(),
    );

    return _capabilityCatalog.all(
      filterProviderIds: configuredIds,
      activeProviderIds: activeIds,
    );
  }
}
