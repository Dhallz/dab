import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/contracts/ports/i_webhook_request_authenticator.dart';
import '../../../domain/contracts/ports/webhook_auth_input.dart';
import '../../../domain/contracts/ports/webhook_auth_status.dart';
import '../../../domain/contracts/repositories/abs_i_provider_config_repository.dart';
import '../security/github_webhook_verifier.dart';
import '../security/linear_webhook_verifier.dart';
import '../security/phorge_webhook_verifier.dart';
import '../security/shared_secret_verifier.dart';
import '../security/slack_request_verifier.dart';

/// [ARCH: INFRASTRUCTURE_SERVICE]
/// ROLE: Authenticates inbound provider webhooks using Live secrets.
/// CONTRACT: Loads the active provider config, then HMAC or constant-time
/// shared-secret compare. Jira accepts HMAC or `X-Webhook-Secret` / `?secret=`.
/// CONSTRAINTS: Never logs secrets. Unknown [WebhookAuthInput.providerId]
/// is [WebhookAuthStatus.invalid].
class WebhookRequestAuthenticator implements IWebhookRequestAuthenticator {
  WebhookRequestAuthenticator(
    this._configs,
    this._slackVerifier,
    this._githubVerifier,
    this._phorgeVerifier,
    this._linearVerifier,
    this._sharedSecretVerifier,
  );

  final AbsIProviderConfigRepository _configs;
  final SlackRequestVerifier _slackVerifier;
  final GitHubWebhookVerifier _githubVerifier;
  final PhorgeWebhookVerifier _phorgeVerifier;
  final LinearWebhookVerifier _linearVerifier;
  final SharedSecretVerifier _sharedSecretVerifier;

  @override
  Future<WebhookAuthStatus> authenticate(WebhookAuthInput input) async {
    switch (input.providerId.trim().toLowerCase()) {
      case 'slack':
        return _verifySlack(input);
      case 'github':
        return _verifyHmacSha256Prefix(
          input,
          keys: const ['webhookSecret', 'webhook_secret'],
        );
      case 'bitbucket':
        return _verifyHmacSha256Prefix(
          input,
          keys: const ['webhookSecret', 'webhook_secret'],
        );
      case 'phorge':
        return _verifyPhorge(input);
      case 'gitlab':
        return _verifySharedToken(
          input,
          keys: const ['webhookSecret', 'webhook_secret'],
        );
      case 'linear':
        return _verifyLinear(input);
      case 'jira':
        return _verifyJira(input);
      default:
        return WebhookAuthStatus.invalid;
    }
  }

  Future<WebhookAuthStatus> _verifySlack(WebhookAuthInput input) async {
    final secret = await _resolveSetting('slack', const ['signingSecret']);
    if (secret.isEmpty) return WebhookAuthStatus.missingSecret;
    final valid = _slackVerifier.isValid(
      body: input.body,
      signatureHeader: input.signatureHeader,
      timestampHeader: input.timestampHeader,
      signingSecret: secret,
    );
    return valid ? WebhookAuthStatus.ok : WebhookAuthStatus.invalid;
  }

  Future<WebhookAuthStatus> _verifyHmacSha256Prefix(
    WebhookAuthInput input, {
    required List<String> keys,
  }) async {
    final secret = await _resolveSetting(input.providerId, keys);
    if (secret.isEmpty) return WebhookAuthStatus.missingSecret;
    final valid = _githubVerifier.isValidSha256Signature(
      body: input.body,
      signature256Header: input.signatureHeader,
      webhookSecret: secret,
    );
    return valid ? WebhookAuthStatus.ok : WebhookAuthStatus.invalid;
  }

  Future<WebhookAuthStatus> _verifyPhorge(WebhookAuthInput input) async {
    final secret = await _resolveSetting('phorge', const [
      'webhookHmacKey',
      'webhook_hmac_key',
    ]);
    if (secret.isEmpty) return WebhookAuthStatus.missingSecret;
    final valid = _phorgeVerifier.isValidSignature(
      body: input.body,
      signatureHeader: input.signatureHeader,
      hmacKey: secret,
    );
    return valid ? WebhookAuthStatus.ok : WebhookAuthStatus.invalid;
  }

  Future<WebhookAuthStatus> _verifyLinear(WebhookAuthInput input) async {
    final secret = await _resolveSetting('linear', const [
      'webhookSecret',
      'webhook_secret',
    ]);
    if (secret.isEmpty) return WebhookAuthStatus.missingSecret;
    final valid = _linearVerifier.isValidSignature(
      body: input.body,
      signatureHeader: input.signatureHeader,
      signingSecret: secret,
    );
    return valid ? WebhookAuthStatus.ok : WebhookAuthStatus.invalid;
  }

  Future<WebhookAuthStatus> _verifySharedToken(
    WebhookAuthInput input, {
    required List<String> keys,
  }) async {
    final expected = await _resolveSetting(input.providerId, keys);
    if (expected.isEmpty) return WebhookAuthStatus.missingSecret;
    final valid = _sharedSecretVerifier.isValid(
      provided: input.sharedSecretHeader,
      expected: expected,
    );
    return valid ? WebhookAuthStatus.ok : WebhookAuthStatus.invalid;
  }

  Future<WebhookAuthStatus> _verifyJira(WebhookAuthInput input) async {
    final secret = await _resolveSetting('jira', const [
      'webhookSecret',
      'webhook_secret',
    ]);
    if (secret.isEmpty) return WebhookAuthStatus.missingSecret;
    final hubValid =
        input.signatureHeader.trim().isNotEmpty &&
        _githubVerifier.isValidSha256Signature(
          body: input.body,
          signature256Header: input.signatureHeader,
          webhookSecret: secret,
        );
    if (hubValid) return WebhookAuthStatus.ok;
    final providedShared = input.sharedSecretHeader.trim().isNotEmpty
        ? input.sharedSecretHeader
        : input.sharedSecretQuery;
    final sharedValid = _sharedSecretVerifier.isValid(
      provided: providedShared,
      expected: secret,
    );
    return sharedValid ? WebhookAuthStatus.ok : WebhookAuthStatus.invalid;
  }

  Future<String> _resolveSetting(String providerId, List<String> keys) async {
    final result = await _configs.getConfigs();
    final config = result
        .getOrElse((_) => const <ProviderConfig>[])
        .where((c) => c.id.toLowerCase() == providerId.toLowerCase() && c.isActive)
        .firstOrNull;
    if (config == null) return '';
    for (final key in keys) {
      final value = (config.settings[key] ?? '').toString().trim();
      if (value.isNotEmpty) return value;
    }
    return '';
  }
}
