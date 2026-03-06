import 'package:dab_app/presentation/core/abs_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/containers/auth_usecases.dart';
import '../../features/auth/auth_cubit.dart' as auth;
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends AbsBloc<AuthEvent, AuthState> {
  final AuthUseCases _usecases;
  final auth.AuthCubit? authCubit;

  AuthBloc(this._usecases, {this.authCubit}) : super(const AuthState()) {
    on<AuthStarted>(_onStarted);
    on<AuthModeToggled>(_onModeToggled);
    on<AuthEmailChanged>(_onEmailChanged);
    on<AuthPasswordChanged>(_onPasswordChanged);
    on<AuthNameChanged>(_onNameChanged);
    on<AuthSubmitted>(_onSubmitted);

    add(const AuthStarted());
  }

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _usecases.getSavedCredentials.execute();
    await result.fold((failure) async => null, (credentials) async {
      if (credentials != null) {
        emit(
          state.copyWith(
            email: credentials['email'],
            password: credentials['password'],
          ),
        );
      }
    });
  }

  void _onModeToggled(AuthModeToggled event, Emitter<AuthState> emit) {
    emit(
      state.copyWith(isLogin: !state.isLogin, status: AuthViewStatus.initial),
    );
  }

  void _onEmailChanged(AuthEmailChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(AuthPasswordChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onNameChanged(AuthNameChanged event, Emitter<AuthState> emit) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onSubmitted(
    AuthSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (state.status == AuthViewStatus.loading) return;

    emit(state.copyWith(status: AuthViewStatus.loading));

    if (state.isLogin) {
      final result = await _usecases.login.execute(
        email: state.email,
        password: state.password,
      );
      await result.fold(
        (failure) async {
          emit(
            state.copyWith(
              status: AuthViewStatus.failure,
              errorMessage: failure.message,
            ),
          );
        },
        (response) async {
          await _usecases.saveCredentials.execute(
            email: state.email,
            password: state.password,
          );
          authCubit?.checkAuth();
          emit(state.copyWith(status: AuthViewStatus.success));
        },
      );
    } else {
      final result = await _usecases.register.execute(
        email: state.email,
        password: state.password,
        name: state.name,
      );
      await result.fold(
        (failure) async => emit(
          state.copyWith(
            status: AuthViewStatus.failure,
            errorMessage: failure.message,
          ),
        ),
        (response) async {
          await _usecases.saveCredentials.execute(
            email: state.email,
            password: state.password,
          );
          authCubit?.checkAuth();
          emit(state.copyWith(status: AuthViewStatus.success));
        },
      );
    }
  }
}
