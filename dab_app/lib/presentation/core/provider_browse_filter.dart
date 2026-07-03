import '../../domain/entities/provider/provider_config.dart';
import '../views/admin/models/provider_connection_status.dart';
import 'models/view_status.dart';

/// Returns providers that are enabled in Admin and have a successful connection test.
List<ProviderConfig> browsableProviderConfigs(
  List<ProviderConfig> configs,
  Map<String, ProviderConnectionStatus> connectionStatuses,
) {
  return configs
      .where(
        (config) =>
            config.isActive &&
            connectionStatuses[config.id]?.status == ViewStatus.success,
      )
      .toList(growable: false);
}
