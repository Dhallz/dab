import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/containers/auth_usecases.dart';
import '../../../../domain/entities/user.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Discrete status of the Authentication lifecycle.
enum AuthStatus { initial, authenticated, unauthenticated, error }

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Immutable state for Authentication features.
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({required this.status, this.user, this.errorMessage});

  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  factory AuthState.authenticated(User user) =>
      AuthState(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.error(String message) =>
      AuthState(status: AuthStatus.error, errorMessage: message);
}

/// [ARCH: PRESENTATION_BLOC]
/// ROLE: State Manager for Authentication and Session lifecycle.
/// CONTRACT: Manages [AuthState]. Orchestrates login, registration, and logout.
/// CONSTRAINTS: Directly interacts with [AuthUseCases].
class AuthCubit extends Cubit<AuthState> {
  final AuthUseCases _usecases;

  AuthCubit(this._usecases) : super(AuthState.initial());

  Future<void> checkAuth() async {
    final result = await _usecases.checkAuthStatus.execute();
    result.fold(
      (failure) => emit(AuthState.unauthenticated()),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  Future<void> login(String email, String password) async {
    final result = await _usecases.login.execute(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (response) => emit(
        AuthState.authenticated(
          User(
            id: response.userId,
            name: response.name,
            email: response.email,
            avatarUrl: response.avatarUrl,
          ),
        ),
      ),
    );
  }

  Future<void> register(String email, String password, String name) async {
    final result = await _usecases.register.execute(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (response) => emit(
        AuthState.authenticated(
          User(
            id: response.userId,
            name: response.name,
            email: response.email,
            avatarUrl: response.avatarUrl,
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    await _usecases.logout.execute();
    emit(AuthState.unauthenticated());
  }
}
