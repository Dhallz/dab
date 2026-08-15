import 'package:dab_api/src/domain/dtos/bitbucket/bitbucket_commit_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/bitbucket/bitbucket_commit_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockJsonRestProtocol extends Mock implements JsonRestProtocol {}

void main() {
  late _MockProviderConfigRepository configRepository;
  late _MockUserRepository userRepository;
  late _MockJsonRestProtocol jsonRest;
  late BitbucketCommitSource source;

  final user = User(
    id: 'u-bb',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final identity = UserIdentity(
    id: 'ident-1',
    userId: 'u-bb',
    providerId: 'bitbucket',
    externalId: 'acct-bb-ada',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'bitbucket',
    name: 'Bitbucket',
    baseUrl: 'https://bitbucket.org',
    isActive: true,
    settings: const {
      'username': 'ada',
      'apiToken': 'app-password',
      'workspace': 'acme',
      'repos': ['widget'],
    },
  );

  final commitJson = {
    'hash': 'abc123',
    'message': 'Fix login bug',
    'date': '2026-06-30T10:00:00+00:00',
    'links': {
      'html': {'href': 'https://bitbucket.org/acme/widget/commits/abc123'},
    },
    'author': {
      'raw': 'Ada L. <ada@example.com>',
      'user': {'account_id': 'acct-bb-ada', 'display_name': 'Ada L.'},
    },
  };

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.bitbucket.org/2.0'));
  });

  setUp(() {
    configRepository = _MockProviderConfigRepository();
    userRepository = _MockUserRepository();
    jsonRest = _MockJsonRestProtocol();
    source = BitbucketCommitSource(
      configRepository,
      userRepository,
      jsonRest,
      FakeCredentialResolver(),
    );

    when(
      () => configRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
    ).thenAnswer((_) async => Right([identity]));
  });

  group('fetchRawData', () {
    test('maps repository commits within the window', () async {
      Uri? requestedUri;
      when(
        () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
      ).thenAnswer((invocation) async {
        requestedUri = invocation.positionalArguments.first as Uri;
        return {
          'values': [commitJson],
        };
      });

      final dtos = await source.fetchRawData(
        [user],
        DateTime.utc(2026, 6, 1),
        DateTime.utc(2026, 7, 1),
        false,
      );

      expect(dtos, hasLength(1));
      expect(dtos.single.sha, 'abc123');
      expect(dtos.single.repo, 'acme/widget');
      expect(dtos.single.userId, 'u-bb');
      expect(
        requestedUri!.path,
        '/2.0/repositories/acme/widget/commits',
      );

      final activities = dtos.single.toActivities([user]);
      expect(activities, hasLength(1));
      expect(activities.single.userId, 'u-bb');
    });

    test('stops paginating once rows fall before the window', () async {
      var calls = 0;
      when(
        () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async {
        calls++;
        return {
          'values': [
            {...commitJson, 'date': '2020-01-01T00:00:00+00:00'},
          ],
          'next':
              'https://api.bitbucket.org/2.0/repositories/acme/widget/commits?page=2',
        };
      });

      final dtos = await source.fetchRawData(
        [user],
        DateTime.utc(2026, 6, 1),
        DateTime.utc(2026, 7, 1),
        false,
      );

      expect(dtos, isEmpty);
      expect(calls, 1);
    });

    test('returns empty without credentials or workspace', () async {
      when(() => configRepository.getConfigs()).thenAnswer(
        (_) async => Right([
          config.copyWith(settings: const {'username': 'ada'}),
        ]),
      );

      expect(
        await source.fetchRawData(
          [user],
          DateTime.utc(2026, 6, 1),
          DateTime.utc(2026, 7, 1),
          false,
        ),
        isEmpty,
      );
      verifyNever(
        () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
      );
    });
  });

  group('lookupExternalId', () {
    test('resolves workspace members by display name', () async {
      when(
        () => jsonRest.getJsonMap(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => {
          'values': [
            {
              'user': {
                'account_id': 'acct-bb-ada',
                'display_name': 'Ada',
                'nickname': 'ada',
              },
            },
          ],
        },
      );

      final result = await source.lookupExternalId('Ada', 'ada@example.com');
      expect(result.getOrElse((_) => null), 'acct-bb-ada');
    });
  });

  group('raw signature helpers', () {
    test('parses email and name from raw signatures', () {
      expect(bitbucketEmailFromRaw('Ada L. <ada@example.com>'),
          'ada@example.com');
      expect(bitbucketNameFromRaw('Ada L. <ada@example.com>'), 'Ada L.');
      expect(bitbucketEmailFromRaw('no email here'), isNull);
    });
  });
}
