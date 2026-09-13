import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Starts browser OAuth for a provider and returns the authorize URL.
class StartMyOauth {
  final IUserRepository repository;

  StartMyOauth(this.repository);

  Future<Either<AppFailure, String>> execute({required String providerId}) =>
      repository.startMyOauth(providerId: providerId);
}
