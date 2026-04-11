import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../../domain/repositories/abs_i_user_repository.dart';
import '../../core/models/view_status.dart';
import 'admin_event.dart';
import 'admin_state.dart';
import 'models/provider_connection_status.dart';

/// [ARCH: PRESENTATION_BLOC]
/// ROLE: Orchestrates Admin Console state including Provider Configs and Identity Resolution.
/// CONTRACT: Standard Bloc interface for [AdminView].
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final IProviderConfigRepository _providerRepo;
  final IUserRepository _userRepo;

  AdminBloc({
    required IProviderConfigRepository providerRepo,
    required IUserRepository userRepo,
  }) : _providerRepo = providerRepo,
       _userRepo = userRepo,
       super(const AdminState()) {
    on<AdminStarted>(_onStarted);
    on<AdminConfigUpdated>(_onConfigUpdated);
    on<AdminProviderToggled>(_onProviderToggled);
    on<AdminIdentityLinked>(_onIdentityLinked);
    on<AdminSectionChanged>(_onSectionChanged);
    on<AdminUserRoleUpdated>(_onUserRoleUpdated);
    on<AdminTestConnection>(_onTestConnection);
    on<AdminIdentityResolved>(_onIdentityResolved);
  }

  Future<void> _onTestConnection(
    AdminTestConnection event,
    Emitter<AdminState> emit,
  ) async {
    final providerId = event.config.id;

    // Set loading status for this specific provider
    _updateStatus(emit, providerId, ViewStatus.loading);

    try {
      final result = await _providerRepo
          .testProviderConfig(event.config)
          .timeout(const Duration(seconds: 15));

      result.fold(
        (failure) => _updateStatus(
          emit,
          providerId,
          ViewStatus.failure,
          message: failure.message,
        ),
        (message) => _updateStatus(
          emit,
          providerId,
          ViewStatus.success,
          message: message,
        ),
      );
    } catch (e) {
      _updateStatus(
        emit,
        providerId,
        ViewStatus.failure,
        message: e is TimeoutException ? 'Connection timed out' : e.toString(),
      );
    }
  }

  void _updateStatus(
    Emitter<AdminState> emit,
    String providerId,
    ViewStatus status, {
    String? message,
  }) {
    final updatedStatuses = Map<String, ProviderConnectionStatus>.from(
      state.connectionStatuses,
    );
    updatedStatuses[providerId] = ProviderConnectionStatus(
      status: status,
      message: message,
      lastCheck: DateTime.now(),
    );
    emit(state.copyWith(connectionStatuses: updatedStatuses));
  }

  Future<void> _onStarted(AdminStarted event, Emitter<AdminState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final configsResult = await _providerRepo.getProviderConfigs();
    final identitiesResult = await _userRepo.getIdentities();
    final usersResult = await _userRepo.getUsers();

    configsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (configs) {
        identitiesResult.fold(
          (failure) => emit(
            state.copyWith(
              status: ViewStatus.failure,
              errorMessage: failure.message,
              configs: configs,
            ),
          ),
          (identities) {
            usersResult.fold(
              (failure) => emit(
                state.copyWith(
                  status: ViewStatus.failure,
                  errorMessage: failure.message,
                  configs: configs,
                  identities: identities,
                ),
              ),
              (users) => emit(
                state.copyWith(
                  status: ViewStatus.success,
                  configs: configs,
                  identities: identities,
                  users: users,
                  errorMessage: null,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onSectionChanged(
    AdminSectionChanged event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(selectedSection: event.section));
  }

  Future<void> _onUserRoleUpdated(
    AdminUserRoleUpdated event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _userRepo.updateUserRole(
      userId: event.userId,
      role: event.role,
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final newUsers = state.users.map((u) {
          if (u.id == event.userId) {
            return u.copyWith(role: event.role);
          }
          return u;
        }).toList();
        emit(
          state.copyWith(users: newUsers, errorMessage: null),
        );
      },
    );
  }

  Future<void> _onConfigUpdated(
    AdminConfigUpdated event,
    Emitter<AdminState> emit,
  ) async {
    final result = await _providerRepo.saveProviderConfig(event.config);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final newConfigs = state.configs
            .map((c) => c.id == event.config.id ? event.config : c)
            .toList();
        emit(state.copyWith(configs: newConfigs, errorMessage: null));
      },
    );
  }

  Future<void> _onProviderToggled(
    AdminProviderToggled event,
    Emitter<AdminState> emit,
  ) async {
    final config = state.configs.firstWhere((c) => c.id == event.id);
    final updatedConfig = config.copyWith(isActive: event.isActive);
    add(AdminConfigUpdated(updatedConfig));
  }

  Future<void> _onIdentityLinked(
    AdminIdentityLinked event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _userRepo.linkIdentity(
      userId: event.userId,
      providerId: event.providerId,
      externalId: event.externalId,
      externalUsername: event.externalUsername,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (newIdentity) {
        var replaced = false;
        final newIdentities = state.identities.map((i) {
          if (i.providerId == event.providerId &&
              i.externalId == event.externalId) {
            replaced = true;
            return newIdentity;
          }
          return i;
        }).toList();
        if (!replaced) {
          newIdentities.add(newIdentity);
        }

        emit(
          state.copyWith(
            status: ViewStatus.success,
            identities: newIdentities,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onIdentityResolved(
    AdminIdentityResolved event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _userRepo.resolveIdentity(
      userId: event.userId,
      providerId: event.providerId,
      status: event.status,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedIdentity) {
        final newIdentities = state.identities.map((i) {
          if (i.id == updatedIdentity.id) {
            return updatedIdentity;
          }
          return i;
        }).toList();

        emit(
          state.copyWith(
            status: ViewStatus.success,
            identities: newIdentities,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
