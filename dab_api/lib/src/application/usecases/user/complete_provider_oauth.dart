import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/oauth_providers.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/user_provider_credential_summary.dart';
import '../../../domain/contracts/ports/abs_i_oauth_client_credential_resolver.dart';
import '../../../domain/contracts/ports/abs_i_oauth_state_store.dart';
import '../../../domain/contracts/ports/abs_i_oauth_token_client.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'save_user_provider_credential.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Completes OAuth callback — exchanges code, stores encrypted credential.
class CompleteProviderOauth {
  CompleteProviderOauth(
    this._stateStore,
    this._tokenClient,
    this._credentials,
    this._configs,
    this._save,
  );

  final AbsIOauthStateStore _stateStore;
  final AbsIOauthTokenClient _tokenClient;
  final AbsIOauthClientCredentialResolver _credentials;
  final AbsIProviderConfigRepository _configs;
  final SaveUserProviderCredential _save;

  Future<Either<Failure, UserProviderCredentialSummary>> execute({
    required String providerId,
    required String code,
    required String state,
  }) async {
    final id = providerId.trim().toLowerCase();
    if (!id.isOauthUserProvider) {
      return const Left(ValidationFailure('Unknown OAuth provider'));
    }
    if (code.trim().isEmpty || state.trim().isEmpty) {
      return const Left(ValidationFailure('Missing OAuth code or state'));
    }

    final payload = await _stateStore.take(state.trim());
    if (payload == null) {
      return const Left(ValidationFailure('OAuth state is invalid or expired'));
    }
    if (payload.providerId != id) {
      return const Left(ValidationFailure('OAuth state does not match provider'));
    }

    final configsResult = await _configs.getConfigs();
    final orgConfig = configsResult
        .getOrElse((_) => const <ProviderConfig>[])
        .where((c) => c.id == id)
        .firstOrNull;
    final instanceUrl = (orgConfig?.settings['instanceUrl'] ??
            orgConfig?.baseUrl ??
            '')
        .toString();
    final spec = id.oauthSpecFor(instanceUrl: instanceUrl);
    if (spec == null) {
      return const Left(ValidationFailure('Unknown OAuth provider'));
    }

    final apps = _credentials.resolve(
      providerId: id,
      orgSettings: orgConfig?.settings ?? const {},
    );
    if (apps == null) {
      return const Left(ValidationFailure('OAuth app is not configured'));
    }

    final tokenResult = await _tokenClient.exchangeAuthorizationCode(
      spec: spec,
      clientId: apps.clientId,
      clientSecret: apps.clientSecret,
      code: code.trim(),
      redirectUri: payload.redirectUri,
      codeVerifier: payload.codeVerifier,
    );
    if (tokenResult.isLeft()) {
      return Left(tokenResult.getLeft().toNullable()!);
    }
    final tokens = tokenResult.getOrElse((l) => throw StateError(l.message));

    final settings = <String, dynamic>{
      spec.accessTokenSettingKey: tokens.accessToken,
      'tokenType': 'oauth',
    };
    if (tokens.refreshToken != null) {
      settings['refreshToken'] = tokens.refreshToken;
    }
    if (tokens.expiresIn != null) {
      settings['tokenExpiresAt'] = DateTime.now()
          .toUtc()
          .add(Duration(seconds: tokens.expiresIn!))
          .toIso8601String();
    }

    if (id == 'jira') {
      final resources = await _tokenClient.getJsonList(
        Uri.parse('https://api.atlassian.com/oauth/token/accessible-resources'),
        headers: {
          'Authorization': 'Bearer ${tokens.accessToken}',
          'Accept': 'application/json',
        },
      );
      if (resources.isLeft()) {
        return Left(resources.getLeft().toNullable()!);
      }
      final list = resources.getOrElse((l) => throw StateError(l.message));
      if (list.isEmpty) {
        return const Left(
          ValidationFailure('No Jira Cloud sites are accessible for this account'),
        );
      }
      final first = list.first;
      final cloudId = (first['id'] ?? '').toString().trim();
      final siteUrl = (first['url'] ?? '').toString().trim();
      if (cloudId.isEmpty) {
        return const Left(ValidationFailure('Jira Cloud site id was missing'));
      }
      settings['cloudId'] = cloudId;
      if (siteUrl.isNotEmpty) {
        settings['instanceUrl'] = siteUrl;
      }
    }

    if (id == 'gitlab' && instanceUrl.trim().isNotEmpty) {
      settings['instanceUrl'] = instanceUrl.trim();
    }

    return _save.execute(
      userId: payload.userId,
      providerId: id,
      settings: settings,
    );
  }
}
