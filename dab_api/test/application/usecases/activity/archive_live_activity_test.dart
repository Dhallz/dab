import 'package:dab_api/src/application/usecases/activity/archive_live_activity.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/core/realtime/presence_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockRedisService extends Mock implements RedisService {}

class _MockPresenceService extends Mock implements PresenceService {}

void main() {
  late _MockRedisService redis;
  late _MockPresenceService presence;
  late ArchiveLiveActivity useCase;

  setUp(() {
    redis = _MockRedisService();
    presence = _MockPresenceService();
    useCase = ArchiveLiveActivity(redis, presence);
  });

  test('flips flag to archived=true and broadcasts WS event', () async {
    final activity = TestData.activity(id: 'a-1', userId: 'u-1');
    final archived = activity.copyWith(archived: true);
    when(
      () => redis.setActivityArchiveFlag(
        userId: 'u-1',
        activityId: 'a-1',
        archived: true,
      ),
    ).thenAnswer((_) async => archived);
    when(
      () => presence.broadcastToUser(any(), any(), any()),
    ).thenReturn(null);

    final result = await useCase.execute(userId: 'u-1', activityId: 'a-1');

    expect(result.isRight(), isTrue);
    expect(result.getRight().toNullable()?.archived, isTrue);
    verify(
      () => presence.broadcastToUser('u-1', 'ACTIVITY_ARCHIVED', {
        'id': 'a-1',
        'userId': 'u-1',
        'archived': true,
      }),
    ).called(1);
  });

  test('returns NotFoundFailure when activity missing in live feed', () async {
    when(
      () => redis.setActivityArchiveFlag(
        userId: 'u-1',
        activityId: 'missing',
        archived: true,
      ),
    ).thenAnswer((_) async => null);

    final result = await useCase.execute(
      userId: 'u-1',
      activityId: 'missing',
    );

    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
    verifyNever(() => presence.broadcastToUser(any(), any(), any()));
  });

  test('maps unexpected errors to DatabaseFailure', () async {
    when(
      () => redis.setActivityArchiveFlag(
        userId: 'u-1',
        activityId: 'a-1',
        archived: true,
      ),
    ).thenThrow(Exception('boom'));

    final result = await useCase.execute(userId: 'u-1', activityId: 'a-1');

    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<DatabaseFailure>());
  });
}

