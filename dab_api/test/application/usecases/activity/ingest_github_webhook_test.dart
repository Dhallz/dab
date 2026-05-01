import 'package:dab_api/src/application/usecases/activity/ingest_github_webhook.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_identity.dart';
import 'package:dab_api/src/domain/entities/user/user_identity_status.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/mappers/github/github_commit_mapper.dart';
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
  late IngestGitHubWebhook useCase;

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

    useCase = IngestGitHubWebhook(
      userRepository,
      activityRepository,
      providerConfigRepository,
      redisService,
      presenceService,
      GitHubCommitMapper(),
    );

    when(() => presenceService.broadcast(any(), any())).thenReturn(null);
    when(
      () => presenceService.broadcastToUser(any(), any(), any()),
    ).thenReturn(null);
  });

  test('ingests push webhook for linked github author', () async {
    final user = User(
      id: 'u-gh',
      name: 'Ada',
      email: 'ada@example.com',
      passwordHash: 'hash',
      role: UserRole.standard,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final identity = UserIdentity(
      id: 'ig-1',
      userId: 'u-gh',
      providerId: 'github',
      externalId: 'adal',
      externalUsername: 'adal',
      status: UserIdentityStatus.linked,
      createdAt: DateTime.utc(2026, 1, 1),
    );
    final config = ProviderConfig(
      id: 'github',
      name: 'GitHub',
      baseUrl: 'https://github.com',
      isActive: true,
      settings: const {
        'owner': 'Acme',
        'repo': 'app',
        'webhookSecret': 'x',
      },
    );

    final payload = <String, dynamic>{
      'repository': {'full_name': 'Acme/app'},
      'ref': 'refs/heads/main',
      'commits': [
        {
          'id': 'abcd1234',
          'distinct': true,
          'message': 'fix it',
          'timestamp': '2026-03-01T12:00:00Z',
          'url': 'https://github.com/Acme/app/commit/abcd1234',
          'author': {'name': 'Ada', 'username': 'adal'},
        },
      ],
    };

    when(() => redisService.reserveGitHubDeliveryId(any())).thenAnswer(
      (_) async => true,
    );
    when(() => userRepository.getUsers()).thenAnswer((_) async => Right([user]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), 'github'),
    ).thenAnswer((_) async => Right([identity]));
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 42);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});

    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([config]),
    );

    final out = await useCase.execute(
      payload: payload,
      deliveryId: 'del-1',
      event: 'push',
    );

    expect(out.isRight(), isTrue);
    expect(
      out.getOrElse(
        (_) => throw StateError('left'),
      ).ingested,
      isTrue,
    );
    verify(() => activityRepository.createActivity(any())).called(1);
    verify(() => redisService.fanOutActivity(any())).called(1);
    verify(
      () => presenceService.broadcastToUser('u-gh', 'ACTIVITY_RECEIVED', any()),
    ).called(1);
  });

  test('ignores duplicate delivery ids', () async {
    when(
      () => redisService.reserveGitHubDeliveryId('dup'),
    ).thenAnswer((_) async => false);

    final out = await useCase.execute(
      payload: <String, dynamic>{},
      deliveryId: 'dup',
      event: 'push',
    );

    final r = out.getOrElse(
      (_) => const GitHubWebhookIngestionResult.ignored('bad'),
    );
    expect(r.ingested, isFalse);
    expect(r.reason, 'duplicate_delivery_id');
    verifyNever(() => userRepository.getUsers());
  });

  test('ignores push for repo outside configured allow-list', () async {
    when(
      () => redisService.reserveGitHubDeliveryId(any()),
    ).thenAnswer((_) async => true);
    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([
        ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.com',
          isActive: true,
          settings: const {'owner': 'Acme', 'repo': 'app'},
        ),
      ]),
    );

    final out = await useCase.execute(
      payload: <String, dynamic>{
        'repository': {'full_name': 'evil/other'},
      },
      deliveryId: 'del-9',
      event: 'push',
    );

    final r = out.getOrElse((_) => throw StateError('expected right'));
    expect(r.reason, 'repo_not_configured');
    verifyNever(() => activityRepository.createActivity(any()));
  });
}
