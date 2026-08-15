import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/slack_web_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/slack/slack_message_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockProviderConfigRepo extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepo extends Mock implements IUserRepository {}

/// Deterministic [SlackWebProtocol] for tests (no mocktail arity issues).
class _FakeSlackWeb implements SlackWebProtocol {
  @override
  Duration get defaultTimeout => const Duration(seconds: 12);

  @override
  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    required String bearerToken,
    Duration? timeout,
  }) async {
    final s = uri.toString();
    if (s.contains('users.lookupByEmail')) {
      return {
        'ok': true,
        'user': {'id': 'U999'},
      };
    }
    if (s.contains('conversations.history')) {
      return {
        'ok': true,
        'messages': [
          {'user': 'U111', 'text': 'linked message', 'ts': '1712523471.0123'},
          {
            'user': 'U222',
            'text': 'unlinked message',
            'ts': '1712523472.0123',
          },
        ],
        'response_metadata': {'next_cursor': ''},
      };
    }
    if (s.contains('conversations.info')) {
      return {
        'ok': true,
        'channel': {'name': 'general', 'is_im': false},
      };
    }
    if (s.contains('users.info')) {
      return {
        'ok': true,
        'user': {
          'name': 'stub',
          'profile': {'display_name': ''},
        },
      };
    }
    return {'ok': true};
  }

  @override
  Future<Map<String, dynamic>> postJson(
    Uri uri, {
    required String bearerToken,
    Duration? timeout,
  }) async {
    // No team_id so permalink uses https [ProviderConfig.baseUrl]/archives/...
    return {'ok': true};
  }
}

void main() {
  late _MockProviderConfigRepo configRepo;
  late _MockUserRepo userRepo;
  late SlackMessageSource source;

  setUp(() {
    configRepo = _MockProviderConfigRepo();
    userRepo = _MockUserRepo();
    source = SlackMessageSource(configRepo, userRepo, _FakeSlackWeb());
  });

  test('fetchRawData returns only linked and attributed messages', () async {
    final users = [
      TestData.user(id: 'u-1', name: 'Alice'),
      TestData.user(id: 'u-2', name: 'Bob'),
    ];

    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'slack',
          name: 'Slack',
          baseUrl: 'https://acme.slack.com',
          settings: {
            'botToken': 'xoxb-test',
            'channels': ['C123'],
          },
        ),
      ]),
    );
    when(
      () => userRepo.getIdentitiesForUsersAndProvider(any(), 'slack'),
    ).thenAnswer(
      (_) async => Right([
        UserIdentity(
          id: 'i-1',
          userId: 'u-1',
          providerId: 'slack',
          externalId: 'U111',
          status: UserIdentityStatus.linked,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ]),
    );

    final result = await source.fetchRawData(
      users,
      DateTime.utc(2026, 1, 1),
      DateTime.utc(2026, 1, 2),
      true,
    );

    expect(result, hasLength(1));
    expect(result.single.dabUserId, 'u-1');
    expect(result.single.channelId, 'C123');
    expect(result.single.permalink, contains('/archives/C123/'));
  });

  test('lookupExternalId resolves slack user id by email', () async {
    when(() => configRepo.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'slack',
          name: 'Slack',
          baseUrl: 'https://acme.slack.com',
          settings: {'botToken': 'xoxb-test'},
        ),
      ]),
    );

    final result = await source.lookupExternalId('Alice', 'alice@acme.com');
    expect(result.getOrElse((_) => null), 'U999');
  });
}
