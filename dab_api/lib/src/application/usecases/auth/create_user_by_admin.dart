import 'package:bcrypt/bcrypt.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import '../../../domain/repositories/abs_i_system_settings_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/core/config/config.dart';
import '../../../infrastructure/sources/phorge/phorge_user_source.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Creates a new DAB User on behalf of an administrator.
/// CONTRACT: The only account creation path after bootstrap. Enforces the
/// allowed-domain restriction when domain validation is enabled in system
/// settings; otherwise accepts any email.
/// CONSTRAINTS: Must hash passwords using [BCrypt]. Callers must be admins
/// (enforced by the admin middleware at the presentation layer).
class CreateUserByAdmin {
  final Config _config;
  final AbsIAuthRepository _repo;
  final IUserRepository _userRepository;
  final PhorgeUserSource _phorgeUserSource;
  final ISystemSettingsRepository _settingsRepo;
  final _uuid = const Uuid();

  /// [config] is injectable for deterministic tests; defaults to the
  /// env-backed [Config] singleton.
  CreateUserByAdmin(
    this._repo,
    this._userRepository,
    this._phorgeUserSource,
    this._settingsRepo, {
    Config? config,
  }) : _config = config ?? Config();

  /// Hashes a plain-text password for secure storage.
  String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Executes the admin account creation logic.
  ///
  /// 1. Domain Guard: When domain validation is enabled, the email must match
  ///    the allowed domain (DB setting, falling back to [Config.allowedDomain]).
  /// 2. Uniqueness Check: Verifies that the email is not already registered.
  /// 3. Identity Linking: Attempts to find a matching PHID in Phorge to enable
  ///    activity tracking.
  /// 4. Persistence: Saves the new [User] entity with the requested [role].
  Future<Either<AuthFailure, User>> execute(
    String name,
    String email,
    String password, {
    UserRole role = UserRole.standard,
  }) async {
    final validationEnabledResult = await _settingsRepo
        .isDomainValidationEnabled();
    final validationEnabled = validationEnabledResult.getOrElse((_) => false);

    if (validationEnabled) {
      final domain = email.split('@').last.toLowerCase();

      final dynamicDomainResult = await _settingsRepo.getAllowedDomain();
      var allowedDomain = dynamicDomainResult.getOrElse((_) => null)?.trim();

      // Fallback to Env Config if not configured in the database.
      if (allowedDomain == null || allowedDomain.isEmpty) {
        allowedDomain = _config.allowedDomain.trim();
      }

      if (allowedDomain.isEmpty) {
        return const Left(
          AuthFailure(
            'Domain validation is enabled but no allowed domain is configured. '
            'Set allowed_domain in the Admin Console or DAB_ALLOWED_DOMAIN in '
            'the API environment.',
          ),
        );
      }
      if (domain != allowedDomain.toLowerCase()) {
        return Left(
          AuthFailure('Account creation restricted to $allowedDomain domain'),
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
