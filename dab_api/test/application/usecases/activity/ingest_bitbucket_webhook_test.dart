import 'package:dab_api/src/application/usecases/activity/ingest_bitbucket_webhook.dart';
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
  late IngestBitbucketWebhook useCase;

  final user = User(
    id: 'u-bb',
    name: 'Ada',
    email: 'ada@example.com',
    passwordHash: 'hash',
    role: UserRole.standard,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final identity = UserIdentity(
    id: 'ident-1',
    userId: 'u-bb',
    providerId: 'bitbucket',
    externalId: 'acct-bb-ada',
    status: UserIdentityStatus.linked,
    createdAt: DateTime.utc(2026, 1, 1),
  );

  final config = ProviderConfig(
    id: 'bitbucket',
    name: 'Bitbucket',
    baseUrl: 'https://bitbucket.org',
    isActive: true,
    settings: const {
      'username': 'ada',
      'apiToken': 'app-password',
      'workspace': 'acme',
      'webhookSecret': 's',
    },
  );

  Map<String, dynamic> pushPayload({String accountId = 'acct-bb-ada'}) {
    return <String, dynamic>{
      'repository': {'full_name': 'acme/widget'},
      'push': {
        'changes': [
          {
            'new': {
              'type': 'branch',
              'name': 'main',
              'target': {'hash': 'abc123'},
            },
            'commits': [
              {
                'hash': 'abc123',
                'message': 'Fix login bug',
                'date': '2026-06-30T10:00:00+00:00',
                'links': {
                  'html': {
                    'href': 'https://bitbucket.org/acme/widget/commits/abc123',
                  },
                },
                'author': {
                  'raw': 'Ada L. <ada@example.com>',
                  'user': {'account_id': accountId, 'display_name': 'Ada L.'},
                },
              },
            ],
          },
        ],
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

    useCase = IngestBitbucketWebhook(
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
    ).thenAnswer((_) async => Right([user]));
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
    ).thenAnswer((_) async => Right([identity]));
    when(
      () => activityRepository.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => redisService.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redisService.fanOutActivity(any())).thenAnswer((_) async {});
  });

  test('ingests repo:push commits attributed by account id', () async {
    final out = await useCase.execute(
      payload: pushPayload(),
      deliveryId: 'req-uuid-1',
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-bb');
    expect(captured.title, '[main] Fix login bug');
    final provider = captured.provider as BitbucketCommitProvider;
    expect(provider.repo, 'acme/widget');
    expect(provider.branch, 'main');
    verify(
      () => redisService.reserveIngestionEventId('bitbucket', 'req-uuid-1'),
    ).called(1);
  });

  test('falls back to raw signature email attribution', () async {
    when(
      () => userRepository.getIdentitiesForUsersAndProvider(any(), any()),
    ).thenAnswer((_) async => const Right([]));

    final out = await useCase.execute(
      payload: pushPayload(accountId: 'someone-else'),
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.ingested, isTrue);
    final captured =
        verify(() => activityRepository.createActivity(captureAny()))
            .captured
            .single as Activity;
    expect(captured.userId, 'u-bb');
  });

  test('ignores non-push payloads', () async {
    final out = await useCase.execute(
      payload: {
        'repository': {'full_name': 'acme/widget'},
      },
    );

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'unsupported_event');
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

  test('ignores payloads when bitbucket provider is inactive', () async {
    when(() => providerConfigRepository.getConfigs()).thenAnswer(
      (_) async => Right([config.copyWith(isActive: false)]),
    );

    final out = await useCase.execute(payload: pushPayload());

    final result = out.getOrElse((_) => throw StateError('left'));
    expect(result.reason, 'bitbucket_not_configured');
  });
}
