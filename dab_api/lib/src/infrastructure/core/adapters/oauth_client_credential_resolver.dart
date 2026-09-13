import '../../../domain/contracts/ports/abs_i_oauth_client_credential_resolver.dart';
import '../config/config.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Reads a usable OAuth setting from a provider settings map.
extension OnProviderSettings on Map {
  /// First non-empty value among [keys], skipping JSON null and the string `null`.
  String? readOauthSetting(List<String> keys) {
    for (final key in keys) {
      if (!containsKey(key)) continue;
      final raw = this[key];
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
}

/// [ARCH: INFRASTRUCTURE]
/// ROLE: OAuth app credentials from [ProviderConfig.settings] with env fallback.
class OauthClientCredentialResolver
    implements AbsIOauthClientCredentialResolver {
  OauthClientCredentialResolver(this._config);

  final Config _config;

  @override
  OauthAppCredentials? resolve({
    required String providerId,
    required Map<String, dynamic> orgSettings,
  }) {
    final fromSettings = orgSettings.readOauthSetting(const [
      'clientId',
      'oauthClientId',
    ]);
    final secretFromSettings = orgSettings.readOauthSetting(const [
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
