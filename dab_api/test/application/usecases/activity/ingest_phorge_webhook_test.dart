import 'package:dab_api/src/application/usecases/activity/ingest_phorge_webhook.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_bundle_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_task/phorge_task_wire_fields_dto.dart';
import 'package:dab_api/src/domain/dtos/phorge/phorge_transaction/phorge_transaction_dto.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/ports/i_phorge_task_hydrator.dart';
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

class _MockTaskHydrator extends Mock implements IPhorgeTaskHydrator {}

class _MockFollows extends Mock implements AbsIActivityFollowRepository {}

void main() {
  late _MockUserRepository userRepository;
  late _MockActivityRepository activityRepository;
  late _MockProviderConfigRepository providerConfigRepository;
  late _MockRedisService redisService;
  late _MockPresenceService presenceService;
  late _MockTaskHydrator hydrator;
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

  final recipient = User(
    id: 'u-bob',
    name: 'Bob',
    email: 'bob@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    phorgePhid: 'PHID-USER-bob',
    phorgeUsername: 'bob',
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

  PhorgeTaskBundleDto bundle({
    String authorPhid = 'PHID-USER-ada',
    String ownerPhid = 'PHID-USER-bob',
    String commentText = 'Looks good!',
  }) {
    return PhorgeTaskBundleDto(
      task: PhorgeTaskDto(
        id: 42,
        phid: 'PHID-TASK-1',
        fields: PhorgeTaskWireFieldsDto(
          name: 'Fix login bug',
          ownerPHID: ownerPhid,
        ),
      ),
      transactions: [
        PhorgeTransactionDto(
          id: 101,
          phid: 'PHID-XACT-TASK-aa',
          objectPHID: 'PHID-TASK-1',
          authorPHID: authorPhid,
          type: 'comment',
          commentText: commentText,
          dateCreated: DateTime.utc(2026, 1, 1),
        ),
      ],
      sprintTag: 'DS2026-01',
    );
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
    hydrator = _MockTaskHydrator();

    useCase = IngestPhorgeWebhook(
      userRepository,
      activityRepository,
      providerConfigRepository,
      hydrator,
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
  });

  test('untagged comment on an owned task does not land without Follow', () async {
    when(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    ).thenAnswer((_) async => bundle());

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_eligible_activities');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('follower receives an untagged comment, including the author', () async {
    final follows = _MockFollows();
    when(
      () => follows.userIdsFor(
        providerId: 'phorge',
        objectKey: 'PHID-TASK-1',
      ),
    ).thenAnswer((_) async => const Right(['u-ph']));
    useCase = IngestPhorgeWebhook(
      userRepository,
      activityRepository,
      providerConfigRepository,
      hydrator,
      redisService,
      presenceService,
      follows: follows,
    );
    when(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    ).thenAnswer(
      (_) async => bundle(
        ownerPhid: 'PHID-USER-bob',
        commentText: 'Working on this',
      ),
    );
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-ph');
    expect(captured.senderUserId, 'u-ph');
    expect(captured.inboxLane, ActivityInboxLane.follow);
  });

  test('ignores Herald test events without hydrating', () async {
    final out = await useCase.execute(
      payload: {
        ...heraldPayload,
        'action': {'test': true},
      },
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'test_event');
    verifyNever(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    );
  });

  test('ignores duplicate deliveries via Redis reservation', () async {
    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => false);

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'duplicate_delivery');
    verifyNever(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    );
  });

  test('ingests DREV comments for mentioned users', () async {
    when(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    ).thenAnswer(
      (_) async => bundle(
        ownerPhid: 'PHID-USER-ada',
        commentText: 'Please look @bob',
      ),
    );
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    final out = await useCase.execute(
      payload: {
        ...heraldPayload,
        'object': {'type': 'DREV', 'phid': 'PHID-DREV-1'},
      },
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-bob');
  });

  test('ingests a self-mention on the author\'s own task', () async {
    when(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    ).thenAnswer(
      (_) async => bundle(
        ownerPhid: 'PHID-USER-ada',
        commentText: 'Note to self @ada',
      ),
    );
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-ph');
    expect(captured.senderUserId, 'u-ph');
  });

  test('ignores a comment on the author\'s own task without a mention', () async {
    when(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    ).thenAnswer(
      (_) async => bundle(
        ownerPhid: 'PHID-USER-ada',
        commentText: 'Working on this',
      ),
    );

    final out = await useCase.execute(payload: heraldPayload);

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_eligible_activities');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('drops transactions authored by unmapped Phorge users', () async {
    when(
      () => hydrator.fetchBundleForWebhook(
        taskPhid: any(named: 'taskPhid'),
        transactionPhids: any(named: 'transactionPhids'),
      ),
    ).thenAnswer((_) async => bundle(authorPhid: 'PHID-USER-stranger'));

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
