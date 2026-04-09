import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failure.dart';
import '../../../domain/entities/user_identity.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Fetches all platform identities for administrative review.
/// CONTRACT: Returns a list of all identity couplings (Linked & Pending).
class GetAllIdentities {
  final IUserRepository _userRepository;

  GetAllIdentities(this._userRepository);

  Future<Either<DatabaseFailure, List<UserIdentity>>> execute() async {
    return _userRepository.getAllIdentities();
  }
}
