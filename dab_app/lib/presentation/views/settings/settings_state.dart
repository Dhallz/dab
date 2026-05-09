import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/system/app_settings.dart';

part 'settings_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Settings screen state.
@MappableClass()
class SettingsState with SettingsStateMappable {
  final ViewStatus status;
  final AppSettings persistedSettings;
  final AppSettings draftSettings;
  final bool isDirty;

  const SettingsState({
    this.status = ViewStatus.initial,
    this.persistedSettings = const AppSettings(),
    this.draftSettings = const AppSettings(),
    this.isDirty = false,
  });
}
