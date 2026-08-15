import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USE_CASE]
/// ROLE: Orchestrates the linking of a DAB User to an external provider identity.
/// CONTRACT: Validates the request and persists the mapping via the repository.
class LinkUserIdentity {
  final IUserRepository _userRepository;

  LinkUserIdentity(this._userRepository);

  Future<Either<DatabaseFailure, UserIdentity>> execute({
    required String userId,
    required String providerId,
    required String externalId,
    String? externalUsername,
  }) async {
    final identity = UserIdentity(
      id: '${userId}_$providerId',
      userId: userId,
      providerId: providerId,
      externalId: externalId,
      externalUsername: externalUsername?.trim().isEmpty == true
          ? null
          : externalUsername?.trim(),
      status: UserIdentityStatus.linked,
      createdAt: DateTime.now(),
    );

    return _userRepository.linkIdentity(identity);
  }
}
