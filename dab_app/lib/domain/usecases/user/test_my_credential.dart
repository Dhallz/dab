import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Tests a self-serve provider credential without persisting unless saved.
class TestMyCredential {
  final IUserRepository repository;

  TestMyCredential(this.repository);

  Future<Either<AppFailure, void>> execute({
    required String providerId,
    Map<String, dynamic>? settings,
  }) =>
      repository.testMyCredential(
        providerId: providerId,
        settings: settings,
      );
}
