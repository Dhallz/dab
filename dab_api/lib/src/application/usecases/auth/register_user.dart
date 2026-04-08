import 'package:bcrypt/bcrypt.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import '../../../infrastructure/config/config.dart';
import '../../../infrastructure/sources/phorge/phorge_user_source.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Creates a new DAB User identity.
/// CONTRACT: Validates domain restrictions, hashes passwords, and links external identities (Phorge).
/// CONSTRAINTS: Must enforce the [allowedDomain] restriction. Must hash passwords using [BCrypt].
class RegisterUser {
  final Config _config;
  final AbsIAuthRepository _repo;
  final PhorgeUserSource _phorgeUserSource;
  final _uuid = const Uuid();

  RegisterUser(this._repo, this._phorgeUserSource) : _config = Config();

  /// Hashes a plain-text password for secure storage.
  String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Executes the registration logic.
  ///
  /// 1. Domain Guard: Ensures the email belongs to the corporate domain.
  /// 2. Uniqueness Check: Verified that the email is not already registered.
  /// 3. Role Assignment: Assigns 'Admin' to the initial system user, 'Standard' otherwise.
  /// 4. Identity Linking: Attempts to find a matching PHID in Phorge to enable activity tracking.
  /// 5. Persistence: Saves the new [User] entity.
  Future<Either<AuthFailure, User>> execute(
    String name,
    String email,
    String password,
  ) async {
    // 1. Domain Guard: Prevent unauthorized external registrations.
    // NOTE: We bypass the domain guard for the designated initial admin.
    final isInitialAdmin =
        email.toLowerCase() == _config.initialAdminEmail.toLowerCase();
    final domain = email.split('@').last.toLowerCase();
    final allowedDomain = _config.allowedDomain;

    if (!isInitialAdmin) {
      if (allowedDomain.isEmpty) {
        return const Left(
          AuthFailure(
            'Registration domain is not configured. Set DAB_ALLOWED_DOMAIN in '
            'the API environment.',
          ),
        );
      }
      if (domain != allowedDomain) {
        return Left(
          AuthFailure('Registration restricted to $allowedDomain domain'),
        );
      }
    }

    final findResult = await _repo.findByEmail(email);

    if (findResult.isLeft()) {
      final f = findResult.getLeft().toNullable()!;
      return Left(AuthFailure('Database error: ${f.message}'));
    }

    final existing = findResult.getRight().toNullable();
    if (existing != null) {
      return const Left(AuthFailure('User already exists'));
    }

    // 3. Bootstrap Lock: If no admins exist, only allow the initial admin.
    final adminCountResult = await _repo.countAdmins();
    final adminCount = adminCountResult.getOrElse((_) => 0);

    if (adminCount == 0 && !isInitialAdmin) {
      return Left(
        AuthFailure(
          'Bootstrap Lock: System not configured. Only the initial admin (${_config.initialAdminEmail}) can register.',
        ),
      );
    }

    // Role assignment logic based on configuration.
    final role = isInitialAdmin ? 'Admin' : 'Standard';

    // Auto-link Phorge Account: Essential for immediate activity visibility.
    final phorgePhid = await _phorgeUserSource.lookupUserPhid(name, email);

    final user = User(
      id: _uuid.v4(),
      name: name,
      email: email,
      passwordHash: _hashPassword(password),
      role: role,
      phorgePhid: phorgePhid,
      createdAt: DateTime.now(),
    );

    final createResult = await _repo.createUser(user);
    if (createResult.isLeft()) {
      final f = createResult.getLeft().toNullable()!;
      return Left(AuthFailure('Error creating user: ${f.message}'));
    }
    return Right(user);
  }
}
