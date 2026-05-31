import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/teams/microsoft_graph_token_client.dart';
import 'package:dab_api/src/infrastructure/sources/teams/teams_message_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockProviderConfigRepo extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepo extends Mock implements IUserRepository {}

class _FakeTokenClient extends MicrosoftGraphTokenClient {
  @override
  Future<String?> fetchAppToken({
    required String tenantId,
    required String clientId,
    required String clientSecret,
    Duration timeout = const Duration(seconds: 12),
  }) async =>
      'graph-token';
}

class _FakeJsonRest implements JsonRestProtocol {
  @override
  Duration get defaultTimeout => const Duration(seconds: 12);

  @override
  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<List<dynamic>> getJsonList(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getJsonMap(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final s = uri.toString();
    if (s.contains('/users?')) {
      return {
        'value': [
          {'id': 'graph-u-9'},
        ],
      };
    }
    if (s.contains('/channels/') && !s.contains('/messages')) {
      return {'displayName': 'general'};
    }
    if (s.contains('/messages')) {
      return {
        'value': [
          {
            'id': 'msg-1',
            'createdDateTime': '2026-05-18T12:00:00Z',
            'body': {'content': 'hello teams'},
            'from': {
              'user': {'id': 'graph-u-1', 'displayName': 'Alice'},
            },
            'webUrl': 'https://teams.microsoft.com/l/message/msg-1',
          },
          {
            'id': 'msg-2',
            'createdDateTime': '2026-05-18T12:01:00Z',
            'body': {'content': 'unlinked'},
            'from': {
              'user': {'id': 'graph-u-2', 'displayName': 'Bob'},
            },
          },
        ],
      };
    }
    return {};
  }
}

void main() {
  late _MockProviderConfigRepo configRepo;
  late _MockUserRepo userRepo;
  late TeamsMessageSource source;

  setUp(() {
    configRepo = _MockProviderConfigRepo();
    userRepo = _MockUserRepo();
    source = TeamsMessageSource(
      configRepo,
      userRepo,
      _FakeJsonRest(),
      _FakeTokenClient(),
    );
  });

  test('fetchRawData returns only linked and attributed messages', () async {
    final users = [TestData.user(id: 'u-1', name: 'Alice')];

    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'teams',
          name: 'Microsoft Teams',
          baseUrl: 'https://teams.microsoft.com',
          settings: {
            'tenantId': 'tenant-1',
            'clientId': 'client-1',
            'clientSecret': 'secret-1',
            'channels': ['team-1/channel-1'],
          },
        ),
      ]),
    );
    when(
      () => userRepo.getIdentitiesForUsersAndProvider(any(), 'teams'),
    ).thenAnswer(
      (_) async => Right([
        UserIdentity(
          id: 'i-1',
          userId: 'u-1',
          providerId: 'teams',
          externalId: 'graph-u-1',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        ),
      ]),
    );

    final dtos = await source.fetchRawData(
      users,
      DateTime.utc(2026, 5, 18, 11),
      DateTime.utc(2026, 5, 18, 13),
      false,
    );

    expect(dtos, hasLength(1));
    expect(dtos.single.dabUserId, 'u-1');
    expect(dtos.single.content, 'hello teams');
    expect(dtos.single.teamId, 'team-1');
    expect(dtos.single.channelId, 'channel-1');
  });

  test('lookupExternalId resolves graph user id by email', () async {
    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'teams',
          name: 'Microsoft Teams',
          baseUrl: 'https://teams.microsoft.com',
          settings: {
            'tenantId': 'tenant-1',
            'clientId': 'client-1',
            'clientSecret': 'secret-1',
          },
        ),
      ]),
    );

    final result = await source.lookupExternalId('Alice', 'alice@example.com');

    expect(result.getOrElse((_) => null), 'graph-u-9');
  });
}
