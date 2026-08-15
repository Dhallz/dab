import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/oauth_providers.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/user/oauth_state_payload.dart';
import '../../../domain/contracts/ports/i_oauth_client_credential_resolver.dart';
import '../../../domain/contracts/ports/i_oauth_pkce.dart';
import '../../../domain/contracts/ports/i_oauth_state_store.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Builds a provider authorize URL and stores PKCE state for the caller.
class StartProviderOauth {
  StartProviderOauth(
    this._configs,
    this._settings,
    this._stateStore,
    this._credentials,
    this._pkce,
  );

  final AbsIProviderConfigRepository _configs;
  final ISystemSettingsRepository _settings;
  final IOauthStateStore _stateStore;
  final IOauthClientCredentialResolver _credentials;
  final IOauthPkce _pkce;

  Future<Either<Failure, String>> execute({
    required String userId,
    required String providerId,
  }) async {
    final id = providerId.trim().toLowerCase();
    if (!isOauthUserProvider(id)) {
      return const Left(
        ValidationFailure('This provider does not support OAuth connect'),
      );
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
    final spec = oauthSpecFor(id, instanceUrl: instanceUrl);
    if (spec == null) {
      return const Left(ValidationFailure('Unknown OAuth provider'));
    }

    final apps = _credentials.resolve(
      providerId: id,
      orgSettings: orgConfig?.settings ?? const {},
    );
    if (apps == null || apps.clientId.isEmpty) {
      return const Left(
        ValidationFailure(
          'OAuth app is not configured. An admin must save a client ID in Providers.',
        ),
      );
    }

    final publicResult = await _settings.getSetting('public_api_url');
    final publicBase = publicResult
        .getOrElse((_) => null)
        ?.trim()
        .replaceAll(RegExp(r'/+$'), '');
    if (publicBase == null || publicBase.isEmpty) {
      return const Left(
        ValidationFailure(
          'public_api_url is not set. An admin must save it under Security.',
        ),
      );
    }

    final redirectUri = '$publicBase/integrations/$id/oauth/callback';
    final stateId = _pkce.generateStateId();
    final verifier = _pkce.generateVerifier();
    await _stateStore.put(
      stateId,
      OauthStatePayload(
        userId: userId,
        providerId: id,
        codeVerifier: verifier,
        redirectUri: redirectUri,
      ),
    );

    final params = <String, String>{
      'client_id': apps.clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'state': stateId,
      'scope': spec.scopes.join(' '),
      ...spec.extraAuthorizeParams,
    };
    if (spec.usePkce) {
      params['code_challenge'] = _pkce.challengeS256(verifier);
      params['code_challenge_method'] = 'S256';
    }

    final authorize = Uri.parse(spec.authorizeUrl).replace(
      queryParameters: {
        ...Uri.parse(spec.authorizeUrl).queryParameters,
        ...params,
      },
    );
    return Right(authorize.toString());
  }
}
