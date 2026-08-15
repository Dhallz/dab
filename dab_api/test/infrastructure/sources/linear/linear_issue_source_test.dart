import 'package:dab_api/src/domain/dtos/linear/linear_issue_dto.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_issue_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockGraphqlProtocol extends Mock implements GraphqlProtocol {}

void main() {
  late _MockProviderConfigRepository configRepository;
  late _MockUserRepository userRepository;
  late _MockGraphqlProtocol graphql;
  late LinearIssueSource source;

  final user = User(
    id: 'u-linear',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final identity = UserIdentity(
    id: 'ident-1',
    userId: 'u-linear',
    providerId: 'linear',
    externalId: 'linear-user-ada',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'linear',
    name: 'Linear',
    baseUrl: 'https://linear.app',
    isActive: true,
    settings: const {'apiKey': 'lin_api_key'},
  );

  final issueNode = {
    'identifier': 'ENG-42',
    'title': 'Fix login',
    'url': 'https://linear.app/acme/issue/ENG-42/fix-login',
    'updatedAt': '2026-06-30T10:00:00.000Z',
    'state': {'name': 'In Progress'},
    'team': {'key': 'ENG'},
    'assignee': {'id': 'linear-user-ada', 'name': 'Ada L.'},
    'creator': {'id': 'linear-user-other', 'name': 'Other'},
  };

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.linear.app/graphql'));
  });

  setUp(() {
    configRepository = _MockProviderConfigRepository();
    userRepository = _MockUserRepository();
    graphql = _MockGraphqlProtocol();
    source = LinearIssueSource(
      configRepository,
      userRepository,
      graphql,
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
    test(
      'maps GraphQL issue nodes to DTOs with identity attribution',
      () async {
        when(
          () => graphql.execute(
            any(),
            bearerToken: any(named: 'bearerToken'),
            document: any(named: 'document'),
            variables: any(named: 'variables'),
          ),
        ).thenAnswer(
          (_) async => {
            'issues': {
              'nodes': [issueNode],
              'pageInfo': {'hasNextPage': false, 'endCursor': null},
            },
          },
        );

        final dtos = await source.fetchRawData(
          [user],
          DateTime.utc(2026, 6, 1),
          DateTime.utc(2026, 7, 1),
          false,
        );

        expect(dtos, hasLength(1));
        final dto = dtos.single;
        expect(dto.identifier, 'ENG-42');
        expect(dto.teamKey, 'ENG');
        expect(dto.statusName, 'In Progress');
        expect(dto.dabUserId, 'u-linear');
        expect(dto.authorDisplayName, 'Ada L.');

        final activities = dto.toActivities([user]);
        expect(activities, hasLength(1));
        expect(activities.single.userId, 'u-linear');
        expect(activities.single.title, '[ENG-42] Fix login');
      },
    );

    test('passes teamKeys into the GraphQL issue filter', () async {
      when(() => configRepository.getConfigs()).thenAnswer(
        (_) async => Right([
          config.copyWith(
            settings: const {'apiKey': 'lin_api_key', 'teamKeys': 'ENG'},
          ),
        ]),
      );
      when(
        () => graphql.execute(
          any(),
          bearerToken: any(named: 'bearerToken'),
          document: any(named: 'document'),
          variables: any(named: 'variables'),
        ),
      ).thenAnswer((invocation) async {
        final document = invocation.namedArguments[#document] as String? ?? '';
        if (document.contains('DabComments')) {
          return {
            'comments': {
              'nodes': <dynamic>[],
              'pageInfo': {'hasNextPage': false},
            },
          };
        }
        return {
          'issues': {
            'nodes': [issueNode],
            'pageInfo': {'hasNextPage': false},
          },
        };
      });

      await source.fetchRawData(
        [user],
        DateTime.utc(2026, 6, 1),
        DateTime.utc(2026, 7, 1),
        false,
      );

      final captured = verify(
        () => graphql.execute(
          any(),
          bearerToken: any(named: 'bearerToken'),
          document: any(named: 'document'),
          variables: captureAny(named: 'variables'),
        ),
      ).captured;
      final issueVars = captured.cast<Map<String, dynamic>>().firstWhere(
        (vars) => (vars['filter'] as Map?)?.containsKey('team') == true,
        orElse: () => const <String, dynamic>{},
      );
      expect(
        issueVars['filter'],
        containsPair('team', {
          'key': {
            'in': ['ENG'],
          },
        }),
      );
    });

    test('merges GraphQL comments onto the parent issue DTO', () async {
      when(
        () => graphql.execute(
          any(),
          bearerToken: any(named: 'bearerToken'),
          document: any(named: 'document'),
          variables: any(named: 'variables'),
        ),
      ).thenAnswer((invocation) async {
        final document = invocation.namedArguments[#document] as String? ?? '';
        if (document.contains('DabComments')) {
          return {
            'comments': {
              'nodes': [
                {
                  'id': 'comment-1',
                  'body': 'Please review',
                  'createdAt': '2026-06-30T10:05:00.000Z',
                  'user': {'id': 'linear-user-ada', 'name': 'Ada L.'},
                  'issue': issueNode,
                },
              ],
              'pageInfo': {'hasNextPage': false, 'endCursor': null},
            },
          };
        }
        return {
          'issues': {
            'nodes': [issueNode],
            'pageInfo': {'hasNextPage': false, 'endCursor': null},
          },
        };
      });

      final dtos = await source.fetchRawData(
        [user],
        DateTime.utc(2026, 6, 1),
        DateTime.utc(2026, 7, 1),
        false,
      );

      expect(dtos, hasLength(1));
      expect(dtos.single.comments, hasLength(1));
      expect(dtos.single.comments.single.body, 'Please review');
      final activities = dtos.single.toActivities([user]);
      expect(activities.where((a) => a.commentCount == 1), hasLength(1));
    });

    test(
      'returns empty without an active config or linked identities',
      () async {
        when(
          () => configRepository.getConfigs(),
        ).thenAnswer((_) async => const Right([]));

        expect(
          await source.fetchRawData(
            [user],
            DateTime.utc(2026, 6, 1),
            DateTime.utc(2026, 7, 1),
            false,
          ),
          isEmpty,
        );

        when(
          () => configRepository.getConfigs(),
        ).thenAnswer((_) async => Right([config]));
        when(
          () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
        ).thenAnswer((_) async => const Right([]));

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
          () => graphql.execute(
            any(),
            bearerToken: any(named: 'bearerToken'),
            document: any(named: 'document'),
            variables: any(named: 'variables'),
          ),
        );
      },
    );

    test('returns empty when the GraphQL call fails', () async {
      when(
        () => graphql.execute(
          any(),
          bearerToken: any(named: 'bearerToken'),
          document: any(named: 'document'),
          variables: any(named: 'variables'),
        ),
      ).thenThrow(Exception('boom'));

      expect(
        await source.fetchRawData(
          [user],
          DateTime.utc(2026, 6, 1),
          DateTime.utc(2026, 7, 1),
          false,
        ),
        isEmpty,
      );
    });
  });

  group('lookupExternalId', () {
    test('returns the first matching Linear user id', () async {
      when(
        () => graphql.execute(
          any(),
          bearerToken: any(named: 'bearerToken'),
          document: any(named: 'document'),
          variables: any(named: 'variables'),
        ),
      ).thenAnswer(
        (_) async => {
          'users': {
            'nodes': [
              {'id': 'linear-user-ada'},
            ],
          },
        },
      );

      final result = await source.lookupExternalId('Ada', 'ada@example.com');
      expect(result.getOrElse((_) => null), 'linear-user-ada');
    });

    test('returns null when nothing matches or the call fails', () async {
      when(
        () => graphql.execute(
          any(),
          bearerToken: any(named: 'bearerToken'),
          document: any(named: 'document'),
          variables: any(named: 'variables'),
        ),
      ).thenAnswer(
        (_) async => {
          'users': {'nodes': <dynamic>[]},
        },
      );

      final result = await source.lookupExternalId('Ada', 'ada@example.com');
      expect(result.getOrElse((_) => 'x'), isNull);
    });
  });

  group('mapLinearIssueNode', () {
    test('derives team key from the identifier when team is missing', () {
      final node = Map<String, dynamic>.from(issueNode)..remove('team');
      final dto = mapLinearIssueNode(node, const {});
      expect(dto, isNotNull);
      expect(dto!.teamKey, 'ENG');
      expect(dto.dabUserId, isNull);
    });

    test('returns null for nodes without identifier or updatedAt', () {
      expect(mapLinearIssueNode({'title': 'x'}, const {}), isNull);
      expect(
        mapLinearIssueNode({'identifier': 'ENG-1', 'title': 'x'}, const {}),
        isNull,
      );
    });
  });
}
