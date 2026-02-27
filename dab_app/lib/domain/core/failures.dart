import 'package:dart_mappable/dart_mappable.dart';

part 'failures.mapper.dart';

@MappableClass(discriminatorKey: 'type')
sealed class AppFailure with AppFailureMappable {
  final String message;
  const AppFailure(this.message);
}

@MappableClass()
class ServerFailure extends AppFailure with ServerFailureMappable {
  final int? statusCode;
  final String? errorCode;
  const ServerFailure({
    required String message,
    this.statusCode,
    this.errorCode,
  }) : super(message);
}

@MappableClass()
class NetworkFailure extends AppFailure with NetworkFailureMappable {
  final String? technicalMessage;
  const NetworkFailure({this.technicalMessage})
    : super('No internet connection');
}

@MappableClass()
class AuthFailure extends AppFailure with AuthFailureMappable {
  const AuthFailure([super.message = 'Unauthorized']);
}

@MappableClass()
class ValidationFailure extends AppFailure with ValidationFailureMappable {
  final Map<String, List<String>> errors;
  const ValidationFailure({
    required this.errors,
    String message = 'Validation failed',
  }) : super(message);
}

@MappableClass()
class UnknownFailure extends AppFailure with UnknownFailureMappable {
  final dynamic originalError;
  const UnknownFailure({
    this.originalError,
    String message = 'An unexpected error occurred',
  }) : super(message);
}
