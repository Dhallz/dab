import 'package:bcrypt/bcrypt.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/contracts/repositories/abs_i_auth_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/core/config/config.dart';
import '../../../infrastructure/sources/phorge/phorge_user_source.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Creates the bootstrap (first) DAB User identity via self-registration.
/// CONTRACT: Self-registration is only open while zero users exist; the first
/// user becomes the system admin. All subsequent accounts must be created by
/// an administrator (see [CreateUserByAdmin]).
/// CONSTRAINTS: Must enforce the bootstrap lock ([Config.initialAdminEmail])
/// when configured. Must hash passwords using [BCrypt].
class RegisterUser {
  final Config _config;
  final AbsIAuthRepository _repo;
  final IUserRepository _userRepository;
  final PhorgeUserSource _phorgeUserSource;
  final _uuid = const Uuid();

  /// [config] is injectable for deterministic tests; defaults to the
  /// env-backed [Config] singleton.
  RegisterUser(
    this._repo,
    this._userRepository,
    this._phorgeUserSource, {
    Config? config,
  }) : _config = config ?? Config();

  /// Hashes a plain-text password for secure storage.
  String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Executes the bootstrap registration logic.
  ///
  /// 1. Bootstrap Guard: Rejects self-registration once any user exists.
  /// 2. Bootstrap Lock: If [Config.initialAdminEmail] is set, the email must match it.
  /// 3. Role Assignment: The bootstrap user is always 'Admin'.
  /// 4. Identity Linking: Attempts to find a matching PHID in Phorge to enable activity tracking.
  /// 5. Persistence: Saves the new [User] entity.
  Future<Either<AuthFailure, User>> execute(
    String name,
    String email,
    String password,
  ) async {
    final allUsersResult = await _repo.findAllUsers();
    final userCount = allUsersResult.fold((_) => 0, (list) => list.length);

    if (userCount > 0) {
      return const Left(
        AuthFailure(
          'Self-registration is disabled. Ask the administrator to create your account.',
        ),
      );
    }

    // Bootstrap Lock: If an initial admin email is configured, only that
    // email can create the bootstrap account.
    final initialAdminEmail = _config.initialAdminEmail.trim();
    if (initialAdminEmail.isNotEmpty &&
        email.toLowerCase() != initialAdminEmail.toLowerCase()) {
      return Left(
        BootstrapLockFailure(
          'Bootstrap Lock: System not configured. Only the initial admin ($initialAdminEmail) can register.',
        ),
      );
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

    // Auto-link Phorge Account: Essential for immediate activity visibility.
    final phorgePhid = await _phorgeUserSource.lookupUserPhid(name, email);

    final user = User(
      id: _uuid.v4(),
      name: name,
      email: email,
      passwordHash: _hashPassword(password),
      role: UserRole.admin,
      phorgePhid: phorgePhid,
      createdAt: DateTime.now(),
    );

    final createResult = await _repo.createUser(user);
    if (createResult.isLeft()) {
      final f = createResult.getLeft().toNullable()!;
      return Left(AuthFailure('Error creating user: ${f.message}'));
    }

    final phid = user.phorgePhid;
    if (phid != null && phid.isNotEmpty) {
      final linkRes = await _userRepository.linkIdentity(
        UserIdentity(
          id: '${user.id}_phorge',
          userId: user.id,
          providerId: 'phorge',
          externalId: phid,
          status: UserIdentityStatus.linked,
          createdAt: DateTime.now(),
        ),
      );
      linkRes.fold((_) => null, (_) => null);
    }

    return Right(user);
  }
}
