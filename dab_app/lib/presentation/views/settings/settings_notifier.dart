import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/containers/system_usecases.dart';
import '../../../domain/containers/activity_usecases.dart';
import '../../../domain/entities/activity/explorer_cache_clear_request.dart';
import '../../../domain/entities/system/app_settings.dart';
import '../../../domain/core/failures.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/entities/system/app_theme_variant.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_notifier.dart';
import 'settings_state.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Owns settings-screen business logic and draft lifecycle.
final settingsNotifierProvider =
    NotifierProvider.autoDispose<SettingsNotifier, SettingsState>(
      SettingsNotifier.new,
    );

class SettingsNotifier extends AutoDisposeNotifier<SettingsState> {
  bool _initialized = false;

  SystemUseCases get _systemUseCases => sl.systemUseCases;
  ActivityUseCases get _activityUseCases => sl.activityUseCases;

  @override
  SettingsState build() {
    if (!_initialized) {
      _initialized = true;
      Future.microtask(_initFromAppState);
    }
    return const SettingsState();
  }

  Future<void> _initFromAppState() async {
    final appSettings = ref.read(appNotifierProvider).settings;
    state = state.copyWith(
      status: ViewStatus.success,
      persistedSettings: appSettings,
      draftSettings: appSettings,
      isDirty: false,
    );
  }

  void setThemeVariant(AppThemeVariant variant) {
    final next = state.draftSettings.copyWith(appThemeVariant: variant);
    ref.read(appNotifierProvider.notifier).setAppSettings(next);
    state = state.copyWith(draftSettings: next, isDirty: next != state.persistedSettings);
  }

  void setLocaleCode(String? localeCode) {
    final next = state.draftSettings.copyWith(localeCode: localeCode);
    ref.read(appNotifierProvider.notifier).setAppSettings(next);
    state = state.copyWith(draftSettings: next, isDirty: next != state.persistedSettings);
  }

  void setIslandBarItems(String viewId, List<String> selectedItems) {
    final next = state.draftSettings.copyWith(
      islandBarSelections: state.draftSettings.updatedIslandBarSelection(
        viewId,
        selectedItems,
      ),
    );
    state = state.copyWith(draftSettings: next, isDirty: next != state.persistedSettings);
  }

  Future<void> save() async {
    final settingsToSave = state.draftSettings;
    final result = await _systemUseCases.saveAppSettings.execute(settingsToSave);
    result.fold((_) => null, (_) {
      state = state.copyWith(
        persistedSettings: settingsToSave,
        isDirty: false,
      );
      // Keep AppNotifier focused on app-wide data exposure.
      ref.read(appNotifierProvider.notifier).setAppSettings(settingsToSave);
    });
  }

  /// Clears Explorer ObjectBox rows for [providerIds] within the org-calendar
  /// [startDate]–[endDate] window so the next browse refetches from the API.
  Future<Either<AppFailure, ExplorerCacheClearResult>> clearExplorerCache({
    required DateTime startDate,
    required DateTime endDate,
    required Set<String> providerIds,
  }) {
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    return _activityUseCases.clearExplorerCache.execute(
      request: ExplorerCacheClearRequest(
        startDate: startDate,
        endDate: endDate,
        providerIds: providerIds,
        orgTimezoneId: orgTimezoneId,
      ),
    );
  }
}
