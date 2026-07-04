import 'package:dab_app/domain/entities/provider/provider_connectivity_report.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'provider_connection_status.mapper.dart';

@MappableClass()
class ProviderConnectionStatus with ProviderConnectionStatusMappable {
  final ViewStatus status;
  final String? message;
  final DateTime? lastCheck;
  final ProviderSectionResult? core;
  final ProviderSectionResult? live;
  final ProviderSectionResult? polling;

  const ProviderConnectionStatus({
    this.status = ViewStatus.initial,
    this.message,
    this.lastCheck,
    this.core,
    this.live,
    this.polling,
  });

  factory ProviderConnectionStatus.fromReport(
    ProviderConnectivityReport report, {
    DateTime? lastCheck,
  }) {
    return ProviderConnectionStatus(
      status: report.aggregate,
      message: report.summaryMessage,
      lastCheck: lastCheck,
      core: report.core,
      live: report.live,
      polling: report.polling,
    );
  }
}
