import 'package:fpdart/fpdart.dart';

import '../core/failures/failure.dart';
import '../entities/user/user_provider_credential.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Persistence for per-user provider credentials.
/// CONSTRAINTS: Implementation encrypts [UserProviderCredential.settings] at rest.
abstract interface class AbsIUserProviderCredentialRepository {
  Future<Either<Failure, UserProviderCredential?>> get({
    required String userId,
    required String providerId,
  });

  Future<Either<Failure, List<UserProviderCredential>>> listForUser(
    String userId,
  );

  Future<Either<Failure, List<UserProviderCredential>>> listForProvider(
    String providerId,
  );

  Future<Either<Failure, UserProviderCredential>> save(
    UserProviderCredential credential,
  );

  Future<Either<Failure, void>> delete({
    required String userId,
    required String providerId,
  });
}
