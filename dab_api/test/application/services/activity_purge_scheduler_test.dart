import 'package:dab_api/src/application/services/activity_purge_scheduler.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRedisService extends Mock implements RedisService {}

void main() {
  late _MockRedisService redis;

  setUp(() {
    redis = _MockRedisService();
  });

  test('runNow delegates to RedisService.purgeArchivedActivities', () async {
    when(
      () => redis.purgeArchivedActivities(),
    ).thenAnswer((_) async => {'activities:user:u1': 2});

    final scheduler = ActivityPurgeScheduler(redis);

    final removed = await scheduler.runNow();

    expect(removed, {'activities:user:u1': 2});
    verify(() => redis.purgeArchivedActivities()).called(1);
  });

  test('start is idempotent', () async {
    when(
      () => redis.purgeArchivedActivities(),
    ).thenAnswer((_) async => const <String, int>{});

    // Freeze the clock at 12:00 so the next fire is in ~12 hours and will
    // never trigger during the test.
    final frozen = DateTime(2030, 1, 1, 12);
    final scheduler = ActivityPurgeScheduler(redis, now: () => frozen);

    scheduler.start();
    scheduler.start(); // second call should be a no-op.

    scheduler.stop();
    verifyNever(() => redis.purgeArchivedActivities());
  });
}
