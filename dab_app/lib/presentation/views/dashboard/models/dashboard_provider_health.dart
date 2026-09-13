import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../../core/models/view_status.dart';
import '../../admin/models/provider_connection_status.dart';

part 'dashboard_provider_health.mapper.dart';

@MappableEnum()
enum DashboardProviderHealthStatus { live, degraded, offline }

@MappableClass()
class DashboardProviderHealth with DashboardProviderHealthMappable {
  final String providerName;
  final DashboardProviderHealthStatus status;
  final DateTime? lastEventAt;

  const DashboardProviderHealth({
    required this.providerName,
    this.status = DashboardProviderHealthStatus.live,
    this.lastEventAt,
  });
}

/// One sidebar row per Admin-activated provider.
///
/// Color follows connection tests / user credentials, not live-feed recency.
/// Quiet providers stay [DashboardProviderHealthStatus.live] until a test fails.
List<DashboardProviderHealth> deriveDashboardProviderHealth({
  required List<ProviderConfig> configs,
  required Map<String, ProviderConnectionStatus> connectionStatuses,
  required List<Activity> activities,
}) {
  final lastEventByProvider = <String, DateTime>{};
  for (final activity in activities) {
    final key = activity.provider.name.toLowerCase();
    final current = lastEventByProvider[key];
    if (current == null || activity.createdAt.isAfter(current)) {
      lastEventByProvider[key] = activity.createdAt;
    }
  }

  final health = [
    for (final config in configs)
      if (config.isActive)
        DashboardProviderHealth(
          providerName: config.name,
          status: _statusFor(connectionStatuses[config.id]),
          lastEventAt:
              lastEventByProvider[config.id.toLowerCase()] ??
              lastEventByProvider[config.name.toLowerCase()],
        ),
  ];
  health.sort((a, b) => a.providerName.compareTo(b.providerName));
  return health;
}

DashboardProviderHealthStatus _statusFor(ProviderConnectionStatus? connection) {
  return switch (connection?.status) {
    ViewStatus.failure => DashboardProviderHealthStatus.offline,
    ViewStatus.warning => DashboardProviderHealthStatus.degraded,
    _ => DashboardProviderHealthStatus.live,
  };
}
