import 'package:dab_app/domain/entities/system/app_settings.dart';
import 'package:dab_app/domain/entities/system/app_theme_variant.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettings', () {
    test('defaults theme variant to DAB', () {
      const settings = AppSettings();
      expect(settings.appThemeVariant, AppThemeVariant.dab);
    });

    test('defaults inbox notifications to on', () {
      const settings = AppSettings();
      expect(settings.inboxNotificationsEnabled, isTrue);
    });

    test('defaults island selections to current island bar catalog', () {
      const settings = AppSettings();

      expect(
        settings.islandBarSelections[appSettingsIslandBarViewDashboard],
        appSettingsDefaultIslandBarSelections[appSettingsIslandBarViewDashboard],
      );
      expect(
        settings.islandBarSelections[appSettingsIslandBarViewExplorer],
        appSettingsDefaultIslandBarSelections[appSettingsIslandBarViewExplorer],
      );
      expect(
        settings.islandBarSelections[appSettingsIslandBarViewInsights],
        appSettingsDefaultIslandBarSelections[appSettingsIslandBarViewInsights],
      );
    });

    test('updatedIslandBarSelection keeps only allowed item ids', () {
      const settings = AppSettings();

      final updated = settings.updatedIslandBarSelection(
        appSettingsIslandBarViewDashboard,
        ['subtitle', 'invalid-item'],
      );

      expect(
        updated[appSettingsIslandBarViewDashboard],
        equals(const ['subtitle']),
      );
    });
  });
}
