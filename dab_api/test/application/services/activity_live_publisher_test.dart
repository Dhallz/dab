import 'package:dab_api/src/application/services/activity_live_publisher.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_push_wake_client.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_device_token_repository.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/core/realtime/presence_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRedis extends Mock implements RedisService {}

class _MockPresence extends Mock implements PresenceService {}

class _MockTokens extends Mock implements AbsIUserDeviceTokenRepository {}

class _MockWake extends Mock implements AbsIPushWakeClient {}

void main() {
  late _MockRedis redis;
  late _MockPresence presence;
  late _MockTokens tokens;
  late _MockWake wake;
  late ActivityLivePublisher publisher;

  final activity = Activity(
    id: 'a-1',
    userId: 'alice',
    provider: const GenericProvider(name: 'github'),
    title: 'push',
    content: 'sha',
    authorName: 'Alice',
    createdAt: DateTime.utc(2026, 1, 1),
    inboxLane: ActivityInboxLane.directed,
  );

  setUpAll(() {
    registerFallbackValue(activity);
    registerFallbackValue(<String, String>{});
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    redis = _MockRedis();
    presence = _MockPresence();
    tokens = _MockTokens();
    wake = _MockWake();
    publisher = ActivityLivePublisher(
      redis,
      presence,
      tokens: tokens,
      wake: wake,
    );
    when(() => redis.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redis.fanOutActivity(any())).thenAnswer((_) async {});
    when(() => presence.broadcast(any(), any())).thenReturn(null);
    when(() => presence.broadcastToUser(any(), any(), any())).thenReturn(null);
    when(() => presence.hasSession(any())).thenReturn(false);
    when(
      () => tokens.listTokensForUser(any()),
    ).thenAnswer((_) async => const Right(['tok-1']));
    when(
      () => wake.sendWake(
        tokens: any(named: 'tokens'),
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async {});
  });

  test('targets the recipient only', () async {
    await publisher.publish(activity);
    verify(() => redis.fanOutActivity(activity)).called(1);
    verify(
      () => presence.broadcastToUser('alice', 'ACTIVITY_RECEIVED', any()),
    ).called(1);
    verifyNever(() => presence.broadcast(any(), any()));
  });

  test('skips wake when the recipient has a WebSocket session', () async {
    when(() => presence.hasSession('alice')).thenReturn(true);

    await publisher.publish(activity);

    verifyNever(() => tokens.listTokensForUser(any()));
    verifyNever(
      () => wake.sendWake(
        tokens: any(named: 'tokens'),
        data: any(named: 'data'),
      ),
    );
  });

  test('wakes offline devices with lane and id only', () async {
    when(() => presence.hasSession('alice')).thenReturn(false);

    await publisher.publish(activity);

    final captured = verify(
      () => wake.sendWake(
        tokens: captureAny(named: 'tokens'),
        data: captureAny(named: 'data'),
      ),
    ).captured;
    expect(captured[0], ['tok-1']);
    final data = captured[1] as Map<String, String>;
    expect(data['type'], 'inbox_wake');
    expect(data['lane'], 'directed');
    expect(data['activityId'], 'a-1');
    expect(data.containsKey('title'), isFalse);
    expect(data.containsKey('content'), isFalse);
  });
}
