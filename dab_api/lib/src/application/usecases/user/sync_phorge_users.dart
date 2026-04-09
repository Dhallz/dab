import 'package:bcrypt/bcrypt.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failure.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';
import '../../../infrastructure/config/config.dart';
import '../../../infrastructure/sources/phorge/phorge_user_source.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Automated Provisioning of DAB Users from Phorge Directory.
/// CONTRACT: Fetches all active Phorge users and creates matching DAB identities.
/// CONSTRAINTS: Must generate emails using [allowedDomain]. Must initialize with a default password.
/// 
/// This use case is the "Onboarding Factory" for the system. It ensures 
/// that every Phorge developer has a corresponding DAB account without 
/// manual intervention.
class SyncPhorgeUsers {
  final IUserRepository _repo;
  final AbsIProviderConfigRepository _configRepo;
  final PhorgeUserSource _phorgeUserSource;
  final Config _config;
  /// When non-null (e.g. in tests), used instead of [Config.allowedDomain].
  final String? _allowedDomainOverride;
  final _uuid = const Uuid();

  SyncPhorgeUsers(
    this._repo,
    this._phorgeUserSource,
    this._configRepo, {
    String? allowedDomainOverride,
  })  : _config = Config(),
        _allowedDomainOverride = allowedDomainOverride;

  /// Executes the synchronization process.
  /// 
  /// 1. Checks if the Phorge provider is active via [_configRepo].
  /// 2. Fetches the complete employee list from Phorge via [PhorgeUserSource].
  /// 3. Compares against existing DAB users by email.
  /// 4. For new employees:
  ///    - Generates a standard corporate email (username@domain).
  ///    - Hashes a temporary password for initial login.
  ///    - Links the Phorge PHID for immediate activity tracking.
  ///    - Persists the new [User] record.
  /// 
  /// Returns the count of newly synced users.
  Future<Either<DatabaseFailure, int>> execute() async {
    try {
      // Kill-switch (DAB-40): Check if Phorge provider is active.
      final configsResult = await _configRepo.getConfigs();
      final configs = configsResult.getOrElse((_) => []);
      final phorgeConfig = configs.firstWhere((c) => c.id == 'phorge', 
          orElse: () => throw Exception('Phorge provider configuration not found'));
      
      if (!phorgeConfig.isActive) {
        return const Right(0); // Deactivated, skip sync.
      }

      final allowedDomain =
          _allowedDomainOverride ?? _config.allowedDomain;
      if (allowedDomain.isEmpty) {
        return const Right(0);
      }

      final phorgeUsers = await _phorgeUserSource.fetchAllUsers();
      int syncedCount = 0;

      final existingUsersResult = await _repo.getUsers();
      final existingUsersMap = existingUsersResult.getOrElse((_) => []).fold<Map<String, User>>(
        <String, User>{},
        (map, user) {
          map[user.email] = user;
          return map;
        },
      );

      for (final pUser in phorgeUsers) {
        final phorgeUsername = pUser.userName;
        final generatedEmail =
            '${phorgeUsername.toLowerCase()}@$allowedDomain';

        // Idempotency Check: Only create if the account doesn't exist.
        if (!existingUsersMap.containsKey(generatedEmail)) {
          final passwordHash = BCrypt.hashpw(phorgeUsername, BCrypt.gensalt());

          final newUser = User(
             id: _uuid.v4(),
             name: pUser.realName ?? phorgeUsername,
             email: generatedEmail,
             passwordHash: passwordHash,
             role: 'Standard',
             phorgePhid: pUser.phid,
             phorgeUsername: phorgeUsername,
             createdAt: DateTime.now(),
          );

          await _repo.saveUser(newUser);
          syncedCount++;
        }
      }

      return Right(syncedCount);
    } catch (e) {
      return Left(DatabaseFailure('Sync failed: $e'));
    }
  }
}
