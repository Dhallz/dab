import 'webhook_auth_input.dart';
import 'webhook_auth_status.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Verifies inbound webhook authenticity using the provider's Live secret.
/// CONTRACT: Resolves the secret from provider config and compares HMAC or
/// shared token. Presentation stays a thin delegate (no crypto, no config
/// key names).
abstract interface class IWebhookRequestAuthenticator {
  /// Authenticates [input] for [WebhookAuthInput.providerId].
  Future<WebhookAuthStatus> authenticate(WebhookAuthInput input);
}
