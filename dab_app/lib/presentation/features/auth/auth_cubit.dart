import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/containers/auth_usecases.dart';
import '../../../../domain/entities/user.dart';

enum AuthStatus { initial, authenticated, unauthenticated, error }

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
      (response) =>
          emit(AuthState.authenticated(User(id: 'temp', email: email))),
    );
  }

  Future<void> register(String email, String password) async {
    final result = await _usecases.register.execute(
      email: email,
      password: password,
      name: 'User',
    );
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(AuthState.authenticated(User(id: 'temp', email: email))),
    );
  }

  Future<void> logout() async {
    await _usecases.logout.execute();
    emit(AuthState.unauthenticated());
  }
}
