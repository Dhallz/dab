import 'package:dab_api/src/application/usecases/activity/ingest_jira_webhook.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
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
  late IngestJiraWebhook useCase;

  final user = User(
    id: 'u-jira',
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
    userId: 'u-jira',
    providerId: 'jira',
    externalId: 'acct-ada',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final recipientIdentity = UserIdentity(
    id: 'ident-2',
    userId: 'u-bob',
    providerId: 'jira',
    externalId: 'acct-bob',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'jira',
    name: 'Jira',
    baseUrl: 'https://acme.atlassian.net',
    isActive: true,
    settings: const {'webhookSecret': 's3cret'},
  );

  Map<String, dynamic> issuePayload({
    String event = 'jira:issue_updated',
    String assigneeAccountId = 'acct-ada',
    Map<String, dynamic>? comment,
    Map<String, dynamic>? changelog,
  }) {
    return <String, dynamic>{
      'webhookEvent': event,
      'issue': {
        'id': '10001',
        'key': 'DAB-7',
        'self': 'https://acme.atlassian.net/rest/api/2/issue/10001',
        'fields': {
          'summary': 'Fix login bug',
          'updated': '2026-06-30T10:00:00.000+0000',
          'status': {'name': 'In Progress'},
          'project': {'key': 'DAB'},
          'assignee': {'accountId': assigneeAccountId, 'displayName': 'Ada L.'},
        },
      },
      'comment': ?comment,
      'changelog': ?changelog,
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

    useCase = IngestJiraWebhook(
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

  test('ingests assignee-became-me on a linked identity', () async {
    final out = await useCase.execute(
      payload: issuePayload(
        changelog: {
          'items': [
            {'field': 'assignee', 'from': 'acct-other', 'to': 'acct-bob'},
          ],
        },
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(
              () => activityRepository.createActivity(captureAny()),
            ).captured.single
            as Activity;
    expect(captured.userId, 'u-bob');
    expect(captured.title, '[DAB-7] Fix login bug');
    expect(captured.provider, isA<JiraIssueProvider>());
    expect(captured.url, 'https://acme.atlassian.net/browse/DAB-7');
    verify(() => redisService.fanOutActivity(any())).called(1);
    verify(
      () =>
          presenceService.broadcastToUser('u-bob', 'ACTIVITY_RECEIVED', any()),
    ).called(1);
  });

  test('ingests comment mentions for linked recipients', () async {
    final out = await useCase.execute(
      payload: issuePayload(
        comment: {
          'id': 'c-1',
          'body': {
            'type': 'doc',
            'content': [
              {
                'type': 'mention',
                'attrs': {'id': 'acct-bob'},
              },
            ],
          },
          'created': '2026-06-30T10:00:00.000+0000',
          'author': {'accountId': 'acct-ada', 'displayName': 'Ada L.'},
        },
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured = verify(
      () => activityRepository.createActivity(captureAny()),
    ).captured;
    expect(captured, hasLength(1));
    final comment = captured.cast<Activity>().single;
    expect(comment.commentCount, 1);
    expect(comment.userId, 'u-bob');
    expect(comment.senderUserId, 'u-jira');
  });

  test('ingests comment_created mentions without issue.fields.updated', () async {
    final out = await useCase.execute(
      payload: {
        'webhookEvent': 'comment_created',
        'timestamp': 1719741600000,
        'comment': {
          'id': 'c-live',
          'body': {
            'type': 'doc',
            'content': [
              {
                'type': 'mention',
                'attrs': {'id': 'acct-bob'},
              },
            ],
          },
          'created': '2026-06-30T10:05:00.000+0000',
          'author': {'accountId': 'acct-ada', 'displayName': 'Ada L.'},
        },
        'issue': {
          'id': '10001',
          'key': 'DAB-7',
          'self': 'https://acme.atlassian.net/rest/api/2/issue/10001',
          'fields': {
            'summary': 'Fix login bug',
            'status': {'name': 'In Progress'},
            'project': {'key': 'DAB'},
            'assignee': {'accountId': 'acct-ada', 'displayName': 'Ada L.'},
          },
        },
      },
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
    verify(
      () =>
          presenceService.broadcastToUser('u-bob', 'ACTIVITY_RECEIVED', any()),
    ).called(1);
  });

  test('ignores comments without linked mentions', () async {
    final out = await useCase.execute(
      payload: issuePayload(
        event: 'comment_created',
        comment: {
          'id': 'c-2',
          'body': 'Who am I?',
          'created': '2026-06-30T10:00:00.000+0000',
          'author': {'accountId': 'acct-stranger', 'displayName': 'Guest'},
        },
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_target_mentions');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('drops unlinked mention targets', () async {
    final out = await useCase.execute(
      payload: issuePayload(
        assigneeAccountId: 'acct-stranger',
        comment: {
          'id': 'c-2',
          'body': {
            'type': 'doc',
            'content': [
              {
                'type': 'mention',
                'attrs': {'id': 'acct-stranger'},
              },
            ],
          },
          'created': '2026-06-30T10:00:00.000+0000',
          'author': {'accountId': 'acct-ada'},
        },
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_target_mentions');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores issues outside the watched project list', () async {
    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([
        config.copyWith(
          settings: const {'webhookSecret': 's3cret', 'projectKeys': 'OPS'},
        ),
      ]),
    );

    final out = await useCase.execute(payload: issuePayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'project_not_watched');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores unsupported webhook events', () async {
    final out = await useCase.execute(
      payload: issuePayload(event: 'jira:issue_deleted'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'unsupported_event:jira:issue_deleted');
    verifyNever(() => redisService.reserveIngestionEventId(any(), any()));
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

  test('ignores payloads when jira provider is inactive', () async {
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config.copyWith(isActive: false)]));

    final out = await useCase.execute(payload: issuePayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'jira_not_configured');
  });

  test(
    'reports duplicate_activity when persistence hits unique rows',
    () async {
      when(() => activityRepository.createActivity(any())).thenAnswer(
        (_) async => const Left(
          DatabaseFailure('duplicate key value violates unique constraint'),
        ),
      );

      final out = await useCase.execute(
        payload: issuePayload(
          changelog: {
            'items': [
              {'field': 'assignee', 'from': 'acct-other', 'to': 'acct-bob'},
            ],
          },
        ),
      );

      final result = out.getOrElse((_) => throw StateError('left'));
      expect(result.ingested, isFalse);
      expect(result.reason, 'duplicate_activity');
      verifyNever(() => redisService.fanOutActivity(any()));
    },
  );

  test('persists an untagged comment for followers including the author', () async {
    final follows = _MockFollows();
    when(
      () => follows.userIdsFor(providerId: 'jira', objectKey: 'DAB-7'),
    ).thenAnswer((_) async => const Right(['u-jira']));
    useCase = IngestJiraWebhook(
      userRepository,
      activityRepository,
      providerConfigRepository,
      redisService,
      presenceService,
      follows: follows,
    );

    final out = await useCase.execute(
      payload: issuePayload(
        event: 'comment_created',
        comment: {
          'id': 'c-follow',
          'body': 'Working on this',
          'created': '2026-06-30T10:00:00.000+0000',
          'author': {'accountId': 'acct-ada', 'displayName': 'Ada L.'},
        },
      ),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-jira');
    expect(captured.senderUserId, 'u-jira');
  });
}
