import 'package:dab_api/src/application/usecases/activity/get_live_activities.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockRedisService extends Mock implements RedisService {}

void main() {
  late _MockRedisService redisService;
  late GetLiveActivities useCase;

  setUp(() {
    redisService = _MockRedisService();
    useCase = GetLiveActivities(redisService);
  });

  test('returns live activities from Redis for user scope', () async {
    final activity = TestData.activity(userId: 'u-1');
    when(
      () => redisService.getLiveActivities(
        userId: 'u-1',
        limit: 25,
        global: false,
      ),
    ).thenAnswer((_) async => [activity]);

    final result = await useCase.execute(userId: 'u-1', limit: 25);

    expect(result.isRight(), isTrue);
    expect(result.getOrElse((_) => []), hasLength(1));
  });

  test('maps Redis exception into DatabaseFailure', () async {
    when(
      () => redisService.getLiveActivities(
        userId: 'u-1',
        limit: 10,
        global: true,
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
