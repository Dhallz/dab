import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Removes a Dashboard object Follow pin for the caller.
class DeleteMyActivityFollow {
  final IUserRepository repository;

  DeleteMyActivityFollow(this.repository);

  Future<Either<AppFailure, void>> execute({
    required String providerId,
    required String objectKey,
  }) => repository.deleteMyActivityFollow(
    providerId: providerId,
    objectKey: objectKey,
  );
}
