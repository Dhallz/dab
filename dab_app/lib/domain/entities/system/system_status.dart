import '../../core/deployment_mode.dart';
import '../../core/daily_report_lock_policy.dart';
import '../../core/org_calendar.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Public bootstrap status returned by `GET /metadata/status`.
class SystemStatus {
  final bool isSystemConfigured;
  final String orgTimezoneId;
  final String deploymentMode;
  final int dailyReportLockOffsetDays;
  final String dailyReportLockTime;

  const SystemStatus({
    required this.isSystemConfigured,
    this.orgTimezoneId = kDefaultOrgTimezoneId,
    this.deploymentMode = kDeploymentModeManaged,
    this.dailyReportLockOffsetDays = kDefaultDailyReportLockOffsetDays,
    this.dailyReportLockTime = kDefaultDailyReportLockTime,
  });

  /// True when teammates connect providers from Settings (Individual mode).
  bool get isIndividualDeployment => deploymentMode.isIndividualDeploymentMode;

  /// Admin-configured cutoff for editing a daily report.
  DailyReportLockPolicy get dailyReportLockPolicy => DailyReportLockPolicy(
    offsetDays: dailyReportLockOffsetDays,
    time: dailyReportLockTime,
  );
}
