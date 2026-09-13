/// [ARCH: PRESENTATION_MODEL]
/// ROLE: Compose Admin Live webhook URLs from Security `public_api_url`.
/// CONTRACT: The REST client base (`localhost:9080` in local runs) is never
/// the displayed default once a public API URL exists. A stored `webhookUrl`
/// that equals the client fallback is treated as a stale auto-fill, not a
/// custom override.
library;

String normalizePublicApiBase(String? raw) {
  final text = (raw ?? '').trim().replaceAll(RegExp(r'/+$'), '');
  if (text.isEmpty) return '';
  final uri = Uri.tryParse(text);
  if (uri == null || uri.host.isEmpty || !uri.hasScheme) return text;
  final host = uri.host.toLowerCase();
  final isLoopback =
      host == 'localhost' || host == '127.0.0.1' || host == '::1';
  if (!isLoopback && uri.scheme == 'http') {
    return uri.replace(scheme: 'https').toString().replaceAll(RegExp(r'/+$'), '');
  }
  return text;
}

/// Path Jira/GitHub/… webhooks POST to. Slack uses Events API.
String webhookPathForProvider(String providerId) {
  if (providerId.trim().toLowerCase() == 'slack') {
    return '/integrations/slack/events';
  }
  return '/integrations/${providerId.trim().toLowerCase()}/webhook';
}

/// Webhook URL from Admin → Security `public_api_url`. Empty until that is set.
String derivedWebhookUrl({
  required String providerId,
  required Map<String, String> systemSettings,
}) {
  final base = normalizePublicApiBase(systemSettings['public_api_url']);
  if (base.isEmpty) return '';
  return '$base${webhookPathForProvider(providerId)}';
}

/// URL the card used to invent from the app's REST client (local API).
String clientFallbackWebhookUrl({
  required String providerId,
  required String restClientBaseUrl,
}) {
  final base = normalizePublicApiBase(restClientBaseUrl);
  if (base.isEmpty) return '';
  return '$base${webhookPathForProvider(providerId)}';
}

/// True when [url] is empty, the Security default, or the leftover client URL.
bool isStaleOrDefaultWebhookUrl({
  required String url,
  required String publicApiDerived,
  required String clientDerived,
}) {
  final text = url.trim();
  if (text.isEmpty) return true;
  if (publicApiDerived.isNotEmpty && text == publicApiDerived) return true;
  if (clientDerived.isNotEmpty && text == clientDerived) return true;
  return false;
}

/// Value shown in the Live webhook field.
String displayWebhookUrl({
  required String stored,
  required String publicApiDerived,
  required String clientDerived,
}) {
  if (!isStaleOrDefaultWebhookUrl(
    url: stored,
    publicApiDerived: publicApiDerived,
    clientDerived: clientDerived,
  )) {
    return stored.trim();
  }
  return publicApiDerived;
}

/// Persist only genuine per-provider overrides — never localhost or the default.
bool shouldPersistWebhookUrl({
  required String value,
  required String publicApiDerived,
  required String clientDerived,
}) {
  return !isStaleOrDefaultWebhookUrl(
    url: value,
    publicApiDerived: publicApiDerived,
    clientDerived: clientDerived,
  );
}
