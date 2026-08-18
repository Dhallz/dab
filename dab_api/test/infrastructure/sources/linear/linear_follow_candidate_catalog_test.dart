import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_follow_candidate_catalog.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../fakes/fake_credential_resolver.dart';

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockGraphqlProtocol extends Mock implements GraphqlProtocol {}

class _MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late _MockProviderConfigRepository configs;
  late _MockGraphqlProtocol graphql;
  late _MockUserRepository users;
  late LinearFollowCandidateCatalog catalog;

  const config = ProviderConfig(
    id: 'linear',
    name: 'Linear',
    baseUrl: 'https://linear.app',
    settings: {'apiKey': 'lin_api_key'},
  );

  final identity = UserIdentity(
    id: 'ident-1',
    userId: 'u-1',
    providerId: 'linear',
    externalId: 'linear-user-ada',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://api.linear.app/graphql'));
    registerFallbackValue(<String, dynamic>{});
  });

  setUp(() {
    configs = _MockProviderConfigRepository();
    graphql = _MockGraphqlProtocol();
    users = _MockUserRepository();
    catalog = LinearFollowCandidateCatalog(
      configs,
      FakeCredentialResolver(),
      graphql,
      users,
    );
    when(
      () => configs.getConfigs(),
    ).thenAnswer((_) async => const Right([config]));
    when(
      () => users.getIdentity('u-1', 'linear'),
    ).thenAnswer((_) async => Right(identity));
  });

  test('filters by linked Linear identity instead of isMe', () async {
    Map<String, dynamic>? filter;
    when(
      () => graphql.execute(
        any(),
        bearerToken: any(named: 'bearerToken'),
        document: any(named: 'document'),
        variables: any(named: 'variables'),
      ),
    ).thenAnswer((invocation) async {
      final variables =
          invocation.namedArguments[#variables] as Map<String, dynamic>;
      filter = variables['filter'] as Map<String, dynamic>?;
      return {
        'issues': {
          'nodes': [
            {
              'identifier': 'ENG-42',
              'title': 'Fix login',
              'url': 'https://linear.app/acme/issue/ENG-42',
            },
          ],
        },
      };
    });

    final result = await catalog.list(userId: 'u-1', query: '');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows, hasLength(1));
    expect(rows.single.objectKey, 'ENG-42');
    expect(_containsAssigneeId(filter, 'linear-user-ada'), isTrue);
    expect(_containsSubscriberSome(filter), isTrue);
    expect(_containsBareSubscriber(filter), isFalse);
    expect(_containsIsMe(filter), isFalse);
  });

  test('retries without subscribers when that filter is rejected', () async {
    var calls = 0;
    when(
      () => graphql.execute(
        any(),
        bearerToken: any(named: 'bearerToken'),
        document: any(named: 'document'),
        variables: any(named: 'variables'),
      ),
    ).thenAnswer((invocation) async {
      calls++;
      final variables =
          invocation.namedArguments[#variables] as Map<String, dynamic>;
      final filter = variables['filter'];
      if (calls == 1) {
        expect(_containsSubscriberSome(filter), isTrue);
        throw GraphqlProtocolException(message: 'Unknown argument subscribers');
      }
      expect(_containsSubscriberSome(filter), isFalse);
      expect(_containsAssigneeId(filter, 'linear-user-ada'), isTrue);
      return {
        'issues': {
          'nodes': [
            {'identifier': 'ENG-9', 'title': 'Assigned only'},
          ],
        },
      };
    });

    final result = await catalog.list(userId: 'u-1', query: '');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(calls, 2);
    expect(rows.single.objectKey, 'ENG-9');
  });

  test('falls back to isMe when no Linear identity is linked', () async {
    when(
      () => users.getIdentity('u-1', 'linear'),
    ).thenAnswer((_) async => const Right(null));
    Map<String, dynamic>? filter;
    when(
      () => graphql.execute(
        any(),
        bearerToken: any(named: 'bearerToken'),
        document: any(named: 'document'),
        variables: any(named: 'variables'),
      ),
    ).thenAnswer((invocation) async {
      final variables =
          invocation.namedArguments[#variables] as Map<String, dynamic>;
      filter = variables['filter'] as Map<String, dynamic>?;
      return {
        'issues': {
          'nodes': [
            {'identifier': 'ENG-1', 'title': 'Mine'},
          ],
        },
      };
    });

    final result = await catalog.list(userId: 'u-1', query: '');
    final rows = result.getOrElse((_) => throw StateError('left'));
    expect(rows.single.objectKey, 'ENG-1');
    expect(_containsIsMe(filter), isTrue);
  });
}

bool _containsAssigneeId(Object? node, String id) {
  if (node is Map) {
    final assignee = node['assignee'];
    if (assignee is Map) {
      final idFilter = assignee['id'];
      if (idFilter is Map &&
          ((idFilter['eq'] == id) ||
              (idFilter['in'] is List &&
                  (idFilter['in'] as List).contains(id)))) {
        return true;
      }
    }
    return node.values.any((value) => _containsAssigneeId(value, id));
  }
  if (node is List) {
    return node.any((value) => _containsAssigneeId(value, id));
  }
  return false;
}

bool _containsSubscriberSome(Object? node) {
  if (node is Map) {
    final subscribers = node['subscribers'];
    if (subscribers is Map && subscribers['some'] is Map) return true;
    return node.values.any(_containsSubscriberSome);
  }
  if (node is List) return node.any(_containsSubscriberSome);
  return false;
}

bool _containsBareSubscriber(Object? node) {
  if (node is Map) {
    if (node.containsKey('subscriber')) return true;
    return node.values.any(_containsBareSubscriber);
  }
  if (node is List) return node.any(_containsBareSubscriber);
  return false;
}

bool _containsIsMe(Object? node) {
  if (node is Map) {
    if (node.containsKey('isMe')) return true;
    return node.values.any(_containsIsMe);
  }
  if (node is List) return node.any(_containsIsMe);
  return false;
}
