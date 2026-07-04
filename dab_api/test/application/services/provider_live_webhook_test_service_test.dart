import 'package:dab_api/src/application/services/provider_live_webhook_test_service.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/provider/provider_connectivity_report.dart';
import 'package:dab_api/src/infrastructure/core/security/github_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/linear_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/phorge_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/shared_secret_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/slack_request_verifier.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_gateway_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockRedisService extends Mock implements RedisService {}

class _MockDiscordGateway extends Mock implements DiscordGatewayService {}

void main() {
  late _MockRedisService redis;
  late _MockDiscordGateway discord;
  late ProviderLiveWebhookTestService service;

  setUp(() {
    redis = _MockRedisService();
    discord = _MockDiscordGateway();
    service = ProviderLiveWebhookTestService(
      redis,
      discord,
      GitHubWebhookVerifier(),
      SlackRequestVerifier(),
      LinearWebhookVerifier(),
      PhorgeWebhookVerifier(),
      SharedSecretVerifier(),
    );
    when(() => redis.recordLiveIngestSuccess(any())).thenAnswer((_) async {});
  });

  test('GitHub records test delivery when webhook secret validates', () async {
    const config = ProviderConfig(
      id: 'github',
      name: 'GitHub',
      baseUrl: 'https://github.com',
      isActive: true,
      settings: {'webhookSecret': 'gh-secret'},
    );

    final result = await service.testDelivery(config);

    expect(result.status, ConnectivitySectionStatus.success);
    expect(result.message, contains('test delivery verified'));
    verify(() => redis.recordLiveIngestSuccess('github')).called(1);
  });

  test('Jira records test delivery when webhook secret validates HMAC', () async {
    const config = ProviderConfig(
      id: 'jira',
      name: 'Jira',
      baseUrl: 'https://dhallz.atlassian.net',
      isActive: true,
      settings: {'webhookSecret': 'jira-secret'},
    );

    final result = await service.testDelivery(config);

    expect(result.status, ConnectivitySectionStatus.success);
    verify(() => redis.recordLiveIngestSuccess('jira')).called(1);
  });

  test('GitHub fails when webhook secret is missing', () async {
    const config = ProviderConfig(
      id: 'github',
      name: 'GitHub',
      baseUrl: 'https://github.com',
      isActive: true,
      settings: {},
    );

    final result = await service.testDelivery(config);

    expect(result.status, ConnectivitySectionStatus.failure);
    verifyNever(() => redis.recordLiveIngestSuccess(any()));
  });

  test('Slack records test delivery when signing secret validates', () async {
    const config = ProviderConfig(
      id: 'slack',
      name: 'Slack',
      baseUrl: 'https://slack.com',
      isActive: true,
      settings: {'signingSecret': 'slack-signing'},
    );

    final result = await service.testDelivery(config);

    expect(result.status, ConnectivitySectionStatus.success);
    verify(() => redis.recordLiveIngestSuccess('slack')).called(1);
  });

  test('Discord records test delivery when gateway is connected', () async {
    when(() => discord.isRunning).thenReturn(true);
    when(() => discord.isConnected).thenReturn(true);

    const config = ProviderConfig(
      id: 'discord',
      name: 'Discord',
      baseUrl: 'https://discord.com',
      isActive: true,
      settings: {},
    );

    final result = await service.testDelivery(config);

    expect(result.status, ConnectivitySectionStatus.success);
    verify(() => redis.recordLiveIngestSuccess('discord')).called(1);
  });
}
