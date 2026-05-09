import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import '../../../../domain/entities/system/app_settings.dart';
import '../../../../domain/entities/system/app_theme_variant.dart';

@Entity()
class AppSettingsRecord {
  @Id()
  int id = 0;
  final String themeMode;
  String? localeCode;
  String islandBarSelectionsJson;
  String? syncToken;

  AppSettingsRecord({
    this.id = 0,
    required this.themeMode,
    this.localeCode,
    this.islandBarSelectionsJson = '{}',
    this.syncToken,
  });
}

extension OnAppSettingsRecord on AppSettingsRecord {
  AppSettings get toDomain {
    return AppSettings(
      appThemeVariant: _parseStoredTheme(themeMode),
      localeCode: localeCode,
      islandBarSelections: _decodeSelectionsMap(islandBarSelectionsJson),
      syncToken: syncToken,
    );
  }
}

/// Maps ObjectBox `themeMode` string to [AppThemeVariant].
///
/// Legacy values came from [ThemeMode]: `dark` was the only dark theme (DAB).
/// New values: `light`, `dab`, `greyscale`.
AppThemeVariant _parseStoredTheme(String raw) {
  switch (raw) {
    case 'light':
      return AppThemeVariant.light;
    case 'dab':
      return AppThemeVariant.dab;
    case 'greyscale':
      return AppThemeVariant.greyscale;
    // Legacy ThemeMode.dark → branded DAB dark (not neutral dark).
    case 'dark':
      return AppThemeVariant.dab;
    case 'system':
    default:
      return AppThemeVariant.dab;
  }
}

Map<String, List<String>> _decodeSelectionsMap(String rawJson) {
  try {
    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      return appSettingsDefaultIslandBarSelections;
    }
    final merged = <String, List<String>>{
      ...appSettingsDefaultIslandBarSelections,
    };
    decoded.forEach((view, value) {
      if (value is List) {
        merged[view] = value.whereType<String>().toList(growable: false);
      }
    });
    return merged;
  } catch (_) {
    return appSettingsDefaultIslandBarSelections;
  }
}
