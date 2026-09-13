import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/user/user.dart';

part 'auth_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Immutable state for Authentication features.
@MappableClass()
class AuthState with AuthStateMappable {
  final ViewStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = ViewStatus.initial,
    this.user,
    this.errorMessage,
  });

  factory AuthState.initial() => const AuthState();

  bool get isAuthenticated => user != null;
}
