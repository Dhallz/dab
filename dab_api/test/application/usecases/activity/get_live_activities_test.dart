import 'package:dab_api/src/application/usecases/activity/get_live_activities.dart';
import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockRedisService extends Mock implements RedisService {}

class _MockActivityRepository extends Mock implements AbsIActivityRepository {}

void main() {
  late _MockRedisService redisService;
  late _MockActivityRepository activityRepo;
  late GetLiveActivities useCase;

  setUp(() {
    redisService = _MockRedisService();
    activityRepo = _MockActivityRepository();
    useCase = GetLiveActivities(redisService, activityRepo);
  });

  test('returns live activities from Redis for user scope', () async {
    final activity = TestData.activity(userId: 'u-1');
    when(
      () => redisService.getLiveActivities(
        userId: 'u-1',
        limit: 25,
        global: false,
        includeArchived: false,
      ),
    ).thenAnswer((_) async => [activity]);

    final result = await useCase.execute(userId: 'u-1', limit: 25);

    expect(result.isRight(), isTrue);
    expect(result.getOrElse((_) => []), hasLength(1));
    verifyZeroInteractions(activityRepo);
  });

  test('fallbacks to Postgres when user-scoped Redis list is empty', () async {
    final activity = TestData.activity(userId: 'u-42');
    when(
      () => redisService.getLiveActivities(
        userId: 'u-42',
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer((_) async => const []);

    final startUtc = RedisService.liveFeedStartOfTodayUtc();

    when(
      () => activityRepo.getActivitiesByUser(
        'u-42',
        createdOnOrAfterUtc: startUtc,
        limit: 50,
      ),
    ).thenAnswer((_) async => Right([activity]));

    final result = await useCase.execute(
      userId: 'u-42',
      includeArchived: true,
    );

    expect(result.isRight(), isTrue);
    expect(result.getOrElse((_) => []), equals([activity]));
    verify(
      () => redisService.getLiveActivities(
        userId: 'u-42',
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).called(1);
    verify(
      () => activityRepo.getActivitiesByUser(
        'u-42',
        createdOnOrAfterUtc: startUtc,
        limit: 50,
      ),
    ).called(1);
  });

  test('does not hit Postgres fallback for global Redis scope', () async {
    when(
      () => redisService.getLiveActivities(
        userId: 'u-99',
        limit: 10,
        global: true,
        includeArchived: false,
      ),
    ).thenAnswer((_) async => const []);

    final result = await useCase.execute(
      userId: 'u-99',
      limit: 10,
      global: true,
    );

    expect(result.isRight(), isTrue);
    expect(result.getOrElse((_) => []), isEmpty);
    verifyZeroInteractions(activityRepo);
  });

  test('forwards includeArchived flag to RedisService', () async {
    when(
      () => redisService.getLiveActivities(
        userId: 'u-2',
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer((_) async => [TestData.activity(userId: 'u-2')]);

    final result = await useCase.execute(
      userId: 'u-2',
      includeArchived: true,
    );

    expect(result.isRight(), isTrue);
    verify(
      () => redisService.getLiveActivities(
        userId: 'u-2',
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).called(1);
  });

  test('maps Redis exception into DatabaseFailure', () async {
    when(
      () => redisService.getLiveActivities(
        userId: 'u-1',
        limit: 10,
        global: true,
        includeArchived: false,
      ),
    ).thenThrow(Exception('redis unavailable'));

    final result = await useCase.execute(
      userId: 'u-1',
      limit: 10,
      global: true,
    );

    expect(result.isLeft(), isTrue);
  });
}
