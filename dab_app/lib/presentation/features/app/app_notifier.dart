import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/containers/metadata_usecases.dart';
import '../../../domain/containers/system_usecases.dart';
import '../../../domain/entities/system/app_settings.dart';
import '../../../domain/entities/system/system_status.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../../views/admin/models/provider_connection_status.dart';
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
  () => AppNotifier(
    sl.systemUseCases,
    sl.metadataUseCases,
    sl.userRepository,
    sl.providerConfigRepository,
  ),
);

class AppNotifier extends Notifier<AppState> {
  AppNotifier(
    this._systemUseCases,
    this._metadataUseCases,
    this._userRepository,
    this._providerRepo,
  );

  final SystemUseCases _systemUseCases;
  final MetadataUseCases _metadataUseCases;
  final IUserRepository _userRepository;
  final IProviderConfigRepository _providerRepo;

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
      deploymentMode: systemStatus.deploymentMode,
      status: ViewStatus.success,
    );
    unawaited(refreshProviderConnectionStatuses());
  }

  /// Updates deployment mode without a full [init] (avoids a global loading flash).
  void setDeploymentMode(String mode) {
    state = state.copyWith(deploymentMode: mode);
  }

  /// Updates org timezone without a full [init].
  void setOrgTimezoneId(String timezoneId) {
    state = state.copyWith(orgTimezoneId: timezoneId);
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

  void setProviderConnectionStatus(
    String providerId,
    ProviderConnectionStatus status,
  ) {
    final statuses = Map<String, ProviderConnectionStatus>.from(
      state.providerConnectionStatuses,
    );
    statuses[providerId] = status;
    state = state.copyWith(providerConnectionStatuses: statuses);
  }

  /// Tests each active provider and stores green/red results for browse filters.
  ///
  /// Connected user credentials are applied first so Dashboard health stays
  /// green during slow org tests. A failed Live webhook probe does not paint
  /// red when Settings → Connect already has a secret for that provider.
  Future<void> refreshProviderConnectionStatuses() async {
    final activeConfigs = state.configs.where((config) => config.isActive);
    if (activeConfigs.isEmpty) {
      state = state.copyWith(providerConnectionStatuses: {});
      return;
    }

    final statuses = Map<String, ProviderConnectionStatus>.from(
      state.providerConnectionStatuses,
    );
    final connectedLabels = await _connectedCredentialLabels();
    final seededAt = DateTime.now();
    var seeded = false;
    for (final entry in connectedLabels.entries) {
      if (statuses[entry.key]?.status == ViewStatus.success) continue;
      statuses[entry.key] = ProviderConnectionStatus(
        status: ViewStatus.success,
        message: entry.value,
        lastCheck: seededAt,
      );
      seeded = true;
    }
    if (seeded) {
      state = state.copyWith(
        providerConnectionStatuses: Map<String, ProviderConnectionStatus>.from(
          statuses,
        ),
      );
    }

    for (final config in activeConfigs) {
      late final ProviderConnectionStatus tested;
      try {
        final result = await _providerRepo
            .testProviderConfig(config)
            .timeout(const Duration(seconds: 12));
        tested = result.fold(
          (failure) => ProviderConnectionStatus(
            status: ViewStatus.failure,
            message: failure.message,
            lastCheck: DateTime.now(),
          ),
          (report) => ProviderConnectionStatus.fromReport(
            report,
            lastCheck: DateTime.now(),
          ),
        );
      } catch (e) {
        tested = ProviderConnectionStatus(
          status: ViewStatus.failure,
          message: e.toString(),
          lastCheck: DateTime.now(),
        );
      }
      statuses[config.id] = tested.preferringConnectedCredential(
        connectedLabels[config.id],
      );
      state = state.copyWith(
        providerConnectionStatuses: Map<String, ProviderConnectionStatus>.from(
          statuses,
        ),
      );
    }
  }

  Future<Map<String, String>> _connectedCredentialLabels() async {
    final result = await _userRepository.listMyCredentials();
    return result.fold((_) => const <String, String>{}, (credentials) {
      final labels = <String, String>{};
      for (final cred in credentials) {
        if (!cred.isConnected) continue;
        labels[cred.providerId] =
            cred.externalUsername ?? cred.externalId ?? cred.providerId;
      }
      return labels;
    });
  }
}
