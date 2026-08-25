import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/core/daily_report_lock_policy.dart';
import '../../../../domain/core/deployment_mode.dart';
import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../domain/entities/system/app_settings.dart';
import '../../views/admin/models/provider_connection_status.dart';

part 'app_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Global App state.
@MappableClass()
class AppState with AppStateMappable {
  final ViewStatus status;
  final AppSettings settings;
  final List<ProviderConfig> configs;
  final bool isSystemConfigured;

  /// IANA organization timezone for calendar-day boundaries (from bootstrap).
  final String orgTimezoneId;

  /// Pending + failed identity rows (admin shell badge). Non-admins: keep 0.
  final int unresolvedIdentityCount;

  /// Last-known Admin connection-test results keyed by provider id.
  final Map<String, ProviderConnectionStatus> providerConnectionStatuses;

  /// `managed` or `individual` from `GET /metadata/status`.
  final String deploymentMode;

  /// Days after the report date when the Admin deadline applies.
  final int dailyReportLockOffsetDays;

  /// Wall-clock `HH:mm` of the Admin daily-report deadline (org timezone).
  final String dailyReportLockTime;

  const AppState({
    this.status = ViewStatus.initial,
    this.settings = const AppSettings(),
    this.configs = const [],
    this.isSystemConfigured = false,
    this.orgTimezoneId = kDefaultOrgTimezoneId,
    this.unresolvedIdentityCount = 0,
    this.providerConnectionStatuses = const {},
    this.deploymentMode = kDeploymentModeManaged,
    this.dailyReportLockOffsetDays = kDefaultDailyReportLockOffsetDays,
    this.dailyReportLockTime = kDefaultDailyReportLockTime,
  });

  /// True when teammates connect providers from Settings (Individual mode).
  bool get isIndividualDeployment => deploymentMode.isIndividualDeploymentMode;
}

/// Admin-configured cutoff for editing a daily report.
extension OnAppState on AppState {
  DailyReportLockPolicy get dailyReportLockPolicy => DailyReportLockPolicy(
    offsetDays: dailyReportLockOffsetDays,
    time: dailyReportLockTime,
  );
}
