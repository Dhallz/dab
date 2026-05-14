import 'package:dart_mappable/dart_mappable.dart';

part 'failure.mapper.dart';

/// A base class for all failures in the system.
@MappableClass()
sealed class Failure with FailureMappable {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// Generic database-related failure.
@MappableClass()
class DatabaseFailure extends Failure with DatabaseFailureMappable {
  const DatabaseFailure(super.message);
}

/// Failure occurring during authentication/authorization.
@MappableClass()
class AuthFailure extends Failure with AuthFailureMappable {
  const AuthFailure(super.message);
}

/// Bootstrap lock: login/register forbidden for this identity until an admin exists.
@MappableClass()
class BootstrapLockFailure extends AuthFailure with BootstrapLockFailureMappable {
  const BootstrapLockFailure(super.message);
}

/// Failure when a requested resource is not found.
@MappableClass()
class NotFoundFailure extends Failure with NotFoundFailureMappable {
  const NotFoundFailure(super.message);
}

/// Failure when business rules are violated.
@MappableClass()
class ValidationFailure extends Failure with ValidationFailureMappable {
  const ValidationFailure(super.message);
}
