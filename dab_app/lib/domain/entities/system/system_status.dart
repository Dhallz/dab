import '../../core/deployment_mode.dart';
import '../../core/org_calendar.dart';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Public bootstrap status returned by `GET /metadata/status`.
class SystemStatus {
  final bool isSystemConfigured;
  final String orgTimezoneId;
  final String deploymentMode;

  const SystemStatus({
    required this.isSystemConfigured,
    this.orgTimezoneId = kDefaultOrgTimezoneId,
    this.deploymentMode = kDeploymentModeManaged,
  });

  /// True when teammates connect providers from Settings (Individual mode).
  bool get isIndividualDeployment => deploymentMode.isIndividualDeploymentMode;
}
