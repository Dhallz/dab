sealed class AuthEvent {
  const AuthEvent();
}

class AuthModeToggled extends AuthEvent {
  const AuthModeToggled();
}

class AuthEmailChanged extends AuthEvent {
  final String email;
  const AuthEmailChanged(this.email);
}

class AuthPasswordChanged extends AuthEvent {
  final String password;
  const AuthPasswordChanged(this.password);
}

class AuthNameChanged extends AuthEvent {
  final String name;
  const AuthNameChanged(this.name);
}

class AuthSubmitted extends AuthEvent {
  const AuthSubmitted();
}
