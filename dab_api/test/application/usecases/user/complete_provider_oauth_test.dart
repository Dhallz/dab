import 'package:dab_api/src/application/usecases/user/complete_provider_oauth.dart';
import 'package:dab_api/src/application/usecases/user/save_user_provider_credential.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/core/oauth_providers.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/oauth_state_payload.dart';
import 'package:dab_api/src/domain/entities/user/oauth_token_response.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential_status.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential_summary.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_oauth_client_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_oauth_state_store.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_oauth_token_client.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockStore extends Mock implements AbsIOauthStateStore {}

class _MockTokens extends Mock implements AbsIOauthTokenClient {}

class _MockApps extends Mock implements AbsIOauthClientCredentialResolver {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockSave extends Mock implements SaveUserProviderCredential {}

void main() {
  late _MockStore store;
  late _MockTokens tokens;
  late _MockApps apps;
  late _MockConfigs configs;
  late _MockSave save;
  late CompleteProviderOauth useCase;

  const payload = OauthStatePayload(
    userId: 'user-42',
    providerId: 'github',
    codeVerifier: 'verifier-1',
    redirectUri: 'https://dab.example/integrations/github/oauth/callback',
  );

  final summary = UserProviderCredentialSummary(
    providerId: 'github',
    status: UserProviderCredentialStatus.connected,
    hasSecret: true,
    externalId: 'octocat',
    externalUsername: 'octocat',
    updatedAt: DateTime.utc(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(
      const OauthProviderSpec(
        providerId: 'github',
        authorizeUrl: 'https://example/auth',
        tokenUrl: 'https://example/token',
        scopes: ['repo'],
        accessTokenSettingKey: 'api.token',
      ),
    );
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    store = _MockStore();
    tokens = _MockTokens();
    apps = _MockApps();
    configs = _MockConfigs();
    save = _MockSave();
    useCase = CompleteProviderOauth(store, tokens, apps, configs, save);
  });

  test('callback for a different provider does not consume the token', () async {
    when(() => store.take('state-1')).thenAnswer((_) async => payload);
    final result = await useCase.execute(
      providerId: 'gitlab',
      code: 'abc',
      state: 'state-1',
    );
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    verifyNever(
      () => save.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
      ),
    );
  });

  test('wrong or missing state is a validation failure', () async {
    when(() => store.take('bad')).thenAnswer((_) async => null);
    final result = await useCase.execute(
      providerId: 'github',
      code: 'abc',
      state: 'bad',
    );
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    verifyNever(
      () => save.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
      ),
    );
  });

  test('GitHub callback saves encrypted token for the state user', () async {
    when(() => store.take('state-1')).thenAnswer((_) async => payload);
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
          isActive: true,
        ),
      ]),
    );
    when(
      () => apps.resolve(
        providerId: 'github',
        orgSettings: any(named: 'orgSettings'),
      ),
    ).thenReturn(const OauthAppCredentials(clientId: 'cid', clientSecret: 'sec'));
    when(
      () => tokens.exchangeAuthorizationCode(
        spec: any(named: 'spec'),
        clientId: any(named: 'clientId'),
        clientSecret: any(named: 'clientSecret'),
        code: any(named: 'code'),
        redirectUri: any(named: 'redirectUri'),
        codeVerifier: any(named: 'codeVerifier'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        OauthTokenResponse(accessToken: 'gho_secret', refreshToken: null),
      ),
    );
    when(
      () => save.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
      ),
    ).thenAnswer((_) async => Right(summary));

    final result = await useCase.execute(
      providerId: 'github',
      code: 'code-1',
      state: 'state-1',
    );
    expect(result.getRight().toNullable()?.externalUsername, 'octocat');

    final captured = verify(
      () => save.execute(
        userId: 'user-42',
        providerId: 'github',
        settings: captureAny(named: 'settings'),
      ),
    ).captured.single as Map<String, dynamic>;
    expect(captured['api.token'], 'gho_secret');
    expect(captured['tokenType'], 'oauth');
  });

  test('Linear callback maps the access token onto apiKey', () async {
    when(() => store.take('state-1')).thenAnswer(
      (_) async => const OauthStatePayload(
        userId: 'user-42',
        providerId: 'linear',
        codeVerifier: 'verifier-1',
        redirectUri: 'https://dab.example/integrations/linear/oauth/callback',
      ),
    );
    when(() => configs.getConfigs()).thenAnswer((_) async => const Right([]));
    when(
      () => apps.resolve(
        providerId: 'linear',
        orgSettings: any(named: 'orgSettings'),
      ),
    ).thenReturn(const OauthAppCredentials(clientId: 'cid'));
    when(
      () => tokens.exchangeAuthorizationCode(
        spec: any(named: 'spec'),
        clientId: any(named: 'clientId'),
        clientSecret: any(named: 'clientSecret'),
        code: any(named: 'code'),
        redirectUri: any(named: 'redirectUri'),
        codeVerifier: any(named: 'codeVerifier'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        OauthTokenResponse(accessToken: 'lin_oauth', refreshToken: 'ref'),
      ),
    );
    when(
      () => save.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
      ),
    ).thenAnswer(
      (_) async => Right(
        UserProviderCredentialSummary(
          providerId: 'linear',
          status: UserProviderCredentialStatus.connected,
          hasSecret: true,
        ),
      ),
    );

    await useCase.execute(
      providerId: 'linear',
      code: 'code-1',
      state: 'state-1',
    );
    final captured = verify(
      () => save.execute(
        userId: 'user-42',
        providerId: 'linear',
        settings: captureAny(named: 'settings'),
      ),
    ).captured.single as Map<String, dynamic>;
    expect(captured['apiKey'], 'lin_oauth');
    expect(captured['refreshToken'], 'ref');
  });

  test('Jira callback stores cloudId from accessible-resources', () async {
    when(() => store.take('state-1')).thenAnswer(
      (_) async => const OauthStatePayload(
        userId: 'user-42',
        providerId: 'jira',
        codeVerifier: 'verifier-1',
        redirectUri: 'https://dab.example/integrations/jira/oauth/callback',
      ),
    );
    when(() => configs.getConfigs()).thenAnswer((_) async => const Right([]));
    when(
      () => apps.resolve(
        providerId: 'jira',
        orgSettings: any(named: 'orgSettings'),
      ),
    ).thenReturn(const OauthAppCredentials(clientId: 'cid', clientSecret: 'sec'));
    when(
      () => tokens.exchangeAuthorizationCode(
        spec: any(named: 'spec'),
        clientId: any(named: 'clientId'),
        clientSecret: any(named: 'clientSecret'),
        code: any(named: 'code'),
        redirectUri: any(named: 'redirectUri'),
        codeVerifier: any(named: 'codeVerifier'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        OauthTokenResponse(accessToken: 'atlassian_token'),
      ),
    );
    when(
      () => tokens.getJsonList(
        any(),
        headers: any(named: 'headers'),
      ),
    ).thenAnswer(
      (_) async => const Right([
        {
          'id': 'cloud-123',
          'url': 'https://acme.atlassian.net',
          'name': 'Acme',
        },
      ]),
    );
    when(
      () => save.execute(
        userId: any(named: 'userId'),
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
      ),
    ).thenAnswer(
      (_) async => Right(
        UserProviderCredentialSummary(
          providerId: 'jira',
          status: UserProviderCredentialStatus.connected,
          hasSecret: true,
        ),
      ),
    );

    await useCase.execute(
      providerId: 'jira',
      code: 'code-1',
      state: 'state-1',
    );
    final captured = verify(
      () => save.execute(
        userId: 'user-42',
        providerId: 'jira',
        settings: captureAny(named: 'settings'),
      ),
    ).captured.single as Map<String, dynamic>;
    expect(captured['apiToken'], 'atlassian_token');
    expect(captured['cloudId'], 'cloud-123');
    expect(captured['instanceUrl'], 'https://acme.atlassian.net');
    expect(captured['tokenType'], 'oauth');
  });
}
