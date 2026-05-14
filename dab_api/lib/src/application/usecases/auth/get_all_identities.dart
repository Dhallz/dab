import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_auth_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Fetches all platform identities for administrative review.
/// CONTRACT: Returns rows from `user_identities` plus legacy Phorge PHIDs on [User] when not yet stored.
class GetAllIdentities {
  final IUserRepository _userRepository;
  final AbsIAuthRepository _authRepository;

  GetAllIdentities(this._userRepository, this._authRepository);

  Future<Either<DatabaseFailure, List<UserIdentity>>> execute() async {
    final identitiesResult = await _userRepository.getAllIdentities();
    if (identitiesResult.isLeft()) return identitiesResult;

    final usersResult = await _authRepository.findAllUsers();
    if (usersResult.isLeft()) {
      final msg = usersResult.getLeft().toNullable()!.message;
      return Left(DatabaseFailure(msg));
    }

    final fromDb = identitiesResult.getRight().toNullable()!;
    final users = usersResult.getRight().toNullable()!;
    final merged = List<UserIdentity>.from(fromDb);

    for (final u in users) {
      final phid = u.phorgePhid;
      if (phid == null || phid.isEmpty) continue;
      final exists = merged.any(
        (i) => i.userId == u.id && i.providerId.toLowerCase() == 'phorge',
      );
      if (!exists) {
        merged.add(
          UserIdentity(
            id: '${u.id}_phorge',
            userId: u.id,
            providerId: 'phorge',
            externalId: phid,
            status: UserIdentityStatus.linked,
            createdAt: u.createdAt,
          ),
        );
      }
    }

    return Right(merged);
  }
}
