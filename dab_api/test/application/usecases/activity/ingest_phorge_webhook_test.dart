import 'package:dab_api/src/application/usecases/activity/ingest_phorge_webhook.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
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

class _MockConduitProtocol extends Mock implements ConduitProtocol {}

void main() {
  late _MockUserRepository userRepository;
  late _MockActivityRepository activityRepository;
  late _MockProviderConfigRepository providerConfigRepository;
  late _MockRedisService redisService;
  late _MockPresenceService presenceService;
  late _MockConduitProtocol conduit;
  late IngestPhorgeWebhook useCase;

  final user = User(
    id: 'u-ph',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    phorgePhid: 'PHID-USER-ada',
    phorgeUsername: 'ada',
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'phorge',
    name: 'Phorge',
    baseUrl: 'https://phorge.example.com',
    isActive: true,
    settings: const {'webhookHmacKey': 'k'},
  );

  final heraldPayload = <String, dynamic>{
    'object': {'type': 'TASK', 'phid': 'PHID-TASK-1'},
    'action': {'test': false, 'silent': false, 'epoch': 1767225600},
    'transactions': [
      {'phid': 'PHID-XACT-TASK-aa'},
    ],
  };

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
    conduit = _MockConduitProtocol();

    useCase = IngestPhorgeWebhook(
      userRepository,
      activityRepository,
      providerConfigRepository,
      PhorgeTaskSource(conduit),
      redisService,
      presenceService,
    );

    when(
      () => presenceService.broadcastToUser(any(), any(), any()),
    ).thenReturn(null);
    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => true);
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => Right([user]));
  });

  void stubConduitHydration({String authorPhid = 'PHID-USER-ada'}) {
    when(() => conduit.call('transaction.search', any())).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 101,
            'phid': 'PHID-XACT-TASK-aa',
            'objectPHID': 'PHID-TASK-1',
            'authorPHID': authorPhid,
            'type': 'comment',
            'comments': [
              {
                'content': {'raw': 'Looks good!'},
              },
            ],
            'dateCreated': '1767225600',
          },
          {
            'id': 102,
            'phid': 'PHID-XACT-TASK-other',
            'objectPHID': 'PHID-TASK-1',
            'authorPHID': authorPhid,
            'type': 'comment',
            'dateCreated': '1767225600',
          },
        ],
      },
    );
    when(() => conduit.call('maniphest.search', any())).thenAnswer(
      (_) async => {
        'data': [
          {
            'id': 42,
            'phid': 'PHID-TASK-1',
            'fields': {'name': 'Fix login bug'},
          },
        ],
      },
    );
  }

  test('hydrates Herald payload via Conduit and ingests the transaction',
      () async {
    stubConduitHydration();
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    // Only the notified transaction PHID is ingested, not the other rows
    // returned by transaction.search.
    verify(() => activityRepository.createActivity(any())).called(1);
    verify(() => redisService.fanOutActivity(any())).called(1);
    verify(
      () => presenceService.broadcastToUser('u-ph', 'ACTIVITY_RECEIVED', any()),
    ).called(1);
  });

  test('ignores Herald test events without touching Conduit', () async {
    final out = await useCase.execute(
      payload: {
        ...heraldPayload,
        'action': {'test': true},
      },
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'test_event');
    verifyNever(() => conduit.call(any(), any()));
  });

  test('ignores duplicate deliveries via Redis reservation', () async {
    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => false);

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'duplicate_delivery');
    verifyNever(() => conduit.call(any(), any()));
  });

  test('ignores non-task objects', () async {
    final out = await useCase.execute(
      payload: {
        ...heraldPayload,
        'object': {'type': 'DREV', 'phid': 'PHID-DREV-1'},
      },
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'unsupported_object_type:DREV');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('drops transactions authored by unmapped Phorge users', () async {
    stubConduitHydration(authorPhid: 'PHID-USER-stranger');

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_attributable_transactions');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores payloads when phorge provider is inactive', () async {
    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([config.copyWith(isActive: false)]),
    );

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'phorge_not_configured');
  });
}
