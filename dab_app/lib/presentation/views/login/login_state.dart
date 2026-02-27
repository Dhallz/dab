import 'package:dart_mappable/dart_mappable.dart';

part 'login_state.mapper.dart';

@MappableClass(discriminatorKey: 'status')
sealed class LoginState with LoginStateMappable {
  const LoginState();
}

@MappableClass()
class LoginInitial extends LoginState with LoginInitialMappable {
  const LoginInitial();
}

@MappableClass()
class LoginLoading extends LoginState with LoginLoadingMappable {
  const LoginLoading();
}

@MappableClass()
class LoginSuccess extends LoginState with LoginSuccessMappable {
  const LoginSuccess();
}

@MappableClass()
class LoginFailure extends LoginState with LoginFailureMappable {
  final String error;
  const LoginFailure(this.error);
}
