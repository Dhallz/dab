import 'package:dart_mappable/dart_mappable.dart';

part 'provider_connectivity_report.mapper.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Section-level connectivity status for Admin provider config tests.
/// CONTRACT: Wire values align with client [ViewStatus] (`success`, `failure`, `warning`).
@MappableEnum()
enum ConnectivitySectionStatus {
  success,
  failure,
  warning,
}

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Result for one Core / Live / Polling connectivity section.
@MappableClass()
class ProviderSectionResult with ProviderSectionResultMappable {
  final ConnectivitySectionStatus status;
  final String message;

  const ProviderSectionResult({
    required this.status,
    required this.message,
  });
}

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Structured connectivity report returned by `POST /admin/configs/test`.
/// CONTRACT: [aggregate] is derived from Live + Polling only; Core is independent.
@MappableClass()
class ProviderConnectivityReport with ProviderConnectivityReportMappable {
  final ConnectivitySectionStatus aggregate;
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

  /// Computes aggregate from live and polling section outcomes.
  static ConnectivitySectionStatus computeAggregate({
    required ProviderSectionResult live,
    required ProviderSectionResult polling,
  }) {
    final liveOk = live.status == ConnectivitySectionStatus.success;
    final pollingOk = polling.status == ConnectivitySectionStatus.success;
    if (liveOk && pollingOk) return ConnectivitySectionStatus.success;
    if (liveOk || pollingOk) return ConnectivitySectionStatus.warning;
    return ConnectivitySectionStatus.failure;
  }

  static String summarize({
    required ConnectivitySectionStatus aggregate,
    required ProviderSectionResult live,
    required ProviderSectionResult polling,
  }) {
    return switch (aggregate) {
      ConnectivitySectionStatus.success =>
        'Live and polling verified',
      ConnectivitySectionStatus.warning when live.status ==
          ConnectivitySectionStatus.success =>
        'Live verified; polling needs attention',
      ConnectivitySectionStatus.warning =>
        'Polling verified; live needs attention',
      ConnectivitySectionStatus.failure =>
        'Live and polling need attention',
    };
  }
}
