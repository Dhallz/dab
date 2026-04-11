import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

import '../../../../domain/entities/system/app_settings.dart';

@Entity()
class AppSettingsRecord {
  @Id()
  int id = 0;
  final String themeMode;
  String? syncToken;

  AppSettingsRecord({this.id = 0, required this.themeMode, this.syncToken});
}

extension OnAppSettingsRecord on AppSettingsRecord {
  AppSettings get toDomain {
    final mode = ThemeMode.values.firstWhere(
      (m) => m.name == themeMode,
      orElse: () => ThemeMode.system,
    );
    return AppSettings(themeMode: mode, syncToken: syncToken);
  }
}
