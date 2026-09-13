import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/containers/auth_usecases.dart';
import '../../../../domain/core/api_origin.dart';
import '../../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_notifier.dart';
import '../../features/auth/auth_notifier.dart';
import 'auth_state.dart';

final authFormNotifierProvider =
    NotifierProvider.autoDispose<AuthFormNotifier, AuthState>(
      () => AuthFormNotifier(sl.authUseCases),
    );

/// [ARCH: PRESENTATION]
/// ROLE: Login/register form state for the auth screen (replaces [AuthBloc]).
///
/// **Former `AuthEvent` types → methods:** bootstrap → [loadSavedCredentials] (via
/// [build]); `AuthModeToggled` → [toggleMode]; `AuthEmailChanged` / `AuthPasswordChanged`
/// / `AuthNameChanged` / `AuthApiBaseChanged` → [setEmail], [setPassword], [setName],
/// [setApiBase]; `AuthSubmitted` → [submit].
class AuthFormNotifier extends AutoDisposeNotifier<AuthState> {
  AuthFormNotifier(this._usecases);

  final AuthUseCases _usecases;

  @override
  AuthState build() {
    Future.microtask(loadSavedCredentials);
    return AuthState(apiBase: ApiOrigin.defaultLocal);
  }

  Future<void> loadSavedCredentials() async {
    final originResult = await _usecases.getApiOrigin.execute();
    originResult.fold((_) {}, (origin) {
      state = state.copyWith(apiBase: origin);
    });
    final result = await _usecases.getSavedCredentials.execute();
    await result.fold((failure) async => null, (credentials) async {
      if (credentials != null) {
        state = state.copyWith(
          email: credentials['email'] ?? '',
          password: credentials['password'] ?? '',
        );
      }
    });
  }

  void toggleMode() {
    state = state.copyWith(isLogin: !state.isLogin, status: ViewStatus.initial);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setApiBase(String apiBase) {
    state = state.copyWith(apiBase: apiBase);
  }

  Future<void> submit() async {
    if (state.status == ViewStatus.loading) return;

    state = state.copyWith(status: ViewStatus.loading);

    final originResult = await _usecases.setApiOrigin.execute(state.apiBase);
    final originFailed = originResult.fold((failure) {
      state = state.copyWith(
        status: ViewStatus.failure,
        errorMessage: failure.message,
      );
      return true;
    }, (_) => false);
    if (originFailed) return;

    await ref.read(appNotifierProvider.notifier).init();

    if (state.isLogin) {
      final result = await _usecases.login.execute(
        email: state.email,
        password: state.password,
      );
      await result.fold(
        (failure) async {
          state = state.copyWith(
            status: ViewStatus.failure,
            errorMessage: failure.message,
          );
        },
        (response) async {
          await _usecases.saveCredentials.execute(
            email: state.email,
            password: state.password,
          );
          await ref.read(authNotifierProvider.notifier).checkAuth();
          state = state.copyWith(status: ViewStatus.success);
        },
      );
    } else {
      final result = await _usecases.register.execute(
        email: state.email,
        password: state.password,
        name: state.name,
      );
      await result.fold(
        (failure) async => state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
        (response) async {
          await _usecases.saveCredentials.execute(
            email: state.email,
            password: state.password,
          );

          // Refresh bootstrap status after the first registration.
          await ref.read(appNotifierProvider.notifier).init();
          await ref.read(authNotifierProvider.notifier).checkAuth();
          state = state.copyWith(status: ViewStatus.success);
        },
      );
    }
  }
}
