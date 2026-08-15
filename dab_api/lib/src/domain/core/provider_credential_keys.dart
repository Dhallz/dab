/// [ARCH: DOMAIN]
/// ROLE: Shared secret-field names and provider catalog for personal vs org credentials.
library;

/// Setting keys that may overlay org [ProviderConfig.settings] from a user credential.
const kProviderSecretSettingKeys = {
  'api.token',
  'api.email',
  'apiToken',
  'apiKey',
  'api.key',
  'token',
  'botToken',
  'username',
  'email',
  'password',
  'appPassword',
  'refreshToken',
  'accessToken',
};

/// Non-secret OAuth metadata that must overlay onto org settings for fetches.
const kProviderOauthMetaKeys = {
  'tokenType',
  'tokenExpiresAt',
  'cloudId',
};

/// Providers that use personal access tokens / API keys (per-user storage).
const kPatProviderIds = {
  'github',
  'gitlab',
  'bitbucket',
  'jira',
  'linear',
  'phorge',
};

/// Providers that need a single workspace bot (instance [ProviderConfig], not user tokens).
const kBotProviderIds = {'slack', 'discord'};

bool isKnownProviderId(String providerId) {
  final id = providerId.trim().toLowerCase();
  return kPatProviderIds.contains(id) || kBotProviderIds.contains(id);
}

bool isBotSharedProvider(String providerId) =>
    kBotProviderIds.contains(providerId.trim().toLowerCase());

/// Overlays non-empty user secret fields onto org settings. Watch lists stay org-owned.
Map<String, dynamic> overlayProviderSecrets({
  required Map<String, dynamic> orgSettings,
  Map<String, dynamic>? userSettings,
}) {
  final out = Map<String, dynamic>.from(orgSettings);
  if (userSettings == null || userSettings.isEmpty) return out;
  userSettings.forEach((key, value) {
    if (value == null) return;
    final isOverlay = kProviderSecretSettingKeys.contains(key) ||
        key.startsWith('api.') ||
        kProviderOauthMetaKeys.contains(key);
    if (!isOverlay) return;
    final text = value.toString().trim();
    if (text.isEmpty) return;
    out[key] = value;
  });
  return out;
}

/// Extracts a bearer/PAT-style token for [providerId] from merged settings.
String extractProviderToken(String providerId, Map<String, dynamic> settings) {
  final id = providerId.trim().toLowerCase();
  switch (id) {
    case 'github':
      return (settings['api.token'] ?? settings['token'] ?? '')
          .toString()
          .trim();
    case 'gitlab':
      return (settings['api.token'] ??
              settings['apiToken'] ??
              settings['token'] ??
              '')
          .toString()
          .trim();
    case 'linear':
      return (settings['apiKey'] ??
              settings['api.key'] ??
              settings['token'] ??
              '')
          .toString()
          .trim();
    case 'phorge':
      return (settings['api.token'] ??
              settings['apiToken'] ??
              settings['token'] ??
              '')
          .toString()
          .trim();
    case 'slack':
    case 'discord':
      return (settings['botToken'] ??
              settings['api.token'] ??
              settings['token'] ??
              '')
          .toString()
          .trim();
    case 'jira':
      return (settings['api.token'] ??
              settings['apiToken'] ??
              settings['token'] ??
              '')
          .toString()
          .trim();
    case 'bitbucket':
      return (settings['apiToken'] ??
              settings['appPassword'] ??
              settings['token'] ??
              '')
          .toString()
          .trim();
    default:
      return (settings['token'] ?? settings['api.token'] ?? settings['apiKey'] ?? '')
          .toString()
          .trim();
  }
}

bool isOauthCredential(Map<String, dynamic> settings) =>
    (settings['tokenType'] ?? '').toString().trim().toLowerCase() == 'oauth';

/// True when merged settings contain the secrets required to call [providerId].
bool hasRequiredProviderSecrets(
  String providerId,
  Map<String, dynamic> settings,
) {
  final id = providerId.trim().toLowerCase();
  switch (id) {
    case 'jira':
      if (isOauthCredential(settings)) {
        final cloudId = (settings['cloudId'] ?? '').toString().trim();
        return cloudId.isNotEmpty &&
            extractProviderToken(id, settings).isNotEmpty;
      }
      final email =
          (settings['email'] ?? settings['api.email'] ?? '').toString().trim();
      return email.isNotEmpty && extractProviderToken(id, settings).isNotEmpty;
    case 'bitbucket':
      if (isOauthCredential(settings)) {
        return extractProviderToken(id, settings).isNotEmpty;
      }
      final username = (settings['username'] ?? '').toString().trim();
      return username.isNotEmpty && extractProviderToken(id, settings).isNotEmpty;
    default:
      return extractProviderToken(id, settings).isNotEmpty;
  }
}
