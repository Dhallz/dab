import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/demo_teammate_spec.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves the complete user directory.
/// CONTRACT: Returns all registered DAB [User] entities or a [DatabaseFailure].
/// [User.linkedProviderIds] is a Directory hint. Screenshot mock mode and
/// seed teammates (empty [User.passwordHash]) include active ingest ids so
/// tiles do not show “Hasn't connected”.
class GetUsers {
  GetUsers(
    this._repo, {
    AbsIProviderConfigRepository? configs,
    bool Function()? isDemoMode,
  }) : _configs = configs,
       _isDemoMode = isDemoMode ?? (() => false);

  final IUserRepository _repo;
  final AbsIProviderConfigRepository? _configs;
  final bool Function() _isDemoMode;

  Future<Either<DatabaseFailure, List<User>>> execute() async {
    final usersResult = await _repo.getUsers();
    if (usersResult.isLeft()) return usersResult;
    final users = usersResult.getOrElse((_) => const []);
    final demoIds = await _demoLinkedProviderIds();
    try {
      final identities = (await _repo.getAllIdentities()).getOrElse((_) => []);
      final byUser = <String, List<String>>{};
      for (final identity in identities) {
        if (identity.status != UserIdentityStatus.linked) continue;
        byUser.putIfAbsent(identity.userId, () => []).add(identity.providerId);
      }
      return Right(_withDirectoryLinks(users, byUser, demoIds));
    } catch (_) {
      return Right(_withDirectoryLinks(users, const {}, demoIds));
    }
  }

  Future<Set<String>> _demoLinkedProviderIds() async {
    if (!_isDemoMode() || _configs == null) return {};
    final result = await _configs.getConfigs();
    final active = result
        .getOrElse((_) => const [])
        .where((config) => config.isActive)
        .map((config) => config.id.trim().toLowerCase())
        .where((id) => id.isNotEmpty)
        .toSet();
    if (active.isNotEmpty) return active;
    return {...kDemoLinkedProviderIds};
  }

  List<User> _withDirectoryLinks(
    List<User> users,
    Map<String, List<String>> byUser,
    Set<String> demoIds,
  ) {
    return [
      for (final user in users)
        user.copyWith(
          linkedProviderIds: _linkedIds(
            user: user,
            linked: byUser[user.id] ?? const [],
            demoIds: demoIds,
          ),
        ),
    ];
  }

  List<String> _linkedIds({
    required User user,
    required List<String> linked,
    required Set<String> demoIds,
  }) {
    final isDemoTeammate = user.passwordHash.isEmpty;
    if (!_isDemoMode() && !isDemoTeammate) return linked;
    final ids = <String>{
      ...linked,
      ...demoIds,
      if (isDemoTeammate && demoIds.isEmpty) ...kDemoLinkedProviderIds,
    };
    return ids.toList()..sort();
  }
}
