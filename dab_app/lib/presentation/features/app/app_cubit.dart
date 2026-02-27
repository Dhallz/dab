import 'package:flutter/material.dart';
import '../../../domain/containers/system_usecases.dart';
import '../../core/abs_cubit.dart';
import 'app_state.dart';

class AppCubit extends AbsCubit<AppState> {
  final SystemUseCases _useCases;

  AppCubit(this._useCases) : super(const AppState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));
    final result = await _useCases.getAppSettings.execute();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false)),
      (settings) => emit(state.copyWith(settings: settings, isLoading: false)),
    );
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    final newSettings = state.settings.copyWith(themeMode: mode);

    // Optimistic update
    emit(state.copyWith(settings: newSettings));

    final result = await _useCases.saveAppSettings.execute(newSettings);

    // If saving fails, we could revert the UI or show an error
    result.fold(
      (failure) => null, // Handle error if necessary
      (_) => null,
    );
  }
}
