import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'provider_connectivity_report.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Connectivity result for one provider config section (Core / Live / Polling).
@MappableClass()
class ProviderSectionResult with ProviderSectionResultMappable {
  final ViewStatus status;
  final String message;

  const ProviderSectionResult({
    required this.status,
    required this.message,
  });
}

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Structured provider connectivity test result from the API.
@MappableClass()
class ProviderConnectivityReport with ProviderConnectivityReportMappable {
  final ViewStatus aggregate;
  final String summaryMessage;
  final ProviderSectionResult core;
  final ProviderSectionResult live;
  final ProviderSectionResult polling;

  const ProviderConnectivityReport({
    required this.aggregate,
    required this.summaryMessage,
    required this.core,
    required this.live,
    required this.polling,
  });
}
