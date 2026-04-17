import 'package:dab_api/src/application/usecases/activity/ingest_slack_event.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/websockets/presence_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockActivityRepository extends Mock implements AbsIActivityRepository {}

class _MockProviderConfigRepository extends Mock
    implements AbsIProviderConfigRepository {}

class _MockRedisService extends Mock implements RedisService {}

class _MockPresenceService extends Mock implements PresenceService {}

void main() {
  late _MockUserRepository userRepository;
  late _MockActivityRepository activityRepository;
  late _MockProviderConfigRepository providerConfigRepository;
  late _MockRedisService redisService;
  late _MockPresenceService presenceService;
  late IngestSlackEvent useCase;

  setUpAll(() {
    registerFallbackValue(<String>[]);
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

    useCase = IngestSlackEvent(
      userRepository,
      activityRepository,
      providerConfigRepository,
      redisService,
      presenceService,
    );
    when(() => presenceService.broadcast(any(), any())).thenReturn(null);
    when(
      () => presenceService.broadcastToUser(any(), any(), any()),
    ).thenReturn(null);
  });

  test('ingests linked Slack message callback', () async {
    final user = User(
      id: 'u-1',
      name: 'Alice',
      email: 'alice@example.com',
      passwordHash: 'hash',
      role: UserRole.standard,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final identity = UserIdentity(
      id: 'i-1',
      userId: 'u-1',
      providerId: 'slack',
      externalId: 'U123',
      externalUsername: 'alice.slack',
      status: UserIdentityStatus.linked,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final config = ProviderConfig(
      id: 'slack',
      name: 'Slack',
      baseUrl: 'https://slack.com',
      isActive: true,
      settings: const {'signingSecret': 'secret'},
    );

    when(
      () => redisService.reserveSlackEventId('Ev1'),
    ).thenAnswer((_) async => true);
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => Right([user]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), 'slack'),
    ).thenAnswer((_) async => Right([identity]));
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    final result = await useCase.execute({
      'type': 'event_callback',
      'event_id': 'Ev1',
      'team_id': 'T1',
      'event': {
        'type': 'message',
        'user': 'U123',
        'channel': 'C1',
        'text': '<@U123> hello',
        'ts': '1712950000.100000',
      },
    });

    expect(result.isRight(), isTrue);
    final summary = result.getOrElse(
      (_) => const SlackEventIngestionResult.ignored('x'),
    );
    expect(summary.ingested, isTrue);
    verify(() => activityRepository.createActivity(any())).called(1);
    verify(() => redisService.fanOutActivity(any())).called(1);
  });

  test('ignores duplicate event id', () async {
    when(
      () => redisService.reserveSlackEventId('Ev1'),
    ).thenAnswer((_) async => false);

    final result = await useCase.execute({
      'type': 'event_callback',
      'event_id': 'Ev1',
      'event': {'type': 'message'},
    });

    expect(result.isRight(), isTrue);
    final summary = result.getOrElse(
      (_) => const SlackEventIngestionResult.ignored('x'),
    );
    expect(summary.ingested, isFalse);
    expect(summary.reason, 'duplicate_event_id');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores Slack message without mention target', () async {
    final admin = User(
      id: 'admin-1',
      name: 'Admin',
      email: 'admin@example.com',
      passwordHash: 'hash',
      role: UserRole.admin,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final config = ProviderConfig(
      id: 'slack',
      name: 'Slack',
      baseUrl: 'https://slack.com',
      isActive: true,
      settings: const {'signingSecret': 'secret'},
    );
    final linkedIdentity = UserIdentity(
      id: 'i-admin',
      userId: 'admin-1',
      providerId: 'slack',
      externalId: 'U111',
      externalUsername: 'admin.slack',
      status: UserIdentityStatus.linked,
      createdAt: DateTime.utc(2026, 1, 1),
    );

    when(
      () => redisService.reserveSlackEventId('Ev2'),
    ).thenAnswer((_) async => true);
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => Right([admin]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), 'slack'),
    ).thenAnswer((_) async => Right([linkedIdentity]));
    when(
      () => userRepository.getAllIdentities(),
    ).thenAnswer((_) async => const Right([]));

    final result = await useCase.execute({
      'type': 'event_callback',
      'event_id': 'Ev2',
      'team_id': 'T1',
      'event': {
        'type': 'message',
        'user': 'U999',
        'channel': 'C1',
        'text': 'hello from unlinked user',
        'ts': '1712950000.200000',
      },
    });

    expect(result.isRight(), isTrue);
    final summary = result.getOrElse(
      (_) => const SlackEventIngestionResult.ignored('x'),
    );
    expect(summary.ingested, isFalse);
    expect(summary.reason, 'no_target_mentions');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('matches linked identity with normalized slack external id', () async {
    final user = User(
      id: 'u-2',
      name: 'Bob',
      email: 'bob@example.com',
      passwordHash: 'hash',
      role: UserRole.standard,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final identity = UserIdentity(
      id: 'i-2',
      userId: 'u-2',
      providerId: 'Slack',
      externalId: '<@u123>',
      externalUsername: 'bob.slack',
      status: UserIdentityStatus.linked,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final config = ProviderConfig(
      id: 'slack',
      name: 'Slack',
      baseUrl: 'https://slack.com',
      isActive: true,
      settings: const {'signingSecret': 'secret'},
    );

    when(
      () => redisService.reserveSlackEventId('Ev3'),
    ).thenAnswer((_) async => true);
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => Right([user]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), 'slack'),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => userRepository.getAllIdentities(),
    ).thenAnswer((_) async => Right([identity]));
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    final result = await useCase.execute({
      'type': 'event_callback',
      'event_id': 'Ev3',
      'team_id': 'T1',
      'event': {
        'type': 'message',
        'user': 'U123',
        'channel': 'C9',
        'text': '<@U123> case-insensitive id match',
        'ts': '1712950000.300000',
      },
    });

    expect(result.isRight(), isTrue);
    final summary = result.getOrElse(
      (_) => const SlackEventIngestionResult.ignored('x'),
    );
    expect(summary.ingested, isTrue);

    final capturedActivity =
        verify(
              () => activityRepository.createActivity(captureAny()),
            ).captured.single
            as Activity;
    expect(capturedActivity.userId, user.id);
    expect(capturedActivity.authorName, 'bob.slack');
  });

  test('broadcast mention fans out to all linked users', () async {
    final alice = User(
      id: 'u-1',
      name: 'Alice',
      email: 'alice@example.com',
      passwordHash: 'hash',
      role: UserRole.standard,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final bob = User(
      id: 'u-2',
      name: 'Bob',
      email: 'bob@example.com',
      passwordHash: 'hash',
      role: UserRole.standard,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final senderIdentity = UserIdentity(
      id: 'i-1',
      userId: 'u-1',
      providerId: 'slack',
      externalId: 'U123',
      externalUsername: 'alice.slack',
      status: UserIdentityStatus.linked,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final recipientIdentity = UserIdentity(
      id: 'i-2',
      userId: 'u-2',
      providerId: 'slack',
      externalId: 'U777',
      externalUsername: 'bob.slack',
      status: UserIdentityStatus.linked,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final config = ProviderConfig(
      id: 'slack',
      name: 'Slack',
      baseUrl: 'https://slack.com',
      isActive: true,
      settings: const {'signingSecret': 'secret'},
    );

    when(
      () => redisService.reserveSlackEventId('Ev4'),
    ).thenAnswer((_) async => true);
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => Right([alice, bob]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), 'slack'),
    ).thenAnswer((_) async => Right([senderIdentity, recipientIdentity]));
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    final result = await useCase.execute({
      'type': 'event_callback',
      'event_id': 'Ev4',
      'team_id': 'T1',
      'event': {
        'type': 'message',
        'user': 'U123',
        'channel': 'C9',
        'text': '<!channel> heads up team',
        'ts': '1712950000.400000',
      },
    });

    expect(result.isRight(), isTrue);
    final summary = result.getOrElse(
      (_) => const SlackEventIngestionResult.ignored('x'),
    );
    expect(summary.ingested, isTrue);
    verify(() => activityRepository.createActivity(any())).called(2);
    verify(() => redisService.fanOutActivity(any())).called(2);
    verify(
      () => presenceService.broadcastToUser(any(), any(), any()),
    ).called(2);
  });
}
