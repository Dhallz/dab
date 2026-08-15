import 'package:fpdart/fpdart.dart' hide Group;

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Retrieves the complete user directory.
/// CONTRACT: Returns all registered DAB [User] entities or a [DatabaseFailure].
class GetUsers {
  final IUserRepository _repo;

  GetUsers(this._repo);

  Future<Either<DatabaseFailure, List<User>>> execute() async {
    final usersResult = await _repo.getUsers();
    if (usersResult.isLeft()) return usersResult;
    final users = usersResult.getOrElse((_) => const []);
    try {
      final identities = (await _repo.getAllIdentities()).getOrElse((_) => []);
      final byUser = <String, List<String>>{};
      for (final identity in identities) {
        if (identity.status != UserIdentityStatus.linked) continue;
        byUser.putIfAbsent(identity.userId, () => []).add(identity.providerId);
      }
      return Right([
        for (final user in users)
          user.copyWith(linkedProviderIds: byUser[user.id] ?? const []),
      ]);
    } catch (_) {
      return Right(users);
    }
  }
}
