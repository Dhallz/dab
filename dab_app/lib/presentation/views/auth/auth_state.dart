enum AuthViewStatus { initial, loading, success, failure }

class AuthState {
  final AuthViewStatus status;
  final bool isLogin;
  final String? errorMessage;
  final String email;
  final String password;
  final String name;

  const AuthState({
    this.status = AuthViewStatus.initial,
    this.isLogin = true,
    this.errorMessage,
    this.email = 'admin@acme.com',
    this.password = 'securepassword',
    this.name = '',
  });

  bool get isRegister => !isLogin;

  AuthState copyWith({
    AuthViewStatus? status,
    bool? isLogin,
    String? errorMessage,
    String? email,
    String? password,
    String? name,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLogin: isLogin ?? this.isLogin,
      errorMessage: errorMessage ?? this.errorMessage,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
    );
  }
}
