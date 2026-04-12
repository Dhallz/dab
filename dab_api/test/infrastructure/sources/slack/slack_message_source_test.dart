import 'dart:convert';

import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/sources/slack/slack_message_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockProviderConfigRepo extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepo extends Mock implements IUserRepository {}

class _MockHttpClient extends Mock implements http.Client {}

void main() {
  late _MockProviderConfigRepo configRepo;
  late _MockUserRepo userRepo;
  late _MockHttpClient httpClient;
  late SlackMessageSource source;

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://example.com'));
    registerFallbackValue(<String>[]);
    registerFallbackValue(<String, String>{});
  });

  setUp(() {
    configRepo = _MockProviderConfigRepo();
    userRepo = _MockUserRepo();
    httpClient = _MockHttpClient();
    source = SlackMessageSource(configRepo, userRepo, httpClient: httpClient);
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
    when(
      () => httpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode({
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
        }),
        200,
      ),
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
    when(
      () => httpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => http.Response(
        jsonEncode({
          'ok': true,
          'user': {'id': 'U999'},
        }),
        200,
      ),
    );

    final result = await source.lookupExternalId('Alice', 'alice@acme.com');
    expect(result.getOrElse((_) => null), 'U999');
  });
}
