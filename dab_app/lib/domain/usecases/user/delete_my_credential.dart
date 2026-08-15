import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Disconnects the signed-in user's provider credential.
class DeleteMyCredential {
  final IUserRepository repository;

  DeleteMyCredential(this.repository);

  Future<Either<AppFailure, void>> execute({required String providerId}) =>
      repository.deleteMyCredential(providerId: providerId);
}
