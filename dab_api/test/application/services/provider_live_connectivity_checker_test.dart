import 'package:dab_api/src/application/services/provider_live_connectivity_checker.dart';
import 'package:dab_api/src/domain/entities/provider/provider_connectivity_report.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_gateway_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRedisService extends Mock implements RedisService {}

class _MockDiscordGateway extends Mock implements DiscordGatewayService {}

void main() {
  late _MockRedisService redis;
  late _MockDiscordGateway discord;
  late ProviderLiveConnectivityChecker checker;

  setUp(() {
    redis = _MockRedisService();
    discord = _MockDiscordGateway();
    checker = ProviderLiveConnectivityChecker(redis, discord);
  });

  test('returns failure when no Redis ingest timestamp exists', () async {
    when(() => redis.getLiveIngestLastSuccess('github')).thenAnswer((_) async => null);

    final result = await checker.check('github');

    expect(result.status, ConnectivitySectionStatus.failure);
    expect(result.message, contains('7 days'));
  });

  test('returns success when recent ingest exists', () async {
    when(() => redis.getLiveIngestLastSuccess('slack')).thenAnswer(
      (_) async => DateTime.utc(2026, 7, 3, 10, 0),
    );

    final result = await checker.check('slack');

    expect(result.status, ConnectivitySectionStatus.success);
    expect(result.message, contains('Last live event'));
  });

  test('discord requires gateway connected and recent ingest', () async {
    when(() => discord.isRunning).thenReturn(true);
    when(() => discord.isConnected).thenReturn(false);

    final disconnected = await checker.check('discord');
    expect(disconnected.status, ConnectivitySectionStatus.failure);
    expect(disconnected.message, contains('Gateway'));

    when(() => discord.isConnected).thenReturn(true);
    when(() => redis.getLiveIngestLastSuccess('discord')).thenAnswer((_) async => null);

    final noIngest = await checker.check('discord');
    expect(noIngest.status, ConnectivitySectionStatus.failure);
    expect(noIngest.message, contains('7 days'));
  });
}
