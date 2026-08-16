import 'package:dab_api/src/application/services/activity_live_publisher.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/core/realtime/presence_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRedis extends Mock implements RedisService {}

class _MockPresence extends Mock implements PresenceService {}

void main() {
  late _MockRedis redis;
  late _MockPresence presence;
  late ActivityLivePublisher publisher;

  final activity = Activity(
    id: 'a-1',
    userId: 'alice',
    provider: const GenericProvider(name: 'github'),
    title: 'push',
    content: 'sha',
    authorName: 'Alice',
    createdAt: DateTime.utc(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(activity);
  });

  setUp(() {
    redis = _MockRedis();
    presence = _MockPresence();
    publisher = ActivityLivePublisher(redis, presence);
    when(() => redis.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redis.fanOutActivity(any())).thenAnswer((_) async {});
    when(() => presence.broadcast(any(), any())).thenReturn(null);
    when(() => presence.broadcastToUser(any(), any(), any())).thenReturn(null);
  });

  test('targets the recipient only', () async {
    await publisher.publish(activity);
    verify(() => redis.fanOutActivity(activity)).called(1);
    verify(
      () => presence.broadcastToUser('alice', 'ACTIVITY_RECEIVED', any()),
    ).called(1);
    verifyNever(() => presence.broadcast(any(), any()));
  });
}
