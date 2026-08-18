import 'package:dab_api/src/application/usecases/user/start_provider_oauth.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/oauth_state_payload.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_oauth_client_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_oauth_pkce.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_oauth_state_store.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_system_settings_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockSettings extends Mock implements AbsISystemSettingsRepository {}

class _MockStore extends Mock implements AbsIOauthStateStore {}

class _MockApps extends Mock implements AbsIOauthClientCredentialResolver {}

class _FakePkce implements AbsIOauthPkce {
  @override
  String generateStateId() => 'state-1';

  @override
  String generateVerifier() => 'verifier-1';

  @override
  String challengeS256(String verifier) => 'challenge-1';
}

void main() {
  late _MockConfigs configs;
  late _MockSettings settings;
  late _MockStore store;
  late _MockApps apps;
  late StartProviderOauth useCase;

  setUpAll(() {
    registerFallbackValue(
      const OauthStatePayload(
        userId: 'u',
        providerId: 'github',
        codeVerifier: 'v',
        redirectUri: 'https://example/cb',
      ),
    );
  });

  setUp(() {
    configs = _MockConfigs();
    settings = _MockSettings();
    store = _MockStore();
    apps = _MockApps();
    useCase = StartProviderOauth(configs, settings, store, apps, _FakePkce());
  });

  test('rejects unknown providers', () async {
    final result = await useCase.execute(userId: 'u1', providerId: 'phorge');
    expect(result.isLeft(), isTrue);
    verifyNever(() => store.put(any(), any()));
  });

  test('requires an OAuth client id', () async {
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
    ).thenReturn(null);

    final result = await useCase.execute(userId: 'u1', providerId: 'github');
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
  });

  test('stores PKCE state bound to the caller and returns authorize URL', () async {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
          isActive: true,
          settings: const {'clientId': 'cid'},
        ),
      ]),
    );
    when(
      () => apps.resolve(
        providerId: 'github',
        orgSettings: any(named: 'orgSettings'),
      ),
    ).thenReturn(const OauthAppCredentials(clientId: 'cid'));
    when(() => settings.getSetting('public_api_url')).thenAnswer(
      (_) async => const Right('https://dab.example'),
    );
    when(() => store.put(any(), any())).thenAnswer((_) async {});

    final result = await useCase.execute(userId: 'user-42', providerId: 'github');
    final url = result.getOrElse((l) => throw StateError(l.message));
    expect(url, contains('client_id=cid'));
    expect(url, contains('state=state-1'));
    expect(url, contains('code_challenge=challenge-1'));
    expect(url, isNot(contains('verifier-1')));

    final captured = verify(() => store.put('state-1', captureAny())).captured;
    final payload = captured.single as OauthStatePayload;
    expect(payload.userId, 'user-42');
    expect(payload.providerId, 'github');
    expect(payload.codeVerifier, 'verifier-1');
    expect(
      payload.redirectUri,
      'https://dab.example/integrations/github/oauth/callback',
    );
  });
}
