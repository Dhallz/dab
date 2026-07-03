import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../domain/entities/system/app_settings.dart';
import '../../../../domain/core/org_calendar.dart';

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

  const AppState({
    this.status = ViewStatus.initial,
    this.settings = const AppSettings(),
    this.configs = const [],
    this.isSystemConfigured = false,
    this.orgTimezoneId = kDefaultOrgTimezoneId,
    this.unresolvedIdentityCount = 0,
  });
}
