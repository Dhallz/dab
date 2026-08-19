import 'package:dab_api/src/application/usecases/activity/ingest_figma_webhook.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/figma/figma_file_meta.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_figma_file_gateway.dart';
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

class _MockFigmaGateway extends Mock implements AbsIFigmaFileGateway {}

void main() {
  late _MockUserRepository userRepository;
  late _MockActivityRepository activityRepository;
  late _MockProviderConfigRepository providerConfigRepository;
  late _MockRedisService redisService;
  late _MockPresenceService presenceService;
  late _MockFollows follows;
  late _MockFigmaGateway gateway;
  late IngestFigmaWebhook useCase;

  final user = User(
    id: 'u-alice',
    name: 'Alice',
    email: 'alice@example.com',
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

  final identity = UserIdentity(
    id: 'ident-1',
    userId: 'u-alice',
    providerId: 'figma',
    externalId: 'fig-alice',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final recipientIdentity = UserIdentity(
    id: 'ident-2',
    userId: 'u-bob',
    providerId: 'figma',
    externalId: 'fig-bob',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  const config = ProviderConfig(
    id: 'figma',
    name: 'Figma',
    baseUrl: 'https://www.figma.com',
    settings: {'webhookSecret': 'pass'},
  );

  Map<String, dynamic> commentPayload({
    List<Map<String, dynamic>> mentions = const [],
    String message = 'Please take a look',
  }) {
    return {
      'event_type': 'FILE_COMMENT',
      'file_key': 'Abc123File',
      'file_name': 'Onboarding',
      'timestamp': '2026-08-01T12:00:00Z',
      'passcode': 'pass',
      'triggered_by': {'id': 'fig-alice', 'handle': 'Alice'},
      'comment': [
        {
          'id': 'c-1',
          'message': message,
          'created_at': '2026-08-01T12:00:00Z',
          'mentions': mentions,
        },
      ],
    };
  }

  setUpAll(() {
    registerFallbackValue(user);
    registerFallbackValue(
      Activity(
        id: 'fallback',
        userId: 'u-alice',
        provider: const FigmaFileProvider(fileKey: 'Abc123File'),
        title: 't',
        content: 'c',
        authorName: 'Alice',
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
    follows = _MockFollows();
    gateway = _MockFigmaGateway();

    useCase = IngestFigmaWebhook(
      userRepository,
      activityRepository,
      providerConfigRepository,
      redisService,
      presenceService,
      follows: follows,
      fileGateway: gateway,
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
    when(
      () => activityRepository.upsertActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});
    when(
      () => redisService.replaceFanOutActivity(any()),
    ).thenAnswer((_) async {});
    when(
      () => follows.userIdsFor(
        providerId: any(named: 'providerId'),
        objectKey: any(named: 'objectKey'),
      ),
    ).thenAnswer((_) async => const Right([]));
    when(() => gateway.fetchFileMeta(any())).thenAnswer((_) async => null);
  });

  test('Directed mention plus Follow overlap emits two lanes', () async {
    when(
      () => follows.userIdsFor(
        providerId: 'figma',
        objectKey: 'Abc123File',
      ),
    ).thenAnswer((_) async => const Right(['u-bob']));

    final out = await useCase.execute(
      payload: commentPayload(
        mentions: [
          {'id': 'fig-bob'},
        ],
      ),
    );

    expect(out.getOrElse((_) => throw StateError('left')).ingested, isTrue);
    final captured = verify(
      () => activityRepository.createActivity(captureAny()),
    ).captured.cast<Activity>();
    expect(captured, hasLength(2));
    expect(
      captured.map((a) => a.inboxLane).toSet(),
      {ActivityInboxLane.directed, ActivityInboxLane.follow},
    );
    expect(captured.every((a) => a.userId == 'u-bob'), isTrue);
    expect(captured.map((a) => a.id).toSet(), hasLength(2));
  });

  test('unmentioned comment is Following-only', () async {
    when(
      () => follows.userIdsFor(
        providerId: 'figma',
        objectKey: 'Abc123File',
      ),
    ).thenAnswer((_) async => const Right(['u-bob']));

    final out = await useCase.execute(payload: commentPayload());

    expect(out.getOrElse((_) => throw StateError('left')).ingested, isTrue);
    final captured = verify(
      () => activityRepository.createActivity(captureAny()),
    ).captured.cast<Activity>();
    expect(captured, hasLength(1));
    expect(captured.single.inboxLane, ActivityInboxLane.follow);
    expect(captured.single.userId, 'u-bob');
  });

  test('PING and unsupported events are ignored', () async {
    final ping = await useCase.execute(
      payload: {'event_type': 'PING', 'passcode': 'pass'},
    );
    expect(ping.getOrElse((_) => throw StateError('left')).reason, 'ping');

    final other = await useCase.execute(
      payload: {
        'event_type': 'FILE_DELETE',
        'file_key': 'Abc123File',
        'passcode': 'pass',
      },
    );
    expect(
      other.getOrElse((_) => throw StateError('left')).reason,
      'unsupported_event:FILE_DELETE',
    );
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('FILE_UPDATE upserts a stable last-edited Following id', () async {
    when(
      () => follows.userIdsFor(
        providerId: 'figma',
        objectKey: 'Abc123File',
      ),
    ).thenAnswer((_) async => const Right(['u-bob']));
    when(() => gateway.fetchFileMeta('Abc123File')).thenAnswer(
      (_) async => FigmaFileMeta(
        fileKey: 'Abc123File',
        name: 'DAB',
        folderName: 'dajo. Plugin',
        lastTouchedById: 'fig-alice',
        lastTouchedByHandle: 'Alice',
        lastTouchedAt: DateTime.utc(2026, 8, 1, 15),
      ),
    );

    final first = await useCase.execute(
      payload: {
        'event_type': 'FILE_UPDATE',
        'file_key': 'Abc123File',
        'file_name': 'Onboarding',
        'timestamp': '2026-08-01T15:00:00Z',
      },
    );
    expect(first.getOrElse((_) => throw StateError('left')).ingested, isTrue);

    final captured = verify(
      () => activityRepository.upsertActivity(captureAny()),
    ).captured.cast<Activity>();
    expect(captured, hasLength(1));
    expect(captured.single.inboxLane, ActivityInboxLane.follow);
    expect(captured.single.userId, 'u-bob');
    expect(captured.single.title, '[dajo. Plugin] DAB');
    expect(captured.single.content, 'last edited by Alice');
    expect(captured.single.provider, isA<FigmaFileProvider>());
    verify(() => redisService.replaceFanOutActivity(any())).called(1);

    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => true);
    when(() => gateway.fetchFileMeta('Abc123File')).thenAnswer(
      (_) async => FigmaFileMeta(
        fileKey: 'Abc123File',
        name: 'DAB',
        folderName: 'dajo. Plugin',
        lastTouchedById: 'fig-alice',
        lastTouchedByHandle: 'Alice',
        lastTouchedAt: DateTime.utc(2026, 8, 1, 16),
      ),
    );

    await useCase.execute(
      payload: {
        'event_type': 'FILE_UPDATE',
        'file_key': 'Abc123File',
        'file_name': 'Onboarding',
        'timestamp': '2026-08-01T16:00:00Z',
      },
    );
    final second = verify(
      () => activityRepository.upsertActivity(captureAny()),
    ).captured.cast<Activity>();
    expect(second.last.id, captured.single.id);
    expect(second.last.createdAt, DateTime.utc(2026, 8, 1, 16));
  });

  test('FILE_UPDATE without meta still emits Edited recently', () async {
    when(
      () => follows.userIdsFor(
        providerId: 'figma',
        objectKey: 'Abc123File',
      ),
    ).thenAnswer((_) async => const Right(['u-bob']));
    when(() => gateway.fetchFileMeta('Abc123File')).thenAnswer((_) async => null);

    final out = await useCase.execute(
      payload: {
        'event_type': 'FILE_UPDATE',
        'file_key': 'Abc123File',
        'file_name': 'Onboarding',
        'timestamp': '2026-08-01T15:00:00Z',
      },
    );
    expect(out.getOrElse((_) => throw StateError('left')).ingested, isTrue);
    final captured = verify(
      () => activityRepository.upsertActivity(captureAny()),
    ).captured.cast<Activity>();
    expect(captured.single.title, 'Onboarding');
    expect(captured.single.content, 'Edited recently');
  });

  test('FILE_UPDATE with no Followers is ignored', () async {
    final out = await useCase.execute(
      payload: {
        'event_type': 'FILE_UPDATE',
        'file_key': 'Abc123File',
        'timestamp': '2026-08-01T15:00:00Z',
      },
    );
    expect(
      out.getOrElse((_) => throw StateError('left')).reason,
      'no_file_followers',
    );
    verifyNever(() => activityRepository.upsertActivity(any()));
  });
}
