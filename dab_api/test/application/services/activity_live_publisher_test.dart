import 'package:dab_api/src/application/services/activity_live_publisher.dart';
import 'package:dab_api/src/domain/core/deployment_mode.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/repositories/abs_i_system_settings_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/websockets/presence_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRedis extends Mock implements RedisService {}

class _MockPresence extends Mock implements PresenceService {}

class _MockSettings extends Mock implements ISystemSettingsRepository {}

void main() {
  late _MockRedis redis;
  late _MockPresence presence;
  late _MockSettings settings;
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
    settings = _MockSettings();
    publisher = ActivityLivePublisher(redis, presence, settings);
    when(() => redis.incrementVersion()).thenAnswer((_) async => 1);
    when(() => redis.fanOutActivity(any())).thenAnswer((_) async {});
    when(() => presence.broadcast(any(), any())).thenReturn(null);
    when(() => presence.broadcastToUser(any(), any(), any())).thenReturn(null);
  });

  test('personal mode broadcasts to all sessions', () async {
    when(() => settings.getSetting(kDeploymentModeSettingKey)).thenAnswer(
      (_) async => const Right(kDeploymentModePersonal),
    );
    await publisher.publish(activity);
    verify(() => redis.fanOutActivity(activity)).called(1);
    verify(() => presence.broadcast('ACTIVITY_RECEIVED', any())).called(1);
    verifyNever(() => presence.broadcastToUser(any(), any(), any()));
  });

  test('organization mode targets the author only', () async {
    when(() => settings.getSetting(kDeploymentModeSettingKey)).thenAnswer(
      (_) async => const Right(kDeploymentModeOrganization),
    );
    await publisher.publish(activity);
    verify(
      () => presence.broadcastToUser('alice', 'ACTIVITY_RECEIVED', any()),
    ).called(1);
    verifyNever(() => presence.broadcast(any(), any()));
  });
}
