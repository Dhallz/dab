import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Lists masked provider credential status for the signed-in user.
class ListMyCredentials {
  final IUserRepository repository;

  ListMyCredentials(this.repository);

  Future<Either<AppFailure, List<UserProviderCredentialSummary>>> execute() =>
      repository.listMyCredentials();
}
