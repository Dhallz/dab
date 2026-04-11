import 'package:flutter/material.dart';
import '../../../domain/containers/metadata_usecases.dart';
import '../../../domain/containers/system_usecases.dart';
import '../../core/abs_cubit.dart';
import '../../core/models/view_status.dart';
import 'app_state.dart';

/// [ARCH: PRESENTATION_BLOC]
/// ROLE: Global State Manager for Application-wide settings and metadata.
/// CONTRACT: Manages [AppState]. Orchestrates initialization and cross-cutting updates (Theme).
/// CONSTRAINTS: Directly interacts with [SystemUseCases] and [MetadataUseCases].
class AppCubit extends AbsCubit<AppState> {
  final SystemUseCases _systemUseCases;
  final MetadataUseCases _metadataUseCases;

  AppCubit(this._systemUseCases, this._metadataUseCases)
    : super(const AppState());

  Future<void> init() async {
    emit(state.copyWith(status: ViewStatus.loading));

    // Fetch settings
    final settingsResult = await _systemUseCases.getAppSettings.execute();

    // Fetch configs
    final configsResult = await _metadataUseCases.getProviderConfigs.execute();

    // Fetch system status (DAB-40 Bootstrap Lock)
    final statusResult = await _metadataUseCases.getSystemStatus.execute();

    emit(
      state.copyWith(
        settings: settingsResult.getOrElse((failure) => state.settings),
        configs: configsResult.getOrElse((failure) => []),
        isSystemConfigured: statusResult.getOrElse((failure) => true),
        status: ViewStatus.success,
      ),
    );
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final newSettings = state.settings.copyWith(themeMode: mode);

    // Optimistic update
    emit(state.copyWith(settings: newSettings));

    final result = await _systemUseCases.saveAppSettings.execute(newSettings);

    // If saving fails, we could revert the UI or show an error
    result.fold(
      (failure) => null, // Handle error if necessary
      (_) => null,
    );
  }
}
