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
const kProviderOauthMetaKeys = {'tokenType', 'tokenExpiresAt', 'cloudId'};

/// Providers that use personal access tokens / API keys (per-user storage).
const kPatProviderIds = {
  'github',
  'gitlab',
  'bitbucket',
  'jira',
  'linear',
  'phorge',
  'figma',
};

/// Providers that need a single workspace bot (instance [ProviderConfig], not user tokens).
const kBotProviderIds = {'slack', 'discord'};

/// [ARCH: DOMAIN]
/// ROLE: Provider-id predicates on the raw catalog string.
extension OnString on String {
  /// True when [this] is a known PAT or bot provider id.
  bool get isKnownProviderId {
    final id = trim().toLowerCase();
    return kPatProviderIds.contains(id) || kBotProviderIds.contains(id);
  }

  /// True when [this] is a shared workspace-bot provider (Slack, Discord).
  bool get isBotSharedProvider =>
      kBotProviderIds.contains(trim().toLowerCase());
}

/// [ARCH: DOMAIN]
/// ROLE: Credential overlay, token extraction, and OAuth expiry on settings maps.
extension OnProviderSettings on Map {
  /// Overlays non-empty user secret fields onto this org settings map.
  /// Watch lists stay org-owned.
  Map<String, dynamic> overlayProviderSecrets([Map? userSettings]) {
    final out = Map<String, dynamic>.from(this);
    if (userSettings == null || userSettings.isEmpty) return out;
    userSettings.forEach((key, value) {
      if (value == null) return;
      final isOverlay =
          kProviderSecretSettingKeys.contains(key) ||
          key.startsWith('api.') ||
          kProviderOauthMetaKeys.contains(key);
      if (!isOverlay) return;
      final text = value.toString().trim();
      if (text.isEmpty) return;
      out[key] = value;
    });
    return out;
  }

  /// Extracts a bearer/PAT-style token for [providerId] from this merged map.
  String extractProviderToken(String providerId) {
    final id = providerId.trim().toLowerCase();
    switch (id) {
      case 'github':
      case 'figma':
        return (this['api.token'] ?? this['token'] ?? this['accessToken'] ?? '')
            .toString()
            .trim();
      case 'gitlab':
        return (this['api.token'] ??
                this['apiToken'] ??
                this['token'] ??
                this['accessToken'] ??
                '')
            .toString()
            .trim();
      case 'linear':
        return (this['apiKey'] ??
                this['api.key'] ??
                this['token'] ??
                this['accessToken'] ??
                '')
            .toString()
            .trim();
      case 'phorge':
        return (this['api.token'] ?? this['apiToken'] ?? this['token'] ?? '')
            .toString()
            .trim();
      case 'slack':
      case 'discord':
        return (this['botToken'] ?? this['api.token'] ?? this['token'] ?? '')
            .toString()
            .trim();
      case 'jira':
        if (isOauthCredential) {
          return (this['apiToken'] ??
                  this['api.token'] ??
                  this['token'] ??
                  '')
              .toString()
              .trim();
        }
        return (this['api.token'] ?? this['apiToken'] ?? this['token'] ?? '')
            .toString()
            .trim();
      case 'bitbucket':
        return (this['apiToken'] ??
                this['appPassword'] ??
                this['token'] ??
                this['accessToken'] ??
                '')
            .toString()
            .trim();
      default:
        return (this['token'] ?? this['api.token'] ?? this['apiKey'] ?? '')
            .toString()
            .trim();
    }
  }

  /// True when this credential row is OAuth (`tokenType=oauth`).
  bool get isOauthCredential =>
      (this['tokenType'] ?? '').toString().trim().toLowerCase() == 'oauth';

  /// True when an OAuth credential has a refresh token and the access token is
  /// missing an expiry or expires within [skew] of [now].
  bool oauthAccessTokenNeedsRefresh({
    DateTime? now,
    Duration skew = const Duration(seconds: 90),
  }) {
    if (!isOauthCredential) return false;
    final refresh = (this['refreshToken'] ?? '').toString().trim();
    if (refresh.isEmpty) return false;
    final raw = (this['tokenExpiresAt'] ?? '').toString().trim();
    if (raw.isEmpty) return true;
    final expires = DateTime.tryParse(raw);
    if (expires == null) return true;
    final n = (now ?? DateTime.now()).toUtc();
    return !expires.toUtc().isAfter(n.add(skew));
  }

  /// True when [tokenExpiresAt] is in the past (or unparseable) for an OAuth row.
  bool oauthAccessTokenIsExpired({DateTime? now}) {
    if (!isOauthCredential) return false;
    final raw = (this['tokenExpiresAt'] ?? '').toString().trim();
    if (raw.isEmpty) return false;
    final expires = DateTime.tryParse(raw);
    if (expires == null) return true;
    return !expires.toUtc().isAfter((now ?? DateTime.now()).toUtc());
  }

  /// True when this merged map contains the secrets required to call [providerId].
  bool hasRequiredProviderSecrets(String providerId) {
    final id = providerId.trim().toLowerCase();
    switch (id) {
      case 'jira':
        if (isOauthCredential) {
          final cloudId = (this['cloudId'] ?? '').toString().trim();
          return cloudId.isNotEmpty && extractProviderToken(id).isNotEmpty;
        }
        final email = (this['email'] ?? this['api.email'] ?? '')
            .toString()
            .trim();
        return email.isNotEmpty && extractProviderToken(id).isNotEmpty;
      case 'bitbucket':
        if (isOauthCredential) {
          return extractProviderToken(id).isNotEmpty;
        }
        final username = (this['username'] ?? '').toString().trim();
        return username.isNotEmpty && extractProviderToken(id).isNotEmpty;
      default:
        return extractProviderToken(id).isNotEmpty;
    }
  }
}
