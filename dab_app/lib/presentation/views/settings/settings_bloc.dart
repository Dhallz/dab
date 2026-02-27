import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/abs_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends AbsBloc<SettingsEvent, SettingsState> {
  SettingsBloc()
    : super(
        SettingsState(
          settings: AbsBloc.appCubit.state.settings,
          isLoading: AbsBloc.appCubit.state.isLoading,
        ),
      ) {
    on<SettingsStarted>(_onStarted);
    on<SettingsThemeModeChanged>(_onThemeModeChanged);
  }

  /// Starts the synchronization with the global AppCubit stream.
  void _onStarted(SettingsStarted event, Emitter<SettingsState> emit) async {
    await emit.onEach(
      app.stream,
      onData: (appState) {
        emit(
          state.copyWith(
            settings: appState.settings,
            isLoading: appState.isLoading,
          ),
        );
      },
    );
  }

  void _onThemeModeChanged(
    SettingsThemeModeChanged event,
    Emitter<SettingsState> emit,
  ) {
    app.updateThemeMode(event.mode);
  }
}
