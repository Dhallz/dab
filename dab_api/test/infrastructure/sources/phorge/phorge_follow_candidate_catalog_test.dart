import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_follow_candidate_catalog.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';
import '../../../test_factories.dart';

class _MockConduitProtocol extends Mock implements ConduitProtocol {}

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late _MockConduitProtocol conduit;
  late _MockProviderConfigRepository configs;
  late _MockUserRepository users;
  late PhorgeFollowCandidateCatalog catalog;

  const config = ProviderConfig(
    id: 'phorge',
    name: 'Phorge',
    baseUrl: 'https://phorge.example.com',
    settings: {
      'api.token': 'conduit-token',
      'instanceUrl': 'https://phorge.example.com',
    },
  );

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    conduit = _MockConduitProtocol();
    configs = _MockProviderConfigRepository();
    users = _MockUserRepository();
    catalog = PhorgeFollowCandidateCatalog(
      configs,
      FakeCredentialResolver(),
      users,
      conduit,
    );
    when(
      () => configs.getConfigs(),
    ).thenAnswer((_) async => const Right([config]));
  });

  test('keeps assigned tasks when subscriber search fails', () async {
    final user = TestData.user(
      id: 'u-1',
    ).copyWith(phorgePhid: 'PHID-USER-ALICE');
    when(() => users.getUser('u-1')).thenAnswer((_) async => Right(user));
    when(
      () => conduit.call(any(), any(), apiToken: any(named: 'apiToken')),
    ).thenAnswer((invocation) async {
      final params = invocation.positionalArguments[1] as Map;
      final constraints = params['constraints'] as Map;
      if (constraints.containsKey('subscriberPHIDs')) {
        throw ConduitException(code: 'ERR-INVALID', info: 'bad constraint');
      }
      if (constraints.containsKey('subscribers')) {
        fail('must use subscriberPHIDs, not subscribers');
      }
      return {
        'data': [_task(phid: 'PHID-TASK-1', id: 12, name: 'Fix login')],
      };
    });

    final result = await catalog.list(userId: 'u-1', query: '');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows, hasLength(1));
    expect(rows.single.objectKey, 'PHID-TASK-1');
    expect(rows.single.title, '[T12] Fix login');
    expect(rows.single.url, 'https://phorge.example.com/T12');
  });

  test(
    'resolves PHID from a linked identity when User.phorgePhid is empty',
    () async {
      final user = TestData.user(id: 'u-1', phorgeUsername: null);
      when(() => users.getUser('u-1')).thenAnswer((_) async => Right(user));
      when(() => users.getIdentities('u-1')).thenAnswer(
        (_) async => Right([
          UserIdentity(
            id: 'ident-1',
            userId: 'u-1',
            providerId: 'phorge',
            externalId: 'PHID-USER-LINKED',
            status: UserIdentityStatus.linked,
            createdAt: DateTime.utc(2026, 1, 1),
          ),
        ]),
      );
      when(
        () => conduit.call(any(), any(), apiToken: any(named: 'apiToken')),
      ).thenAnswer((invocation) async {
        final method = invocation.positionalArguments[0] as String;
        expect(method, 'maniphest.search');
        final params = invocation.positionalArguments[1] as Map;
        final constraints = params['constraints'] as Map;
        expect(
          constraints['assigned'] ??
              constraints['authorPHIDs'] ??
              constraints['subscriberPHIDs'],
          ['PHID-USER-LINKED'],
        );
        return {
          'data': [_task(phid: 'PHID-TASK-2', id: 9, name: 'From identity')],
        };
      });

      final result = await catalog.list(userId: 'u-1', query: '');
      final rows = result.getOrElse((_) => throw StateError('left'));
      expect(rows.single.objectKey, 'PHID-TASK-2');
      verifyNever(
        () => conduit.call(
          'user.whoami',
          any(),
          apiToken: any(named: 'apiToken'),
        ),
      );
    },
  );

  test('falls back to user.whoami when no PHID is stored', () async {
    final user = TestData.user(id: 'u-1', phorgeUsername: null);
    when(() => users.getUser('u-1')).thenAnswer((_) async => Right(user));
    when(
      () => users.getIdentities('u-1'),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => conduit.call(any(), any(), apiToken: any(named: 'apiToken')),
    ).thenAnswer((invocation) async {
      final method = invocation.positionalArguments[0] as String;
      if (method == 'user.whoami') {
        return {'phid': 'PHID-USER-WHOAMI'};
      }
      final params = invocation.positionalArguments[1] as Map;
      final constraints = params['constraints'] as Map;
      expect(
        constraints['assigned'] ??
            constraints['authorPHIDs'] ??
            constraints['subscriberPHIDs'],
        ['PHID-USER-WHOAMI'],
      );
      return {
        'data': [_task(phid: 'PHID-TASK-3', id: 3, name: 'From whoami')],
      };
    });

    final result = await catalog.list(userId: 'u-1', query: '');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows.single.objectKey, 'PHID-TASK-3');
  });
}

Map<String, dynamic> _task({
  required String phid,
  required int id,
  required String name,
}) {
  return {
    'phid': phid,
    'id': id,
    'fields': {'name': name},
  };
}
