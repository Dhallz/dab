import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Removes the calling user's provider credential.
class DeleteUserProviderCredential {
  DeleteUserProviderCredential(this._credentials, this._configs);

  final AbsIUserProviderCredentialRepository _credentials;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, void>> execute({
    required String userId,
    required String providerId,
  }) async {
    final id = providerId.trim().toLowerCase();
    final deleted = await _credentials.delete(userId: userId, providerId: id);
    if (deleted.isLeft()) return deleted;

    if (id.isBotSharedProvider) {
      final remaining = await _credentials.listForProvider(id);
      final others = remaining.getOrElse((_) => []);
      if (others.isEmpty) {
        final configs = (await _configs.getConfigs()).getOrElse(
          (_) => const <ProviderConfig>[],
        );
        final org = configs.where((c) => c.id == id).firstOrNull;
        if (org != null) {
          final next = Map<String, dynamic>.from(org.settings)
            ..remove('botToken')
            ..remove('token');
          await _configs.saveConfig(org.copyWith(settings: next));
        }
      }
    }
    return const Right(null);
  }
}
