/// [ARCH: DOMAIN_PORT]
/// ROLE: Resolves per-user provider secrets overlaid on org [ProviderConfig.settings].
/// CONTRACT: User secrets win; watch lists and non-secret fields stay org-owned.
library;

/// Looks up encrypted user credentials and merges them onto org settings.
abstract interface class ICredentialResolver {
  /// Decrypted settings for one user × provider, or null when none stored.
  Future<Map<String, dynamic>?> getUserSettings({
    required String userId,
    required String providerId,
  });

  /// Decrypted settings keyed by DAB user id for a provider (missing users omitted).
  Future<Map<String, Map<String, dynamic>>> getUserSettingsForUsers({
    required Iterable<String> userIds,
    required String providerId,
  });

  /// Overlays user secret fields onto [orgSettings].
  Map<String, dynamic> overlay({
    required Map<String, dynamic> orgSettings,
    Map<String, dynamic>? userSettings,
  });
}
