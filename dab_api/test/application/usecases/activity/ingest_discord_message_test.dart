import 'package:dab_api/src/application/usecases/activity/ingest_discord_message.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/core/realtime/presence_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockActivityRepository extends Mock implements AbsIActivityRepository {}

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockRedisService extends Mock implements RedisService {}

class _MockPresenceService extends Mock implements PresenceService {}

class _MockFollows extends Mock implements AbsIActivityFollowRepository {}

void main() {
  late _MockUserRepository userRepository;
  late _MockActivityRepository activityRepository;
  late _MockProviderConfigRepository providerConfigRepository;
  late _MockRedisService redisService;
  late _MockPresenceService presenceService;
  late IngestDiscordMessage useCase;

  final user = User(
    id: 'u-discord',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final recipient = User(
    id: 'u-bob',
    name: 'Bob',
    email: 'bob@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final recipientIdentity = UserIdentity(
    id: 'ident-2',
    userId: 'u-bob',
    providerId: 'discord',
    externalId: '444555666',
    status: UserIdentityStatus.linked,
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

  Map<String, dynamic> messagePayload({
    String messageId = 'msg-1',
    String channelId = 'chan-1',
    String authorId = '111222333',
    bool bot = false,
    List<Map<String, String>> mentions = const [],
    bool mentionEveryone = false,
  }) {
    return <String, dynamic>{
      'id': messageId,
      'channel_id': channelId,
      'guild_id': 'guild-1',
      'content': 'Hello world',
      'timestamp': '2026-06-30T10:00:00.000Z',
      'mention_everyone': mentionEveryone,
      'mentions': mentions,
      'author': {
        'id': authorId,
        'username': 'ada',
        'global_name': 'Ada L.',
        'bot': bot,
      },
    };
  }

  setUpAll(() {
    registerFallbackValue(
      Activity(
        id: 'fallback',
        userId: 'u',
        provider: const GenericProvider(name: 'Mock'),
        title: 'fallback',
        content: 'fallback',
        authorName: 'fallback',
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    userRepository = _MockUserRepository();
    activityRepository = _MockActivityRepository();
    providerConfigRepository = _MockProviderConfigRepository();
    redisService = _MockRedisService();
    presenceService = _MockPresenceService();

    useCase = IngestDiscordMessage(
      userRepository,
      activityRepository,
      providerConfigRepository,
      redisService,
      presenceService,
    );

    when(
      () => presenceService.broadcastToUser(any(), any(), any()),
    ).thenReturn(null);
    when(
      () => redisService.recordLiveIngestSuccess(any()),
    ).thenAnswer((_) async {});
    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => true);
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => Right([user, recipient]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
    ).thenAnswer((_) async => Right([identity, recipientIdentity]));
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});
  });

  test('ingests MESSAGE_CREATE mentions for linked recipients', () async {
    final out = await useCase.execute(
      payload: messagePayload(
        mentions: [
          {'id': '444555666'},
        ],
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-bob');
    expect(captured.senderUserId, 'u-discord');
    final provider = captured.provider as DiscordMessageProvider;
    expect(provider.messageId, 'msg-1');
    expect(provider.channelId, 'chan-1');
    verify(() => redisService.reserveIngestionEventId('discord', 'msg-1'))
        .called(1);
    verify(
      () => presenceService.broadcastToUser(
        'u-bob',
        'ACTIVITY_RECEIVED',
        any(),
      ),
    ).called(1);
  });

  test('ingests a self-mention for the author', () async {
    final out = await useCase.execute(
      payload: messagePayload(
        mentions: [
          {'id': '111222333'},
        ],
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-discord');
    expect(captured.senderUserId, 'u-discord');
    verify(
      () => presenceService.broadcastToUser(
        'u-discord',
        'ACTIVITY_RECEIVED',
        any(),
      ),
    ).called(1);
  });

  test('ignores messages from channels outside the allow-list', () async {
    final out = await useCase.execute(
      payload: messagePayload(channelId: 'chan-other'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'channel_not_configured');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores bot-authored messages', () async {
    final out = await useCase.execute(payload: messagePayload(bot: true));

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'invalid_message_payload');
  });

  test('ignores duplicate deliveries via Redis reservation', () async {
    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => false);

    final out = await useCase.execute(payload: messagePayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'duplicate_delivery');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('drops messages without linked mentions', () async {
    final out = await useCase.execute(
      payload: messagePayload(authorId: '999888777'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_target_mentions');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores payloads when discord provider is inactive', () async {
    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([config.copyWith(isActive: false)]),
    );

    final out = await useCase.execute(payload: messagePayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'discord_not_configured');
  });

  test('persists an untagged message for followers including the sender', () async {
    final follows = _MockFollows();
    when(
      () => follows.userIdsFor(
        providerId: 'discord',
        objectKey: 'guild-1|chan-1|msg-follow',
      ),
    ).thenAnswer((_) async => const Right(['u-discord']));
    useCase = IngestDiscordMessage(
      userRepository,
      activityRepository,
      providerConfigRepository,
      redisService,
      presenceService,
      follows: follows,
    );

    final out = await useCase.execute(
      payload: messagePayload(messageId: 'msg-follow'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-discord');
    expect(captured.senderUserId, 'u-discord');
    expect(captured.inboxLane, ActivityInboxLane.follow);
  });
}
