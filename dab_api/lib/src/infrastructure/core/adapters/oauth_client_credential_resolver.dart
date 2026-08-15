import '../../domain/ports/i_oauth_client_credential_resolver.dart';
import '../core/config/config.dart';

/// Reads a usable OAuth setting, skipping JSON null and the string `null`.
String? readOauthSetting(Map<String, dynamic> settings, List<String> keys) {
  for (final key in keys) {
    if (!settings.containsKey(key)) continue;
    final raw = settings[key];
    if (raw == null) continue;
    var value = raw.toString().trim();
    if (value.length >= 2) {
      final first = value[0];
      final last = value[value.length - 1];
      if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
        value = value.substring(1, value.length - 1).trim();
      }
    }
    if (value.isEmpty || value.toLowerCase() == 'null') continue;
    return value;
  }
  return null;
}

/// [ARCH: INFRASTRUCTURE]
/// ROLE: OAuth app credentials from [ProviderConfig.settings] with env fallback.
class OauthClientCredentialResolver implements IOauthClientCredentialResolver {
  OauthClientCredentialResolver(this._config);

  final Config _config;

  @override
  OauthAppCredentials? resolve({
    required String providerId,
    required Map<String, dynamic> orgSettings,
  }) {
    final fromSettings = readOauthSetting(orgSettings, const [
      'clientId',
      'oauthClientId',
    ]);
    final secretFromSettings = readOauthSetting(orgSettings, const [
      'clientSecret',
      'oauthClientSecret',
    ]);
    final id = (fromSettings != null && fromSettings.isNotEmpty)
        ? fromSettings
        : _config.oauthClientId(providerId);
    if (id.isEmpty) return null;
    final secret = (secretFromSettings != null && secretFromSettings.isNotEmpty)
        ? secretFromSettings
        : _config.oauthClientSecret(providerId);
    return OauthAppCredentials(
      clientId: id,
      clientSecret: secret.isEmpty ? null : secret,
    );
  }
}
