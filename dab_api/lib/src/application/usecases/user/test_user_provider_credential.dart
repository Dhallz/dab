import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/contracts/ports/abs_i_provider_identity_probe.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Verifies stored or posted credentials without requiring a save.
class TestUserProviderCredential {
  TestUserProviderCredential(this._credentials, this._configs, this._probe);

  final AbsIUserProviderCredentialRepository _credentials;
  final AbsIProviderConfigRepository _configs;
  final AbsIProviderIdentityProbe _probe;

  Future<Either<Failure, void>> execute({
    required String userId,
    required String providerId,
    Map<String, dynamic>? settings,
  }) async {
    final id = providerId.trim().toLowerCase();
    if (!isKnownProviderId(id)) {
      return const Left(ValidationFailure('Unknown provider'));
    }
    final org = (await _configs.getConfigs())
        .getOrElse((_) => const <ProviderConfig>[])
        .where((c) => c.id == id)
        .firstOrNull;
    Map<String, dynamic> userSettings = settings ?? const {};
    if (userSettings.isEmpty) {
      final stored = await _credentials.get(userId: userId, providerId: id);
      userSettings = stored.getOrElse((_) => null)?.settings ?? const {};
    }
    final merged = overlayProviderSecrets(
      orgSettings: org?.settings ?? const {},
      userSettings: userSettings,
    );
    settings?.forEach((key, value) {
      if (value != null) merged[key] = value;
    });
    final result = await _probe.probe(
      providerId: id,
      settings: merged,
      orgConfig: org,
    );
    return result.fold((f) => Left(f), (_) => const Right(null));
  }
}
