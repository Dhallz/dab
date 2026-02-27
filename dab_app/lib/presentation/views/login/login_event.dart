import 'package:dart_mappable/dart_mappable.dart';

part 'login_event.mapper.dart';

@MappableClass(discriminatorKey: 'type')
sealed class LoginEvent with LoginEventMappable {
  const LoginEvent();
}

@MappableClass()
class LoginSubmitted extends LoginEvent with LoginSubmittedMappable {
  final String email;
  final String password;
  const LoginSubmitted({required this.email, required this.password});
}
