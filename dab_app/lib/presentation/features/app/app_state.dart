import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../domain/entities/system/app_settings.dart';
import '../../../../domain/core/org_calendar.dart';
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

  /// `organization` or `personal` from `GET /metadata/status`.
  final String deploymentMode;

  const AppState({
    this.status = ViewStatus.initial,
    this.settings = const AppSettings(),
    this.configs = const [],
    this.isSystemConfigured = false,
    this.orgTimezoneId = kDefaultOrgTimezoneId,
    this.unresolvedIdentityCount = 0,
    this.providerConnectionStatuses = const {},
    this.deploymentMode = 'organization',
  });

  bool get isPersonalDeployment => deploymentMode == 'personal';
}
