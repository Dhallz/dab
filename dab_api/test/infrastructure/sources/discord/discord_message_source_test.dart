import 'package:dab_api/src/domain/dtos/discord/discord_message_dto.dart';
import 'package:dab_api/src/domain/dtos/discord/discord_message_mapping.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_message_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockJsonRestProtocol extends Mock implements JsonRestProtocol {}

void main() {
  late _MockProviderConfigRepository configRepository;
  late _MockUserRepository userRepository;
  late _MockJsonRestProtocol jsonRest;
  late DiscordMessageSource source;

  final user = User(
    id: 'u-discord',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final identity = UserIdentity(
    id: 'ident-1',
    userId: 'u-discord',
    providerId: 'discord',
    externalId: '111222333',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'discord',
    name: 'Discord',
    baseUrl: 'https://discord.com',
    isActive: true,
    settings: const {
      'botToken': 'bot-token',
      'guildId': 'guild-1',
      'channels': ['chan-1'],
    },
  );

  final messageJson = {
    'id': 'msg-1',
    'channel_id': 'chan-1',
    'content': 'Hello world',
    'timestamp': '2026-06-30T10:00:00.000Z',
    'author': {
      'id': '111222333',
      'username': 'ada',
      'global_name': 'Ada L.',
      'avatar': 'abc123',
    },
  };

  setUpAll(() {
    registerFallbackValue(Uri.parse('https://discord.com/api/v10'));
  });

  setUp(() {
    configRepository = _MockProviderConfigRepository();
    userRepository = _MockUserRepository();
    jsonRest = _MockJsonRestProtocol();
    source = DiscordMessageSource(configRepository, userRepository, jsonRest);

    when(
      () => configRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
    ).thenAnswer((_) async => Right([identity]));
  });

  group('fetchRawData', () {
    test('maps channel messages within the window to attributed DTOs',
        () async {
      when(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => [messageJson]);

      final dtos = await source.fetchRawData(
        [user],
        DateTime.utc(2026, 6, 1),
        DateTime.utc(2026, 7, 1),
        false,
      );

      expect(dtos, hasLength(1));
      final dto = dtos.single;
      expect(dto.messageId, 'msg-1');
      expect(dto.dabUserId, 'u-discord');
      expect(dto.authorDisplayName, 'Ada L.');
      expect(dto.guildId, 'guild-1');

      final activities = dto.toActivities([user]);
      expect(activities, hasLength(1));
      expect(activities.single.userId, 'u-discord');
      expect(
        activities.single.url,
        'https://discord.com/channels/guild-1/chan-1/msg-1',
      );
    });

    test('skips bot authors and messages outside the window', () async {
      when(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => [
          {
            ...messageJson,
            'id': 'msg-bot',
            'author': {'id': '999', 'bot': true},
          },
          {...messageJson, 'id': 'msg-old', 'timestamp': '2025-01-01T00:00:00Z'},
        ],
      );

      final dtos = await source.fetchRawData(
        [user],
        DateTime.utc(2026, 6, 1),
        DateTime.utc(2026, 7, 1),
        false,
      );

      expect(dtos, isEmpty);
    });

    test('returns empty without config, token, channels, or identities',
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
      verifyNever(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      );
    });
  });

  group('lookupExternalId', () {
    test('resolves guild members by name', () async {
      when(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      ).thenAnswer(
        (_) async => [
          {
            'user': {'id': '111222333', 'username': 'ada'},
          },
        ],
      );

      final result = await source.lookupExternalId('ada', 'ada@example.com');
      expect(result.getOrElse((_) => null), '111222333');
    });

    test('returns null when the search fails', () async {
      when(
        () => jsonRest.getJsonList(any(), headers: any(named: 'headers')),
      ).thenThrow(Exception('boom'));

      final result = await source.lookupExternalId('ada', 'ada@example.com');
      expect(result.getOrElse((_) => 'x'), isNull);
    });
  });

  group('mapDiscordMessageJson', () {
    test('extracts reply reference and avatar url', () {
      final dto = mapDiscordMessageJson(
        {
          ...messageJson,
          'message_reference': {'message_id': 'msg-0'},
        },
        fallbackChannelId: 'chan-1',
        guildId: 'guild-1',
        externalToUser: const {'111222333': 'u-discord'},
      );

      expect(dto, isNotNull);
      expect(dto!.replyToId, 'msg-0');
      expect(
        dto.authorAvatarUrl,
        'https://cdn.discordapp.com/avatars/111222333/abc123.png',
      );
    });

    test('returns null for malformed rows', () {
      expect(
        mapDiscordMessageJson(
          {'id': 'x'},
          fallbackChannelId: 'chan-1',
        ),
        isNull,
      );
    });
  });
}
