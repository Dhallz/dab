import '../../domain/entities/provider/provider_config.dart';
import '../views/admin/models/provider_connection_status.dart';

/// Returns Admin-activated providers for Explorer/Insights sidebars.
///
/// Connection tests are Admin health lights, not a browse gate. Live webhook
/// probes often return warning (Figma without Professional, unsigned GitHub)
/// while polling still works. Hiding those emptied the sidebar on first load.
List<ProviderConfig> browsableProviderConfigs(
  List<ProviderConfig> configs,
  Map<String, ProviderConnectionStatus> connectionStatuses,
) {
  return [
    for (final config in configs)
      if (config.isActive) config,
  ];
}
