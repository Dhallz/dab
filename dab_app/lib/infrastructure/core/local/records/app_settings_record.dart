import 'package:dab_app/domain/entities/system/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AppSettingsRecord {
  @Id()
  int id = 0;
  final String themeMode;

  AppSettingsRecord({this.id = 0, required this.themeMode});
}

extension OnAppSettingsRecord on AppSettingsRecord {
  AppSettings get toDomain {
    final mode = ThemeMode.values.firstWhere(
      (m) => m.name == themeMode,
      orElse: () => ThemeMode.system,
    );
    return AppSettings(themeMode: mode);
  }
}
