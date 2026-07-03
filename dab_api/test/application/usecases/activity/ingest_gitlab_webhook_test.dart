import 'package:dab_api/src/application/usecases/activity/ingest_gitlab_webhook.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
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
  late IngestGitLabWebhook useCase;

  final user = User(
    id: 'u-gitlab',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'gitlab',
    name: 'GitLab',
    baseUrl: 'https://gitlab.example.com',
    isActive: true,
    settings: const {'apiToken': 't', 'webhookSecret': 's'},
  );

  Map<String, dynamic> pushPayload({String authorEmail = 'ada@example.com'}) {
    return <String, dynamic>{
      'object_kind': 'push',
      'ref': 'refs/heads/main',
      'checkout_sha': 'abc123',
      'project': {'path_with_namespace': 'group/project'},
      'commits': [
        {
          'id': 'abc123',
          'message': 'Fix login bug\n\nDetails here.',
          'timestamp': '2026-06-30T10:00:00+00:00',
          'url': 'https://gitlab.example.com/group/project/-/commit/abc123',
          'author': {'name': 'Ada L.', 'email': authorEmail},
        },
      ],
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

    useCase = IngestGitLabWebhook(
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
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => true);
    when(
      () => providerConfigRepository.getConfigs(),
    ).thenAnswer((_) async => Right([config]));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => Right([user]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});
  });

  test('ingests push commits attributed by author email', () async {
    final out = await useCase.execute(payload: pushPayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-gitlab');
    expect(captured.title, '[main] Fix login bug');
    final provider = captured.provider as GitLabCommitProvider;
    expect(provider.project, 'group/project');
    expect(provider.branch, 'main');
    verify(() => redisService.fanOutActivity(any())).called(1);
    verify(
      () => presenceService.broadcastToUser(
        'u-gitlab',
        'ACTIVITY_RECEIVED',
        any(),
      ),
    ).called(1);
  });

  test('ignores non-push events', () async {
    final out = await useCase.execute(
      payload: {...pushPayload(), 'object_kind': 'merge_request'},
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'unsupported_event:merge_request');
    verifyNever(() => redisService.reserveIngestionEventId(any(), any()));
  });

  test('ignores duplicate deliveries via Redis reservation', () async {
    when(
      () => redisService.reserveIngestionEventId(any(), any()),
    ).thenAnswer((_) async => false);

    final out = await useCase.execute(payload: pushPayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'duplicate_delivery');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('drops commits from unknown author emails', () async {
    final out = await useCase.execute(
      payload: pushPayload(authorEmail: 'stranger@example.com'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isFalse);
    expect(result.reason, 'no_attributable_users');
    verifyNever(() => activityRepository.createActivity(any()));
  });

  test('ignores payloads when gitlab provider is inactive', () async {
    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([config.copyWith(isActive: false)]),
    );

    final out = await useCase.execute(payload: pushPayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'gitlab_not_configured');
  });
}
