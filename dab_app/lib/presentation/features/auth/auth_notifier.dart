import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/containers/auth_usecases.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import 'auth_state.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Authentication and session lifecycle.
/// CONTRACT: Manages [AuthState] for the signed-in user.
/// CONSTRAINTS: Directly interacts with [AuthUseCases].
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  () => AuthNotifier(sl.authUseCases),
);

class AuthNotifier extends Notifier<AuthState> {
  AuthNotifier(this._usecases);

  final AuthUseCases _usecases;

  @override
  AuthState build() {
    sl.authInterceptor.onSessionExpired = logout;
    Future.microtask(checkAuth);
    return AuthState.initial();
  }

  Future<void> checkAuth() async {
    state = state.copyWith(status: ViewStatus.loading);
    final result = await _usecases.checkAuthStatus.execute();
    result.fold(
      (failure) =>
          state = state.copyWith(status: ViewStatus.success, user: null),
      (user) => state = state.copyWith(status: ViewStatus.success, user: user),
    );
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: ViewStatus.loading);
    final result = await _usecases.login.execute(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: ViewStatus.failure,
        errorMessage: failure.message,
      ),
      (response) => state = state.copyWith(
        status: ViewStatus.success,
        user: User(
          id: response.userId,
          name: response.name,
          email: response.email,
          role: UserRole.values.firstWhere(
            (e) => e.name == response.role,
            orElse: () => UserRole.standard,
          ),
          avatarUrl: response.avatarUrl,
        ),
      ),
    );
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(status: ViewStatus.loading);
    final result = await _usecases.register.execute(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: ViewStatus.failure,
        errorMessage: failure.message,
      ),
      (response) => state = state.copyWith(
        status: ViewStatus.success,
        user: User(
          id: response.userId,
          name: response.name,
          email: response.email,
          role: UserRole.values.firstWhere(
            (e) => e.name == response.role,
            orElse: () => UserRole.standard,
          ),
          avatarUrl: response.avatarUrl,
        ),
      ),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: ViewStatus.loading);
    await _usecases.logout.execute();
    state = state.copyWith(status: ViewStatus.success, user: null);
  }
}
