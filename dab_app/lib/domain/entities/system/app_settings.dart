import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/material.dart';

part 'app_settings.mapper.dart';

@MappableClass()
class AppSettings with AppSettingsMappable {
  final ThemeMode themeMode;
  final String? syncToken;

  const AppSettings({this.themeMode = ThemeMode.system, this.syncToken});
}
