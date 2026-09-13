import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Saves a self-serve provider credential (PAT or workspace bot token).
class SaveMyCredential {
  final IUserRepository repository;

  SaveMyCredential(this.repository);

  Future<Either<AppFailure, UserProviderCredentialSummary>> execute({
    required String providerId,
    required Map<String, dynamic> settings,
  }) =>
      repository.saveMyCredential(
        providerId: providerId,
        settings: settings,
      );
}
