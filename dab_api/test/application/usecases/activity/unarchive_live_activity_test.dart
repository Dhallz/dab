import 'package:dab_api/src/application/usecases/activity/unarchive_live_activity.dart';
import 'package:dab_api/src/domain/core/failure.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/websockets/presence_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockRedisService extends Mock implements RedisService {}

class _MockPresenceService extends Mock implements PresenceService {}

void main() {
  late _MockRedisService redis;
  late _MockPresenceService presence;
  late UnarchiveLiveActivity useCase;

  setUp(() {
    redis = _MockRedisService();
    presence = _MockPresenceService();
    useCase = UnarchiveLiveActivity(redis, presence);
  });

  test('flips flag back to archived=false and broadcasts WS event', () async {
    final activity = TestData.activity(id: 'a-2', userId: 'u-1');
    when(
      () => redis.setActivityArchiveFlag(
        userId: 'u-1',
        activityId: 'a-2',
        archived: false,
      ),
    ).thenAnswer((_) async => activity);
    when(
      () => presence.broadcastToUser(any(), any(), any()),
    ).thenReturn(null);

    final result = await useCase.execute(userId: 'u-1', activityId: 'a-2');

    expect(result.isRight(), isTrue);
    verify(
      () => presence.broadcastToUser('u-1', 'ACTIVITY_UNARCHIVED', {
        'id': 'a-2',
        'userId': 'u-1',
        'archived': false,
      }),
    ).called(1);
  });

  test('returns NotFoundFailure when activity missing in live feed', () async {
    when(
      () => redis.setActivityArchiveFlag(
        userId: 'u-1',
        activityId: 'gone',
        archived: false,
      ),
    ).thenAnswer((_) async => null);

    final result = await useCase.execute(userId: 'u-1', activityId: 'gone');

    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
    verifyNever(() => presence.broadcastToUser(any(), any(), any()));
  });
}
