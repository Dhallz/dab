import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USE_CASE]
/// ROLE: Permanently removes a provider identity link from `user_identities`.
/// CONTRACT: Deletes by primary key [identityId]; returns [NotFoundFailure] when absent.
class DeleteUserIdentity {
  final IUserRepository _userRepository;

  DeleteUserIdentity(this._userRepository);

  Future<Either<Failure, void>> execute({required String identityId}) {
    return _userRepository.deleteIdentity(identityId);
  }
}
