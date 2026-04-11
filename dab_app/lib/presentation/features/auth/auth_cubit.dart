import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/containers/auth_usecases.dart';
import '../../../../domain/entities/user/user.dart';
import '../../../../domain/entities/user/user_role.dart';
import '../../core/models/view_status.dart';
import 'auth_state.dart';

/// [ARCH: PRESENTATION_BLOC]
/// ROLE: State Manager for Authentication and Session lifecycle.
/// CONTRACT: Manages [AuthState]. Orchestrates login, registration, and logout.
/// CONSTRAINTS: Directly interacts with [AuthUseCases].
class AuthCubit extends Cubit<AuthState> {
  final AuthUseCases _usecases;

  AuthCubit(this._usecases) : super(AuthState.initial());

  Future<void> checkAuth() async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _usecases.checkAuthStatus.execute();
    result.fold(
      (failure) => emit(state.copyWith(status: ViewStatus.success, user: null)),
      (user) => emit(state.copyWith(status: ViewStatus.success, user: user)),
    );
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _usecases.login.execute(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
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
      ),
    );
  }

  Future<void> register(String email, String password, String name) async {
    emit(state.copyWith(status: ViewStatus.loading));
    final result = await _usecases.register.execute(
      email: email,
      password: password,
      name: name,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
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
      ),
    );
  }

  Future<void> logout() async {
    emit(state.copyWith(status: ViewStatus.loading));
    await _usecases.logout.execute();
    emit(state.copyWith(status: ViewStatus.success, user: null));
  }
}
