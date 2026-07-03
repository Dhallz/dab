import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/containers/metadata_usecases.dart';
import '../../../domain/containers/system_usecases.dart';
import '../../../domain/entities/system/app_settings.dart';
import '../../../domain/entities/system/system_status.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../auth/auth_state.dart' as session;
import 'app_state.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Global application settings and metadata.
/// CONTRACT: Manages [AppState]. Orchestrates initialization and cross-cutting updates (Theme).
/// CONSTRAINTS: Directly interacts with [SystemUseCases] and [MetadataUseCases].
///
/// **Settings screen:** theme updates flow through [setAppSettings]; bootstrap
/// (`SettingsStarted`) is covered by [init].
final appNotifierProvider = NotifierProvider<AppNotifier, AppState>(
  () => AppNotifier(sl.systemUseCases, sl.metadataUseCases, sl.userRepository),
);

class AppNotifier extends Notifier<AppState> {
  AppNotifier(
    this._systemUseCases,
    this._metadataUseCases,
    this._userRepository,
  );

  final SystemUseCases _systemUseCases;
  final MetadataUseCases _metadataUseCases;
  final IUserRepository _userRepository;

  @override
  AppState build() {
    Future.microtask(init);
    return const AppState();
  }

  Future<void> init() async {
    state = state.copyWith(status: ViewStatus.loading);

    final settingsResult = await _systemUseCases.getAppSettings.execute();
    final configsResult = await _metadataUseCases.getProviderConfigs.execute();
    final statusResult = await _metadataUseCases.getSystemStatus.execute();
    final systemStatus = statusResult.getOrElse(
      (failure) => const SystemStatus(isSystemConfigured: true),
    );

    state = state.copyWith(
      settings: settingsResult.getOrElse((failure) => state.settings),
      configs: configsResult.getOrElse((failure) => []),
      isSystemConfigured: systemStatus.isSystemConfigured,
      orgTimezoneId: systemStatus.orgTimezoneId,
      status: ViewStatus.success,
    );
  }

  /// Refreshes admin identity-resolution badge count (no-op on API failure).
  Future<void> refreshIdentityResolutionBadge(
    session.AuthState authState,
  ) async {
    if (authState.user?.role != UserRole.admin) {
      state = state.copyWith(unresolvedIdentityCount: 0);
      return;
    }
    final result = await _userRepository.getIdentityResolutionSummary();
    result.fold(
      (_) => null,
      (count) => state = state.copyWith(unresolvedIdentityCount: count),
    );
  }

  void setAppSettings(AppSettings settings) {
    state = state.copyWith(settings: settings);
  }
}
