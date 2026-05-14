import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_identity.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USE_CASE]
/// ROLE: Resolves a pending identity discovery (Approve/Reject).
/// CONTRACT: Updates the status of an existing discovery candidate.
class ResolveUserIdentity {
  final IUserRepository _userRepository;

  ResolveUserIdentity(this._userRepository);

  /// Approves or rejects a candidate identity.
  ///
  /// [status] should be [UserIdentityStatus.linked] or [UserIdentityStatus.failed].
  Future<Either<DatabaseFailure, UserIdentity>> execute({
    required String userId,
    required String providerId,
    required UserIdentityStatus status,
  }) async {
    final existingResult = await _userRepository.getIdentity(
      userId,
      providerId,
    );

    return existingResult.fold((failure) => Left(failure), (identity) async {
      if (identity == null) {
        return Left(
          DatabaseFailure('Identity not found for user $userId on $providerId'),
        );
      }

      final updatedIdentity = identity.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      return _userRepository.linkIdentity(updatedIdentity);
    });
  }
}
