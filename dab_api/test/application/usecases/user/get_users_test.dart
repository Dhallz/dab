import 'package:dab_api/src/application/usecases/user/get_users.dart';
import 'package:dab_api/src/domain/core/demo_teammate_spec.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockUsers extends Mock implements IUserRepository {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

void main() {
  late _MockUsers users;
  late _MockConfigs configs;
  late bool demoMode;

  GetUsers build() => GetUsers(
    users,
    configs: configs,
    isDemoMode: () => demoMode,
  );

  setUp(() {
    users = _MockUsers();
    configs = _MockConfigs();
    demoMode = false;
    when(() => users.getAllIdentities()).thenAnswer((_) async => const Right([]));
    when(() => configs.getConfigs()).thenAnswer((_) async => const Right([]));
  });

  test('returns real linked identities when mock is off', () async {
    final user = TestData.user(id: 'u-1');
    when(() => users.getUsers()).thenAnswer((_) async => Right([user]));
    when(() => users.getAllIdentities()).thenAnswer(
      (_) async => Right([
        UserIdentity(
          id: 'id-1',
          userId: 'u-1',
          providerId: 'github',
          externalId: 'gh-1',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.utc(2026),
        ),
      ]),
    );

    final result = await build().execute();
    final listed = result.getOrElse((_) => throw StateError('left'));

    expect(listed.single.linkedProviderIds, ['github']);
  });

  test('screenshot teammates appear connected even when mock is off', () async {
    final teammate = TestData.user(id: 'u-maya').copyWith(passwordHash: '');
    when(() => users.getUsers()).thenAnswer((_) async => Right([teammate]));

    final result = await build().execute();
    final listed = result.getOrElse((_) => throw StateError('left'));

    expect(
      listed.single.linkedProviderIds,
      [...kDemoLinkedProviderIds]..sort(),
    );
  });

  test('demo mode marks everyone connected to active providers', () async {
    demoMode = true;
    final caller = TestData.user(id: 'u-1');
    when(() => users.getUsers()).thenAnswer((_) async => Right([caller]));
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'jira',
          name: 'Jira',
          baseUrl: 'https://acme.atlassian.net',
        ),
        ProviderConfig(
          id: 'slack',
          name: 'Slack',
          baseUrl: 'https://slack.com',
          isActive: false,
        ),
      ]),
    );

    final result = await build().execute();
    final listed = result.getOrElse((_) => throw StateError('left'));

    expect(listed.single.linkedProviderIds, ['jira']);
  });
}
