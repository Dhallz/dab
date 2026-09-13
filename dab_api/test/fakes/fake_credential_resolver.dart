import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_credential_resolver.dart';

/// Test double that returns preloaded per-user settings maps.
class FakeCredentialResolver implements AbsICredentialResolver {
  FakeCredentialResolver([this.userSettings = const {}]);

  final Map<String, Map<String, dynamic>> userSettings;

  @override
  Future<Map<String, dynamic>?> getUserSettings({
    required String userId,
    required String providerId,
  }) async {
    return userSettings[userId];
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getUserSettingsForUsers({
    required Iterable<String> userIds,
    required String providerId,
  }) async {
    final out = <String, Map<String, dynamic>>{};
    for (final id in userIds) {
      final settings = userSettings[id];
      if (settings != null) out[id] = settings;
    }
    return out;
  }

  @override
  Map<String, dynamic> overlay({
    required Map<String, dynamic> orgSettings,
    Map<String, dynamic>? userSettings,
  }) {
    return orgSettings.overlayProviderSecrets(userSettings);
  }
}
