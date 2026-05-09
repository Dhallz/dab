import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../domain/entities/user/user_identity_status.dart';
import '../../../../domain/entities/user/user_role.dart';
import '../../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../../domain/repositories/abs_i_user_repository.dart';
import '../../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import 'admin_state.dart';
import 'models/admin_section.dart';
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
      ),
    );

/// [ARCH: PRESENTATION]
/// ROLE: Admin Console — provider configs and identity resolution.
class AdminNotifier extends AutoDisposeNotifier<AdminState> {
  AdminNotifier({
    required IProviderConfigRepository providerRepo,
    required IUserRepository userRepo,
  }) : _providerRepo = providerRepo,
       _userRepo = userRepo;

  final IProviderConfigRepository _providerRepo;
  final IUserRepository _userRepo;

  @override
  AdminState build() {
    return const AdminState();
  }

  Future<void> start() async {
    state = state.copyWith(status: ViewStatus.loading);

    final configsResult = await _providerRepo.getProviderConfigs();
    final identitiesResult = await _userRepo.getIdentities();
    final usersResult = await _userRepo.getUsers();

    configsResult.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (configs) {
        identitiesResult.fold(
          (failure) {
            state = state.copyWith(
              status: ViewStatus.failure,
              errorMessage: failure.message,
              configs: configs,
            );
          },
          (identities) {
            usersResult.fold(
              (failure) {
                state = state.copyWith(
                  status: ViewStatus.failure,
                  errorMessage: failure.message,
                  configs: configs,
                  identities: identities,
                );
              },
              (users) {
                state = state.copyWith(
                  status: ViewStatus.success,
                  configs: configs,
                  identities: identities,
                  users: users,
                  errorMessage: null,
                );
                unawaited(refreshProviderStatuses());
              },
            );
          },
        );
      },
    );
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
        (message) =>
            _updateStatus(providerId, ViewStatus.success, message: message),
      );
    } catch (e) {
      _updateStatus(
        providerId,
        ViewStatus.failure,
        message: e is TimeoutException ? 'Connection timed out' : e.toString(),
      );
    }
  }

  void _updateStatus(String providerId, ViewStatus status, {String? message}) {
    final updatedStatuses = Map<String, ProviderConnectionStatus>.from(
      state.connectionStatuses,
    );
    updatedStatuses[providerId] = ProviderConnectionStatus(
      status: status,
      message: message,
      lastCheck: DateTime.now(),
    );
    state = state.copyWith(connectionStatuses: updatedStatuses);
  }

  Future<void> setSection(AdminSection section) async {
    state = state.copyWith(selectedSection: section);
    if (section == AdminSection.providers) {
      await refreshProviderStatuses();
    }
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
    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) {
        final newConfigs = state.configs
            .map((c) => c.id == config.id ? config : c)
            .toList();
        state = state.copyWith(configs: newConfigs, errorMessage: null);
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
          (message) =>
              _updateStatus(config.id, ViewStatus.success, message: message),
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
