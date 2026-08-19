import 'dart:async';

import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_activity_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../test_factories.dart';

class _MockProviderConfigRepo extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepo extends Mock implements IUserRepository {}

class _DelayedSource implements AbsIActivitySource<String> {
  _DelayedSource(this._onFetch);
  final Future<List<String>> Function() _onFetch;

  @override
  Future<List<String>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) {
    return _onFetch();
  }
}

class _FakeSource implements AbsIActivitySource<String> {
  List<User> lastUsers = [];

  @override
  Future<List<String>> fetchRawData(
    List<User> users,
    DateTime start,
    DateTime end,
    bool authoredOnly,
  ) async {
    lastUsers = users;
    return const ['raw'];
  }
}

List<Activity> _fakeGithubMapRow(Object? data, List<User> users) {
  expect(data, 'raw');
  final user = users.first;
  return [
    Activity(
      id: 'a-1',
      userId: user.id,
      provider: const GenericProvider(name: 'GitHub', category: 'commit'),
      title: 'mapped',
      content: data! as String,
      authorName: user.name,
      createdAt: DateTime.utc(2026, 1, 1),
    ),
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String>[]);
  });

  late _MockProviderConfigRepo configRepo;
  late _MockUserRepo userRepo;
  late ConnectorRegistry registry;
  late _FakeSource source;
  late UnifiedActivityFetcher sut;

  setUp(() {
    configRepo = _MockProviderConfigRepo();
    userRepo = _MockUserRepo();
    source = _FakeSource();
    registry = ConnectorRegistry()
      ..register<String>(
        TypedConnectorPair<String>(
          source: source,
          providerId: 'github',
          mapItemToActivities: _fakeGithubMapRow,
        ),
      );
    sut = UnifiedActivityFetcher(
      registry,
      configRepo,
      userRepo,
      (_, {String level = 'INFO', Map<String, dynamic>? extra}) {},
    );
  });

  test('filters users per provider by linked identities', () async {
    final user1 = TestData.user(id: 'u-1');
    final user2 = TestData.user(id: 'u-2');

    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
        ),
      ]),
    );
    when(
      () => userRepo.getIdentitiesForUsersAndProvider(any(), 'github'),
    ).thenAnswer(
      (_) async => Right([
        UserIdentity(
          id: 'i-1',
          userId: 'u-1',
          providerId: 'github',
          externalId: 'alice',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ]),
    );

    final activities = await sut.fetchAll(
      users: [user1, user2],
      start: DateTime.utc(2026, 1, 1),
      end: DateTime.utc(2026, 1, 2),
      authoredOnly: true,
    );

    expect(source.lastUsers.map((u) => u.id), ['u-1']);
    expect(activities.map((a) => a.userId), ['u-1']);
  });

  test('skips connector when no linked identity exists', () async {
    final user = TestData.user(id: 'u-1');

    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
        ),
      ]),
    );
    when(
      () => userRepo.getIdentitiesForUsersAndProvider(any(), 'github'),
    ).thenAnswer((_) async => const Right([]));

    final activities = await sut.fetchAll(
      users: [user],
      start: DateTime.utc(2026, 1, 1),
      end: DateTime.utc(2026, 1, 2),
      authoredOnly: false,
    );

    expect(source.lastUsers, isEmpty);
    expect(activities, isEmpty);
  });

  test('shares one connector poll across concurrent fetchAll', () async {
    final user = TestData.user(id: 'u-1');
    final gate = Completer<void>();
    var calls = 0;
    final delayed = _DelayedSource(() async {
      calls++;
      await gate.future;
      return const ['raw'];
    });
    registry = ConnectorRegistry()
      ..register<String>(
        TypedConnectorPair<String>(
          source: delayed,
          providerId: 'github',
          mapItemToActivities: _fakeGithubMapRow,
        ),
      );
    sut = UnifiedActivityFetcher(
      registry,
      configRepo,
      userRepo,
      (_, {String level = 'INFO', Map<String, dynamic>? extra}) {},
    );

    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
        ),
      ]),
    );
    when(
      () => userRepo.getIdentitiesForUsersAndProvider(any(), 'github'),
    ).thenAnswer(
      (_) async => Right([
        UserIdentity(
          id: 'i-1',
          userId: 'u-1',
          providerId: 'github',
          externalId: 'alice',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ]),
    );

    final first = sut.fetchAll(
      users: [user],
      start: DateTime.utc(2026, 1, 1),
      end: DateTime.utc(2026, 1, 2),
      authoredOnly: true,
    );
    final second = sut.fetchAll(
      users: [user],
      start: DateTime.utc(2026, 1, 1),
      end: DateTime.utc(2026, 1, 2),
      authoredOnly: true,
    );
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(calls, 1);

    gate.complete();
    final results = await Future.wait([first, second]);
    expect(calls, 1);
    expect(results[0], hasLength(1));
    expect(results[1], hasLength(1));
  });
}
