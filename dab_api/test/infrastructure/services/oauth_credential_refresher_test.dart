import 'package:dab_api/src/domain/core/oauth_providers.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/oauth_token_response.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential_status.dart';
import 'package:dab_api/src/domain/ports/i_oauth_client_credential_resolver.dart';
import 'package:dab_api/src/domain/ports/i_oauth_token_client.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_provider_credential_repository.dart';
import 'package:dab_api/src/infrastructure/services/oauth_credential_refresher.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCreds extends Mock implements AbsIUserProviderCredentialRepository {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockApps extends Mock implements IOauthClientCredentialResolver {}

class _MockTokens extends Mock implements IOauthTokenClient {}

void main() {
  late _MockCreds creds;
  late _MockConfigs configs;
  late _MockApps apps;
  late _MockTokens tokens;
  late OauthCredentialRefresher refresher;
  var now = DateTime.utc(2026, 8, 14, 20);

  final row = UserProviderCredential(
    id: 'u1_jira',
    userId: 'u1',
    providerId: 'jira',
    settings: {
      'apiToken': 'old-access',
      'refreshToken': 'refresh-1',
      'tokenType': 'oauth',
      'cloudId': 'cloud-1',
      'tokenExpiresAt': DateTime.utc(2026, 8, 14, 18).toIso8601String(),
    },
    status: UserProviderCredentialStatus.connected,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final jiraConfig = ProviderConfig(
    id: 'jira',
    name: 'Jira',
    baseUrl: 'https://acme.atlassian.net',
    isActive: true,
    settings: const {'clientId': 'cid', 'clientSecret': 'secret'},
  );

  setUpAll(() {
    registerFallbackValue(row);
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(
      const OauthProviderSpec(
        providerId: 'jira',
        authorizeUrl: 'https://auth.atlassian.com/authorize',
        tokenUrl: 'https://auth.atlassian.com/oauth/token',
        scopes: ['read:jira-work'],
        accessTokenSettingKey: 'apiToken',
        tokenRequestJson: true,
      ),
    );
  });

  setUp(() {
    creds = _MockCreds();
    configs = _MockConfigs();
    apps = _MockApps();
    tokens = _MockTokens();
    now = DateTime.utc(2026, 8, 14, 20);
    refresher = OauthCredentialRefresher(
      creds,
      configs,
      apps,
      tokens,
      now: () => now,
    );
    when(
      () => creds.get(userId: any(named: 'userId'), providerId: any(named: 'providerId')),
    ).thenAnswer((_) async => Right(row));
    when(() => configs.getConfigs()).thenAnswer((_) async => Right([jiraConfig]));
    when(
      () => apps.resolve(
        providerId: any(named: 'providerId'),
        orgSettings: any(named: 'orgSettings'),
      ),
    ).thenReturn(const OauthAppCredentials(clientId: 'cid', clientSecret: 'secret'));
    when(() => creds.save(any())).thenAnswer(
      (inv) async => Right(inv.positionalArguments.first as UserProviderCredential),
    );
  });

  test('returns stored settings when the access token is still fresh', () async {
    final fresh = UserProviderCredential(
      id: row.id,
      userId: row.userId,
      providerId: row.providerId,
      settings: {
        ...row.settings,
        'tokenExpiresAt': DateTime.utc(2026, 8, 14, 22).toIso8601String(),
      },
      status: row.status,
      createdAt: row.createdAt,
    );
    when(
      () => creds.get(userId: any(named: 'userId'), providerId: any(named: 'providerId')),
    ).thenAnswer((_) async => Right(fresh));

    final result = await refresher.ensureFresh(userId: 'u1', providerId: 'jira');
    expect(result.getOrElse((l) => throw StateError(l.message))['apiToken'], 'old-access');
    verifyNever(
      () => tokens.refreshAccessToken(
        spec: any(named: 'spec'),
        clientId: any(named: 'clientId'),
        clientSecret: any(named: 'clientSecret'),
        refreshToken: any(named: 'refreshToken'),
      ),
    );
  });

  test('refreshes an expired Jira access token and persists it', () async {
    when(
      () => tokens.refreshAccessToken(
        spec: any(named: 'spec'),
        clientId: any(named: 'clientId'),
        clientSecret: any(named: 'clientSecret'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        OauthTokenResponse(
          accessToken: 'new-access',
          refreshToken: 'refresh-2',
          expiresIn: 3600,
        ),
      ),
    );

    final result = await refresher.ensureFresh(userId: 'u1', providerId: 'jira');
    final settings = result.getOrElse((l) => throw StateError(l.message));
    expect(settings['apiToken'], 'new-access');
    expect(settings['refreshToken'], 'refresh-2');

    final saved = verify(() => creds.save(captureAny())).captured.single
        as UserProviderCredential;
    expect(saved.settings['apiToken'], 'new-access');
    expect(saved.settings['cloudId'], 'cloud-1');
  });

  test('asks the user to reconnect when refresh is impossible', () async {
    final expiredNoRefresh = UserProviderCredential(
      id: row.id,
      userId: row.userId,
      providerId: row.providerId,
      settings: {
        'apiToken': 'old-access',
        'tokenType': 'oauth',
        'cloudId': 'cloud-1',
        'tokenExpiresAt': DateTime.utc(2026, 8, 14, 18).toIso8601String(),
      },
      status: row.status,
      createdAt: row.createdAt,
    );
    when(
      () => creds.get(userId: any(named: 'userId'), providerId: any(named: 'providerId')),
    ).thenAnswer((_) async => Right(expiredNoRefresh));

    final result = await refresher.ensureFresh(userId: 'u1', providerId: 'jira');
    expect(result.getLeft().toNullable()?.message, contains('expired'));
  });
}
