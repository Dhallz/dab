import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/provider_credential_keys.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/user_identity_status.dart';
import '../../../domain/entities/user/user_provider_credential_status.dart';
import '../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/repositories/abs_i_user_provider_credential_repository.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists masked credential status for the calling user.
class ListUserProviderCredentials {
  ListUserProviderCredentials(
    this._credentials,
    this._users,
    this._configs,
  );

  final AbsIUserProviderCredentialRepository _credentials;
  final IUserRepository _users;
  final AbsIProviderConfigRepository _configs;

  Future<Either<Failure, List<UserProviderCredentialSummary>>> execute(
    String userId,
  ) async {
    final credsResult = await _credentials.listForUser(userId);
    if (credsResult.isLeft()) return Left(credsResult.getLeft().toNullable()!);
    final creds = credsResult.getOrElse((_) => []);
    final identities = (await _users.getIdentities(userId)).getOrElse((_) => []);
    final configs = (await _configs.getConfigs()).getOrElse((_) => const <ProviderConfig>[]);

    final byProvider = {for (final c in creds) c.providerId: c};
    final summaries = <UserProviderCredentialSummary>[];

    for (final providerId in {...kPatProviderIds, ...kBotProviderIds}) {
      final cred = byProvider[providerId];
      final identity = identities
          .where((i) => i.providerId == providerId)
          .firstOrNull;
      final org = configs.where((c) => c.id == providerId).firstOrNull;
      final orgHasBot = isBotSharedProvider(providerId) &&
          org != null &&
          hasRequiredProviderSecrets(providerId, org.settings);

      if (cred == null && !orgHasBot) continue;

      summaries.add(
        UserProviderCredentialSummary(
          providerId: providerId,
          status: cred?.status ?? UserProviderCredentialStatus.connected,
          hasSecret: cred != null || orgHasBot,
          isSharedBot: isBotSharedProvider(providerId),
          externalId: identity?.status == UserIdentityStatus.linked
              ? identity?.externalId
              : null,
          externalUsername: identity?.externalUsername,
          updatedAt: cred?.updatedAt ?? cred?.createdAt,
        ),
      );
    }
    return Right(summaries);
  }
}
