import 'dart:ui' show Locale;

import 'package:dart_mappable/dart_mappable.dart';

import 'app_theme_variant.dart';

part 'app_settings.mapper.dart';

const String appSettingsIslandBarViewDashboard = 'dashboard';
const String appSettingsIslandBarViewExplorer = 'explorer';
const String appSettingsIslandBarViewInsights = 'insights';

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: Fixed item catalogs for unused persisted `islandBarSelections` (no schema migration).
const Map<String, List<String>> appSettingsIslandBarItemCatalog = {
  appSettingsIslandBarViewDashboard: ['title', 'subtitle'],
  appSettingsIslandBarViewExplorer: [
    'dateControls',
    'quickPreset',
    'dateModeToggle',
    'activitySummary',
    'heatBar',
  ],
  appSettingsIslandBarViewInsights: ['dateRange', 'presets'],
};

/// [ARCH: DOMAIN_ENTITY]
/// ROLE: First-run defaults for unused persisted `islandBarSelections`.
const Map<String, List<String>> appSettingsDefaultIslandBarSelections = {
  appSettingsIslandBarViewDashboard: ['title', 'subtitle'],
  appSettingsIslandBarViewExplorer: [
    'dateControls',
    'quickPreset',
    'dateModeToggle',
    'activitySummary',
    'heatBar',
  ],
  appSettingsIslandBarViewInsights: ['dateRange', 'presets'],
};

@MappableClass()
class AppSettings with AppSettingsMappable {
  final AppThemeVariant appThemeVariant;
  final String? localeCode;
  final Map<String, List<String>> islandBarSelections;
  final String? syncToken;

  const AppSettings({
    this.appThemeVariant = AppThemeVariant.dab,
    this.localeCode,
    this.islandBarSelections = appSettingsDefaultIslandBarSelections,
    this.syncToken,
  });
}

extension OnAppSettings on AppSettings {
  Locale? get resolvedLocale => localeCode == null ? null : Locale(localeCode!);

  bool isIslandBarItemSelected(String viewId, String itemId) {
    final selected =
        islandBarSelections[viewId] ??
        appSettingsDefaultIslandBarSelections[viewId] ??
        const <String>[];
    return selected.contains(itemId);
  }

  Map<String, List<String>> updatedIslandBarSelection(
    String viewId,
    List<String> selectedItems,
  ) {
    final allowedItems = appSettingsIslandBarItemCatalog[viewId] ?? const [];
    final sanitized = selectedItems
        .where(allowedItems.contains)
        .toSet()
        .toList(growable: false);
    return {...islandBarSelections, viewId: sanitized};
  }
}
