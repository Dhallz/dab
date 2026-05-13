import 'package:bcrypt/bcrypt.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/gataways/abs_i_phorge_gataway.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Automated Provisioning of DAB Users from Phorge Directory.
/// CONTRACT: Fetches all active Phorge users and creates matching DAB identities.
/// CONSTRAINTS: Uses [allowedDomain] for generated emails; no Infrastructure imports.

class SyncPhorgeUsers {
  final IUserRepository _repo;
  final AbsIProviderConfigRepository _configRepo;
  final AbsIPhorgeGateway _phorgeGateway;
  final String _allowedDomain;
  final _uuid = const Uuid();

  SyncPhorgeUsers(
    this._repo,
    this._phorgeGateway,
    this._configRepo, {
    required String allowedDomain,
  }) : _allowedDomain = allowedDomain;

  /// Returns the count of newly synced users.
  Future<Either<Failure, int>> execute() async {
    try {
      final configsResult = await _configRepo.getConfigs();
      final configs = configsResult.getOrElse((_) => <ProviderConfig>[]);
      ProviderConfig? phorgeConfig;
      for (final c in configs) {
        if (c.id == 'phorge') {
          phorgeConfig = c;
          break;
        }
      }
      if (phorgeConfig == null) {
        return const Left(
          NotFoundFailure('Phorge provider configuration not found'),
        );
      }

      if (!phorgeConfig.isActive) {
        return const Right(0);
      }

      if (_allowedDomain.isEmpty) {
        return const Right(0);
      }

      final directoryResult = await _phorgeGateway.fetchDirectoryUsers();
      if (directoryResult.isLeft()) {
        return Left(directoryResult.getLeft().toNullable()!);
      }
      final phorgeUsers = directoryResult.getRight().toNullable()!;
      int syncedCount = 0;

      final existingUsersResult = await _repo.getUsers();
      final existingUsersMap = existingUsersResult
          .getOrElse((_) => [])
          .fold<Map<String, User>>(<String, User>{}, (map, user) {
            map[user.email] = user;
            return map;
          });

      for (final pUser in phorgeUsers) {
        final phorgeUsername = pUser.userName;
        final generatedEmail =
            '${phorgeUsername.toLowerCase()}@$_allowedDomain';

        if (!existingUsersMap.containsKey(generatedEmail)) {
          final passwordHash = BCrypt.hashpw(phorgeUsername, BCrypt.gensalt());

          final newUser = User(
            id: _uuid.v4(),
            name: pUser.realName ?? phorgeUsername,
            email: generatedEmail,
            passwordHash: passwordHash,
            role: UserRole.standard,
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
