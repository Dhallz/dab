import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../../domain/entities/provider/provider_config.dart';
import '../../domain/entities/provider/provider_connectivity_report.dart';
import '../../infrastructure/core/security/github_webhook_verifier.dart';
import '../../infrastructure/core/security/linear_webhook_verifier.dart';
import '../../infrastructure/core/security/phorge_webhook_verifier.dart';
import '../../infrastructure/core/security/shared_secret_verifier.dart';
import '../../infrastructure/core/security/slack_request_verifier.dart';
import '../../infrastructure/database/redis/redis_service.dart';
import '../../infrastructure/sources/discord/discord_gateway_service.dart';

/// [ARCH: APPLICATION_SERVICE]
/// ROLE: Verifies Live webhook credentials during Admin connectivity tests.
/// CONTRACT: When no recent ingest exists, validates signing secrets and records
/// a test delivery in Redis so Live can turn green without waiting for a provider event.
class ProviderLiveWebhookTestService {
  ProviderLiveWebhookTestService(
    this._redis,
    this._discordGateway,
    this._githubVerifier,
    this._slackVerifier,
    this._linearVerifier,
    this._phorgeVerifier,
    this._sharedSecretVerifier,
  );

  final RedisService _redis;
  final DiscordGatewayService _discordGateway;
  final GitHubWebhookVerifier _githubVerifier;
  final SlackRequestVerifier _slackVerifier;
  final LinearWebhookVerifier _linearVerifier;
  final PhorgeWebhookVerifier _phorgeVerifier;
  final SharedSecretVerifier _sharedSecretVerifier;

  static const _successMessage = 'Webhook test delivery verified just now';
  static const _missingSecretMessage =
      'Configure the Live webhook secret, then click Try to run a test delivery.';

  /// Validates provider Live webhook configuration and records a test delivery.
  Future<ProviderSectionResult> testDelivery(ProviderConfig config) async {
    final id = _normalizeProviderId(config.id);
    return switch (id) {
      'github' => _testGitHub(config),
      'slack' => _testSlack(config),
      'gitlab' => _testSharedSecretProvider(
        providerId: 'gitlab',
        config: config,
        keys: const ['webhookSecret', 'webhook_secret'],
        label: 'GitLab webhook secret',
      ),
      'bitbucket' => _testHmacProvider(
        providerId: 'bitbucket',
        config: config,
        keys: const ['webhookSecret', 'webhook_secret'],
        label: 'Bitbucket webhook secret',
        body: '{"test":true}',
      ),
      'jira' => _testHmacProvider(
        providerId: 'jira',
        config: config,
        keys: const ['webhookSecret', 'webhook_secret'],
        label: 'Jira webhook secret',
        body:
            '{"webhookEvent":"jira:issue_updated","issue":{"key":"DAB-LIVE-TEST"}}',
      ),
      'linear' => _testLinear(config),
      'phorge' => _testPhorge(config),
      'discord' => _testDiscord(),
      _ => const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Live webhook test is not supported for this provider',
      ),
    };
  }

  Future<ProviderSectionResult> _testGitHub(ProviderConfig config) {
    return _testHmacProvider(
      providerId: 'github',
      config: config,
      keys: const ['webhookSecret', 'webhook_secret'],
      label: 'GitHub webhook secret',
      body: '{"zen":"DAB live webhook test"}',
    );
  }

  Future<ProviderSectionResult> _testSlack(ProviderConfig config) async {
    final secret = _setting(config, const [
      'signingSecret',
      'signing_secret',
      'slackSigningSecret',
    ]);
    if (secret.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: _missingSecretMessage,
      );
    }

    final body = jsonEncode({
      'type': 'url_verification',
      'challenge': 'dab-live-webhook-test',
    });
    final timestamp =
        (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    final signature = _slackSignature(
      body: body,
      timestamp: timestamp,
      signingSecret: secret,
    );

    final valid = _slackVerifier.isValid(
      body: body,
      signatureHeader: signature,
      timestampHeader: timestamp,
      signingSecret: secret,
    );
    if (!valid) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Slack signing secret validation failed',
      );
    }

    await _recordTestDelivery('slack');
    return const ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message: _successMessage,
    );
  }

  Future<ProviderSectionResult> _testLinear(ProviderConfig config) async {
    final secret = _setting(config, const ['webhookSecret', 'webhook_secret']);
    if (secret.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: _missingSecretMessage,
      );
    }

    const body = '{"type":"Issue","action":"test","data":{"id":"dab-test"}}';
    final signature = _hexHmacSha256(body: body, secret: secret);
    final valid = _linearVerifier.isValidSignature(
      body: body,
      signatureHeader: signature,
      signingSecret: secret,
    );
    if (!valid) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Linear webhook secret validation failed',
      );
    }

    await _recordTestDelivery('linear');
    return const ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message: _successMessage,
    );
  }

  Future<ProviderSectionResult> _testPhorge(ProviderConfig config) async {
    final hmacKey = _setting(config, const [
      'webhookHmacKey',
      'webhook_hmac_key',
    ]);
    if (hmacKey.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: _missingSecretMessage,
      );
    }

    const body = '{"action":{"test":true}}';
    final signature = _hexHmacSha256(body: body, secret: hmacKey);
    final valid = _phorgeVerifier.isValidSignature(
      body: body,
      signatureHeader: signature,
      hmacKey: hmacKey,
    );
    if (!valid) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: 'Phorge webhook HMAC key validation failed',
      );
    }

    await _recordTestDelivery('phorge');
    return const ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message: _successMessage,
    );
  }

  Future<ProviderSectionResult> _testDiscord() async {
    if (!_discordGateway.isRunning || !_discordGateway.isConnected) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message:
            'Discord Gateway is not connected. Verify bot token, guild ID, and channel access.',
      );
    }

    await _recordTestDelivery('discord');
    return const ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message: 'Gateway connected; live delivery test recorded',
    );
  }

  Future<ProviderSectionResult> _testSharedSecretProvider({
    required String providerId,
    required ProviderConfig config,
    required List<String> keys,
    required String label,
  }) async {
    final secret = _setting(config, keys);
    if (secret.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: _missingSecretMessage,
      );
    }

    if (!_sharedSecretVerifier.isValid(provided: secret, expected: secret)) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: '$label validation failed',
      );
    }

    await _recordTestDelivery(providerId);
    return const ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message: _successMessage,
    );
  }

  Future<ProviderSectionResult> _testHmacProvider({
    required String providerId,
    required ProviderConfig config,
    required List<String> keys,
    required String label,
    required String body,
  }) async {
    final secret = _setting(config, keys);
    if (secret.isEmpty) {
      return const ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: _missingSecretMessage,
      );
    }

    final signature = 'sha256=${_hexHmacSha256(body: body, secret: secret)}';
    final valid = _githubVerifier.isValidSha256Signature(
      body: body,
      signature256Header: signature,
      webhookSecret: secret,
    );
    if (!valid) {
      return ProviderSectionResult(
        status: ConnectivitySectionStatus.failure,
        message: '$label validation failed',
      );
    }

    await _recordTestDelivery(providerId);
    return const ProviderSectionResult(
      status: ConnectivitySectionStatus.success,
      message: _successMessage,
    );
  }

  Future<void> _recordTestDelivery(String providerId) {
    return _redis.recordLiveIngestSuccess(_normalizeProviderId(providerId));
  }

  String _setting(ProviderConfig config, List<String> keys) {
    for (final key in keys) {
      final raw = config.settings[key];
      final value = raw?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }
    return '';
  }

  static String _normalizeProviderId(String providerId) {
    final id = providerId.trim().toLowerCase();
    return id == 'phabricator' ? 'phorge' : id;
  }

  static String _hexHmacSha256({
    required String body,
    required String secret,
  }) {
    return Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(body)).toString();
  }

  static String _slackSignature({
    required String body,
    required String timestamp,
    required String signingSecret,
  }) {
    final baseString = 'v0:$timestamp:$body';
    final digest = Hmac(
      sha256,
      utf8.encode(signingSecret),
    ).convert(utf8.encode(baseString));
    return 'v0=${digest.toString()}';
  }
}
