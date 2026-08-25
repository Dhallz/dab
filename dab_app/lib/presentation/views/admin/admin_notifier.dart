import 'dart:async';

import 'package:flutter/material.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/core/daily_report_lock_policy.dart';
import '../../../../domain/core/deployment_mode.dart';
import '../../../../domain/core/org_calendar.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../domain/entities/provider/provider_connectivity_report.dart';
import '../../../../domain/entities/system/app_settings.dart';
import '../../../../domain/entities/user/user_identity_status.dart';
import '../../../../domain/entities/user/user_role.dart';
import '../../../../domain/repositories/abs_i_activity_repository.dart';
import '../../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../../domain/repositories/abs_i_user_repository.dart';
import '../../../../services/service_locator.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_notifier.dart';
import 'admin_state.dart';
import 'models/admin_section.dart';
import 'models/personal_provider_readiness.dart';
import 'models/provider_connection_status.dart';

/// **Former `AdminEvent` types → methods:** `AdminStarted` → [start];
/// `AdminConfigUpdated` → [saveProviderConfig]; `AdminProviderToggled` → [toggleProvider];
/// `AdminSectionChanged` → [setSection]; `AdminUserRoleUpdated` → [updateUserRole];
/// `AdminIdentityLinked` → [linkIdentity]; `AdminIdentityResolved` → [resolveIdentity];
/// `AdminIdentitySortChanged` → [setIdentitySort]; `AdminIdentitySearchChanged`
/// → [setIdentitySearchQuery]; `AdminTestConnection` → [testConnection];
/// `AdminRefreshProviderStatuses` → [refreshProviderStatuses].
final adminNotifierProvider =
    NotifierProvider.autoDispose<AdminNotifier, AdminState>(
      () => AdminNotifier(
        providerRepo: sl.providerConfigRepository,
        userRepo: sl.userRepository,
        activityRepo: sl.activityRepository,
      ),
    );

/// [ARCH: PRESENTATION]
/// ROLE: Admin Console — provider configs and identity resolution.
class AdminNotifier extends AutoDisposeNotifier<AdminState> {
  AdminNotifier({
    required IProviderConfigRepository providerRepo,
    required IUserRepository userRepo,
    required IActivityRepository activityRepo,
  }) : _providerRepo = providerRepo,
       _userRepo = userRepo,
       _activityRepo = activityRepo;

  final IProviderConfigRepository _providerRepo;
  final IUserRepository _userRepo;
  final IActivityRepository _activityRepo;

  @override
  AdminState build() {
    final isIndividual = ref.read(appNotifierProvider).isIndividualDeployment;
    return AdminState(
      selectedSection: isIndividual
          ? AdminSection.security
          : AdminSection.providers,
    );
  }

  Future<void> start() async {
    state = state.copyWith(status: ViewStatus.loading, errorMessage: null);

    final isIndividual = ref.read(appNotifierProvider).isIndividualDeployment;
    final configsResult = await _providerRepo.getProviderConfigs();
    final usersResult = await _userRepo.getUsers();
    final settingsResult = await _providerRepo.getSystemSettings();

    final errors = <String>[];
    var identities = state.identities;
    if (isIndividual) {
      identities = const [];
    } else {
      final identitiesResult = await _userRepo.getIdentities();
      identities = identitiesResult.getOrElse((failure) {
        errors.add(failure.message);
        return state.identities;
      });
    }
    state = state.copyWith(
      configs: configsResult.getOrElse((failure) {
        errors.add(failure.message);
        return state.configs;
      }),
      identities: identities,
      users: usersResult.getOrElse((failure) {
        errors.add(failure.message);
        return state.users;
      }),
      systemSettings: settingsResult.getOrElse((failure) {
        errors.add(failure.message);
        return state.systemSettings;
      }),
      status: ViewStatus.success,
      errorMessage: errors.isEmpty ? null : errors.join('\n'),
    );
    unawaited(refreshProviderStatuses());
  }

  Future<void> testConnection(ProviderConfig config) async {
    final providerId = config.id;
    _updateStatus(providerId, ViewStatus.loading);

    try {
      final result = await _providerRepo
          .testProviderConfig(config)
          .timeout(const Duration(seconds: 15));

      result.fold(
        (failure) => _updateStatus(
          providerId,
          ViewStatus.failure,
          message: failure.message,
        ),
        (report) => _updateStatus(
          providerId,
          report.aggregate,
          message: report.summaryMessage,
          report: report,
        ),
      );
    } catch (e) {
      _updateStatus(
        providerId,
        ViewStatus.failure,
        message: e is TimeoutException
            ? lookupAppLocalizations(
                ref.read(appNotifierProvider).settings.resolvedLocale ??
                    const Locale('en'),
              ).adminConnectionTimedOut
            : e.toString(),
      );
    }
  }

  void _updateStatus(
    String providerId,
    ViewStatus status, {
    String? message,
    ProviderConnectivityReport? report,
  }) {
    final connectionStatus = report != null
        ? ProviderConnectionStatus.fromReport(report, lastCheck: DateTime.now())
        : ProviderConnectionStatus(
            status: status,
            message: message,
            lastCheck: DateTime.now(),
          );
    final updatedStatuses = Map<String, ProviderConnectionStatus>.from(
      state.connectionStatuses,
    );
    updatedStatuses[providerId] = connectionStatus;
    state = state.copyWith(connectionStatuses: updatedStatuses);
    ref
        .read(appNotifierProvider.notifier)
        .setProviderConnectionStatus(providerId, connectionStatus);
  }

  void _applyPersonalReadiness(ProviderConfig config) {
    if (!config.isActive) {
      final updated = Map<String, ProviderConnectionStatus>.from(
        state.connectionStatuses,
      )..remove(config.id);
      state = state.copyWith(connectionStatuses: updated);
      return;
    }
    final ready = personalProviderReadiness(config);
    _updateStatus(config.id, ready.status, message: ready.message);
  }

  Future<void> setSection(AdminSection section) async {
    final isIndividual = ref.read(appNotifierProvider).isIndividualDeployment;
    final next = (isIndividual && section == AdminSection.identities)
        ? AdminSection.security
        : section;
    state = state.copyWith(selectedSection: next);
    if (next == AdminSection.providers) {
      await refreshProviderStatuses();
    }
  }

  /// Creates a new user account (admin-only path). Returns true on success
  /// so dialogs can close; failures are surfaced via [AdminState.errorMessage].
  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    UserRole role = UserRole.standard,
  }) async {
    final result = await _userRepo.createUser(
      name: name,
      email: email,
      password: password,
      role: role,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(
          users: [...state.users, user],
          errorMessage: null,
        );
        return true;
      },
    );
  }

  Future<void> updateUserRole(String userId, UserRole role) async {
    final result = await _userRepo.updateUserRole(userId: userId, role: role);

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) {
        final newUsers = state.users.map((u) {
          if (u.id == userId) {
            return u.copyWith(role: role);
          }
          return u;
        }).toList();
        state = state.copyWith(users: newUsers, errorMessage: null);
      },
    );
  }

  Future<void> saveProviderConfig(ProviderConfig config) async {
    final result = await _providerRepo.saveProviderConfig(config);
    await result.fold(
      (failure) async {
        state = state.copyWith(errorMessage: failure.message);
      },
      (_) async {
        final newConfigs = state.configs
            .map((c) => c.id == config.id ? config : c)
            .toList();
        state = state.copyWith(configs: newConfigs, errorMessage: null);
        if (ref.read(appNotifierProvider).isIndividualDeployment) {
          _applyPersonalReadiness(config);
        }
        await ref.read(appNotifierProvider.notifier).init();
      },
    );
  }

  Future<bool> saveSystemSettings(Map<String, String> settings) async {
    final previousTimezone = state.systemSettings[kSystemTimezoneSettingKey];
    final nextTimezone = settings[kSystemTimezoneSettingKey];
    final timezoneChanged =
        nextTimezone != null && previousTimezone != nextTimezone;

    final result = await _providerRepo.saveSystemSettings(settings);
    return result.fold(
      (failure) {
        state = state.copyWith(errorMessage: failure.message);
        return false;
      },
      (_) {
        if (timezoneChanged) {
          unawaited(_activityRepo.clearExplorerCache());
        }
        state = state.copyWith(systemSettings: settings, errorMessage: null);
        final app = ref.read(appNotifierProvider.notifier);
        final mode = settings[kDeploymentModeSettingKey];
        if (mode != null) {
          app.setDeploymentMode(mode);
          if (mode.isIndividualDeploymentMode &&
              state.selectedSection == AdminSection.identities) {
            state = state.copyWith(selectedSection: AdminSection.security);
          }
        }
        if (timezoneChanged) {
          app.setOrgTimezoneId(nextTimezone);
        }
        final lockOffset = settings[kDailyReportLockOffsetDaysKey];
        final lockTime = settings[kDailyReportLockTimeKey];
        if (lockOffset != null || lockTime != null) {
          app.setDailyReportLockPolicy(
            DailyReportLockPolicy.fromSettings(
              offsetDays: lockOffset,
              time: lockTime,
            ),
          );
        }
        return true;
      },
    );
  }

  Future<void> toggleProvider(String id, bool isActive) async {
    final config = state.configs.firstWhere((c) => c.id == id);
    final updatedConfig = config.copyWith(isActive: isActive);
    await saveProviderConfig(updatedConfig);
  }

  Future<void> linkIdentity({
    required String userId,
    required String providerId,
    required String externalId,
    required String externalUsername,
  }) async {
    state = state.copyWith(status: ViewStatus.loading);

    final result = await _userRepo.linkIdentity(
      userId: userId,
      providerId: providerId,
      externalId: externalId,
      externalUsername: externalUsername,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (newIdentity) {
        var replaced = false;
        final newIdentities = state.identities.map((i) {
          if (i.providerId == providerId && i.externalId == externalId) {
            replaced = true;
            return newIdentity;
          }
          return i;
        }).toList();
        if (!replaced) {
          newIdentities.add(newIdentity);
        }

        state = state.copyWith(
          status: ViewStatus.success,
          identities: newIdentities,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> resolveIdentity({
    required String userId,
    required String providerId,
    required UserIdentityStatus status,
  }) async {
    state = state.copyWith(status: ViewStatus.loading);

    final result = await _userRepo.resolveIdentity(
      userId: userId,
      providerId: providerId,
      status: status,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (updatedIdentity) {
        final newIdentities = state.identities.map((i) {
          if (i.id == updatedIdentity.id) {
            return updatedIdentity;
          }
          return i;
        }).toList();

        state = state.copyWith(
          status: ViewStatus.success,
          identities: newIdentities,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> deleteIdentity({required String identityId}) async {
    state = state.copyWith(status: ViewStatus.loading);

    final result = await _userRepo.deleteIdentity(identityId: identityId);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (_) {
        final newIdentities = state.identities
            .where((i) => i.id != identityId)
            .toList();

        state = state.copyWith(
          status: ViewStatus.success,
          identities: newIdentities,
          errorMessage: null,
        );
      },
    );
  }

  void setIdentitySort(IdentitySortField sortField, bool ascending) {
    state = state.copyWith(
      identitySortField: sortField,
      identitySortAscending: ascending,
    );
  }

  void setIdentitySearchQuery(String query) {
    state = state.copyWith(identitySearchQuery: query);
  }

  Future<void> refreshProviderStatuses() async {
    final activeConfigs = state.configs.where((c) => c.isActive).toList();
    if (activeConfigs.isEmpty) {
      return;
    }

    if (ref.read(appNotifierProvider).isIndividualDeployment) {
      for (final config in activeConfigs) {
        _applyPersonalReadiness(config);
      }
      return;
    }

    for (final config in activeConfigs) {
      _updateStatus(config.id, ViewStatus.loading);
    }

    for (final config in activeConfigs) {
      try {
        final result = await _providerRepo
            .testProviderConfig(config)
            .timeout(const Duration(seconds: 12));
        result.fold(
          (failure) => _updateStatus(
            config.id,
            ViewStatus.failure,
            message: failure.message,
          ),
          (report) => _updateStatus(
            config.id,
            report.aggregate,
            message: report.summaryMessage,
            report: report,
          ),
        );
      } catch (e) {
        _updateStatus(
          config.id,
          ViewStatus.failure,
          message: e is TimeoutException
              ? 'Connection timed out'
              : e.toString(),
        );
      }
    }
  }
}
