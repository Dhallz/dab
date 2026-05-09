import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/containers/auth_usecases.dart';
import '../../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
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
/// / `AuthNameChanged` → [setEmail], [setPassword], [setName]; `AuthSubmitted` → [submit].
class AuthFormNotifier extends AutoDisposeNotifier<AuthState> {
  AuthFormNotifier(this._usecases);

  final AuthUseCases _usecases;

  @override
  AuthState build() {
    Future.microtask(loadSavedCredentials);
    return const AuthState();
  }

  Future<void> loadSavedCredentials() async {
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

  Future<void> submit(WidgetRef ref) async {
    if (state.status == ViewStatus.loading) return;

    state = state.copyWith(status: ViewStatus.loading);

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
          await ref.read(authNotifierProvider.notifier).checkAuth();
          state = state.copyWith(status: ViewStatus.success);
        },
      );
    }
  }
}
