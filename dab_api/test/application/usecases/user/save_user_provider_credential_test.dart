import 'package:dab_api/src/application/usecases/user/save_user_provider_credential.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/provider_whoami_result.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential.dart';
import 'package:dab_api/src/domain/entities/user/user_provider_credential_status.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_provider_credential_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/services/provider_identity_probe.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockCreds extends Mock
    implements AbsIUserProviderCredentialRepository {}

class _MockUsers extends Mock implements IUserRepository {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockProbe extends Mock implements ProviderIdentityProbe {}

void main() {
  late _MockCreds creds;
  late _MockUsers users;
  late _MockConfigs configs;
  late _MockProbe probe;
  late SaveUserProviderCredential useCase;

  final existingConfig = ProviderConfig(
    id: 'github',
    name: 'GitHub',
    baseUrl: 'https://github.com',
    isActive: true,
    settings: const {},
  );

  setUpAll(() {
    registerFallbackValue(
      UserProviderCredential(
        id: 'x',
        userId: 'u',
        providerId: 'github',
        status: UserProviderCredentialStatus.connected,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    registerFallbackValue(
      UserIdentity(
        id: 'x',
        userId: 'u',
        providerId: 'github',
        externalId: 'login',
        status: UserIdentityStatus.linked,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    registerFallbackValue(existingConfig);
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    creds = _MockCreds();
    users = _MockUsers();
    configs = _MockConfigs();
    probe = _MockProbe();
    useCase = SaveUserProviderCredential(creds, users, configs, probe);
  });

  test('whoami links identity immediately and discovers an empty watch list', () async {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([existingConfig]),
    );
    when(
      () => probe.probe(
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
        orgConfig: any(named: 'orgConfig'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        ProviderWhoamiResult(
          externalId: 'adal',
          externalUsername: 'adal',
          discoveredWatchList: ['acme/app'],
        ),
      ),
    );
    when(() => creds.get(userId: any(named: 'userId'), providerId: any(named: 'providerId')))
        .thenAnswer((_) async => const Right(null));
    when(() => creds.save(any())).thenAnswer((inv) async => Right(inv.positionalArguments.first as UserProviderCredential));
    when(() => users.linkIdentity(any())).thenAnswer(
      (inv) async => Right(inv.positionalArguments.first as UserIdentity),
    );
    when(() => configs.saveConfig(any())).thenAnswer(
      (inv) async => Right(inv.positionalArguments.first as ProviderConfig),
    );

    final result = await useCase.execute(
      userId: 'u-1',
      providerId: 'github',
      settings: const {'api.token': 'ghp_test'},
    );
    expect(result.isRight(), isTrue);
    final summary = result.getOrElse((l) => throw StateError(l.message));
    expect(summary.externalUsername, 'adal');
    expect(summary.hasSecret, isTrue);

    final savedIdentity = verify(() => users.linkIdentity(captureAny()))
        .captured
        .single as UserIdentity;
    expect(savedIdentity.status, UserIdentityStatus.linked);
    expect(savedIdentity.externalId, 'adal');

    final savedConfig = verify(() => configs.saveConfig(captureAny()))
        .captured
        .single as ProviderConfig;
    expect(savedConfig.isActive, isTrue);
    expect(savedConfig.settings['repos'], ['acme/app']);
  });

  test('rejects an empty token', () async {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([existingConfig]),
    );
    when(
      () => probe.probe(
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
        orgConfig: any(named: 'orgConfig'),
      ),
    ).thenAnswer(
      (_) async => const Left(
        ValidationFailure('Missing required credentials for this provider'),
      ),
    );

    final result = await useCase.execute(
      userId: 'u-1',
      providerId: 'github',
      settings: const {'api.token': ''},
    );
    expect(result.isLeft(), isTrue);
    verifyNever(() => creds.save(any()));
  });

  test('Slack bot token writes through to ProviderConfig', () async {
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'slack',
          name: 'Slack',
          baseUrl: 'https://slack.com',
          isActive: false,
          settings: const {},
        ),
      ]),
    );
    when(
      () => probe.probe(
        providerId: any(named: 'providerId'),
        settings: any(named: 'settings'),
        orgConfig: any(named: 'orgConfig'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        ProviderWhoamiResult(
          externalId: 'T123',
          externalUsername: 'acme',
        ),
      ),
    );
    when(() => creds.save(any())).thenAnswer(
      (inv) async => Right(inv.positionalArguments.first as UserProviderCredential),
    );
    when(() => configs.saveConfig(any())).thenAnswer(
      (inv) async => Right(inv.positionalArguments.first as ProviderConfig),
    );

    final result = await useCase.execute(
      userId: 'u-1',
      providerId: 'slack',
      settings: const {
        'botToken': 'xoxb-test',
        'channels': ['C1'],
      },
    );
    expect(result.isRight(), isTrue);
    final summary = result.getOrElse((l) => throw StateError(l.message));
    expect(summary.isSharedBot, isTrue);

    final savedConfig = verify(() => configs.saveConfig(captureAny()))
        .captured
        .single as ProviderConfig;
    expect(savedConfig.isActive, isTrue);
    expect(savedConfig.settings['botToken'], 'xoxb-test');
    expect(savedConfig.settings['channels'], ['C1']);
    verify(() => creds.save(any())).called(1);
    verifyNever(() => users.linkIdentity(any()));
  });
}
