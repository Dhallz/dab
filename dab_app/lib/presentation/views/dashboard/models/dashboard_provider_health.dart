import 'package:dart_mappable/dart_mappable.dart';

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
