import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/system/app_settings.dart';

part 'settings_state.mapper.dart';

@MappableClass()
class SettingsState with SettingsStateMappable {
  final AppSettings settings;
  final bool isLoading;

  const SettingsState({
    this.settings = const AppSettings(),
    this.isLoading = false,
  });
}
