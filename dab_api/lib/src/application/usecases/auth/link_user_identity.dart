import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import '../../../domain/entities/user_identity.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

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
  }) async {
    final identity = UserIdentity(
      id: '${userId}_$providerId', // Simple composite ID or UUID
      userId: userId,
      providerId: providerId,
      externalId: externalId,
      status: 'Linked',
      createdAt: DateTime.now(),
    );

    return _userRepository.linkIdentity(identity);
  }
}
