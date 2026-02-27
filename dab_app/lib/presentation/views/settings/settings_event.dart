import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'settings_event.mapper.dart';

@MappableClass()
sealed class SettingsEvent with SettingsEventMappable {
  const SettingsEvent();
}

@MappableClass()
class SettingsStarted extends SettingsEvent with SettingsStartedMappable {
  const SettingsStarted();
}

@MappableClass()
class SettingsThemeModeChanged extends SettingsEvent
    with SettingsThemeModeChangedMappable {
  final ThemeMode mode;
  const SettingsThemeModeChanged(this.mode);
}
