import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'auth_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Auth screen state.
@MappableClass()
class AuthState with AuthStateMappable {
  final ViewStatus status;
  final bool isLogin;
  final String? errorMessage;
  final String email;
  final String password;
  final String name;

  const AuthState({
    this.status = ViewStatus.initial,
    this.isLogin = true,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.name = '',
  });

  bool get isRegister => !isLogin;

  factory AuthState.initial() => const AuthState();
}
