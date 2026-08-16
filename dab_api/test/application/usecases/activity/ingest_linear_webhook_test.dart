import 'package:dab_api/src/application/usecases/activity/ingest_linear_webhook.dart';
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
  late IngestLinearWebhook useCase;

  final user = User(
    id: 'u-linear',
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

  final identity = UserIdentity(
    id: 'ident-1',
    userId: 'u-linear',
    providerId: 'linear',
    externalId: 'linear-user-ada',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final recipientIdentity = UserIdentity(
    id: 'ident-2',
    userId: 'u-bob',
    providerId: 'linear',
    externalId: 'linear-user-bob',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'linear',
    name: 'Linear',
    baseUrl: 'https://linear.app',
    isActive: true,
    settings: const {'apiKey': 'k', 'webhookSecret': 's'},
  );

  Map<String, dynamic> issuePayload({
    String action = 'update',
    String type = 'Issue',
    String assigneeId = 'linear-user-ada',
    Map<String, dynamic>? updatedFrom,
  }) {
    return <String, dynamic>{
      'type': type,
      'action': action,
      'url': 'https://linear.app/acme/issue/ENG-42/fix-login',
      'updatedFrom': ?updatedFrom,
      'data': {
        'id': 'issue-uuid',
        'identifier': 'ENG-42',
        'title': 'Fix login',
        'updatedAt': '2026-06-30T10:00:00.000Z',
        'assigneeId': assigneeId,
        'state': {'name': 'In Progress'},
        'team': {'key': 'ENG'},
      },
    };
  }

  Map<String, dynamic> commentPayload({
    String action = 'create',
    String userId = 'linear-user-ada',
    String? body = 'Can you take a look?',
  }) {
    return <String, dynamic>{
      'type': 'Comment',
      'action': action,
      'createdAt': '2026-06-30T10:05:00.000Z',
      'url': 'https://linear.app/acme/issue/ENG-42#comment-1',
      'actor': {'id': userId, 'name': 'Ada L.'},
      'data': {
        'id': 'comment-1',
        'body': body,
        'createdAt': '2026-06-30T10:05:00.000Z',
        'userId': userId,
        'issue': {
          'id': 'issue-uuid',
          'identifier': 'ENG-42',
          'title': 'Fix login',
          'url': 'https://linear.app/acme/issue/ENG-42/fix-login',
          'updatedAt': '2026-06-30T10:05:00.000Z',
          'assigneeId': 'linear-user-ada',
          'state': {'name': 'In Progress'},
          'team': {'key': 'ENG'},
        },
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

    useCase = IngestLinearWebhook(
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

  test('ingests an Issue update when assignee became a linked user', () async {
    final out = await useCase.execute(
      payload: issuePayload(
        assigneeId: 'linear-user-bob',
        updatedFrom: {'assigneeId': 'linear-user-ada'},
      ),
      deliveryId: 'delivery-1',
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(
              () => activityRepository.createActivity(captureAny()),
            ).captured.single
            as Activity;
    expect(captured.userId, 'u-bob');
    expect(captured.title, '[ENG-42] Fix login');
    final provider = captured.provider as LinearIssueProvider;
    expect(provider.identifier, 'ENG-42');
    expect(provider.teamKey, 'ENG');
    expect(provider.statusName, 'In Progress');
    verify(
      () => redisService.reserveIngestionEventId('linear', 'delivery-1'),
    ).called(1);
    verify(
      () => presenceService.broadcastToUser(
        'u-bob',
        'ACTIVITY_RECEIVED',
        any(),
      ),
    ).called(1);
  });

  test('ignores Project payloads', () async {
    final out = await useCase.execute(payload: issuePayload(type: 'Project'));

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'unsupported_type:Project');
    verifyNever(() => redisService.reserveIngestionEventId(any(), any()));
  });

  test('ingests a Comment mention as a distinct live activity', () async {
    final out = await useCase.execute(
      payload: commentPayload(body: '@[Bob](linear-user-bob) Can you take a look?'),
      deliveryId: 'delivery-comment-1',
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(
              () => activityRepository.createActivity(captureAny()),
            ).captured.single
            as Activity;
    expect(captured.commentCount, 1);
    expect(captured.userId, 'u-bob');
    expect(captured.senderUserId, 'u-linear');
    expect((captured.provider as LinearIssueProvider).identifier, 'ENG-42');
    verify(
      () => presenceService.broadcastToUser(
        'u-bob',
        'ACTIVITY_RECEIVED',
        any(),
      ),
    ).called(1);
  });

  test('comment from an unmapped author still notifies mentioned users', () async {
    final out = await useCase.execute(
      payload: commentPayload(
        userId: 'linear-user-stranger',
        body: '@[Ada](linear-user-ada) please review',
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(
              () => activityRepository.createActivity(captureAny()),
            ).captured.single
            as Activity;
    expect(captured.commentCount, 1);
    expect(captured.userId, 'u-linear');
  });

  test('ignores unsupported actions', () async {
    final out = await useCase.execute(payload: issuePayload(action: 'remove'));

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'unsupported_action:remove');
  });

  test('ignores duplicate deliveries via Redis reservation', () async {
    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => false);

    final out = await useCase.execute(payload: issuePayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'duplicate_delivery');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('drops issues whose assignee/creator is not linked', () async {
    final out = await useCase.execute(
      payload: issuePayload(assigneeId: 'linear-user-stranger'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_target_mentions');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores issues whose team is not on the instance watch list', () async {
    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([
        config.copyWith(
          settings: {'apiKey': 'k', 'webhookSecret': 's', 'teamKeys': 'OPS'},
        ),
      ]),
    );

    final out = await useCase.execute(payload: issuePayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'team_not_watched');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores payloads when linear provider is inactive', () async {
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config.copyWith(isActive: false)]));

    final out = await useCase.execute(payload: issuePayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'linear_not_configured');
  });

  test('persists an untagged comment for followers including the author', () async {
    final follows = _MockFollows();
    when(
      () => follows.userIdsFor(providerId: 'linear', objectKey: 'ENG-42'),
    ).thenAnswer((_) async => const Right(['u-linear']));
    useCase = IngestLinearWebhook(
      userRepository,
      activityRepository,
      providerConfigRepository,
      redisService,
      presenceService,
      follows: follows,
    );

    final out = await useCase.execute(
      payload: commentPayload(body: 'Working on this'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-linear');
  });
}
