/// [ARCH: DOMAIN]
/// ROLE: Resolves the Phorge site URL from provider settings.
/// CONTRACT: `instanceUrl` wins over [ProviderConfig.baseUrl]. Trailing slashes
/// are stripped. Empty input yields null.
library;

/// HTTPS origin of the Phorge instance (no `/api` suffix).
String? phorgeInstanceUrl({
  String? instanceUrl,
  String? baseUrl,
}) {
  final fromSettings = (instanceUrl ?? '').trim();
  if (fromSettings.isNotEmpty) {
    return fromSettings.replaceAll(RegExp(r'/+$'), '');
  }
  final base = (baseUrl ?? '').trim().replaceAll(RegExp(r'/+$'), '');
  if (base.isEmpty) return null;
  return base;
}
