import 'package:dab_api/src/application/services/activity_purge_scheduler.dart';
import 'package:dab_api/src/domain/repositories/abs_i_system_settings_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRedisService extends Mock implements RedisService {}

class _MockSystemSettingsRepository extends Mock
    implements ISystemSettingsRepository {}

void main() {
  late _MockRedisService redis;
  late _MockSystemSettingsRepository settings;

  setUp(() {
    redis = _MockRedisService();
    settings = _MockSystemSettingsRepository();
    when(() => settings.getSetting(any())).thenAnswer(
      (_) async => const Right(null),
    );
  });

  test('runNow delegates to RedisService.purgeStaleLiveFeedActivities', () async {
    when(
      () => redis.purgeStaleLiveFeedActivities(),
    ).thenAnswer((_) async => {'activities:user:u1': 2});

    final scheduler = ActivityPurgeScheduler(redis, settings);

    final removed = await scheduler.runNow();

    expect(removed, {'activities:user:u1': 2});
    verify(() => redis.purgeStaleLiveFeedActivities()).called(1);
  });

  test('start is idempotent', () async {
    when(
      () => redis.purgeStaleLiveFeedActivities(),
    ).thenAnswer((_) async => const <String, int>{});

    // Freeze the clock at 12:00 UTC so the next purge is ~12h away and will
    // not trigger during the test.
    final frozen = DateTime.utc(2030, 1, 1, 12);
    final scheduler = ActivityPurgeScheduler(redis, settings, now: () => frozen);

    scheduler.start();
    scheduler.start(); // second call should be a no-op.

    scheduler.stop();
    verifyNever(() => redis.purgeStaleLiveFeedActivities());
  });
}
