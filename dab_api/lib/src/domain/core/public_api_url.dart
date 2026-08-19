/// [ARCH: DOMAIN]
/// ROLE: Normalize Admin `public_api_url` for OAuth callbacks and webhooks.
/// CONTRACT: Loopback stays as saved. Public hosts are forced to HTTPS so
/// providers like Figma reject `http://` redirect URIs.
library;

/// Trims trailing slashes and upgrades non-loopback `http` origins to `https`.
String canonicalizePublicApiBase(String? raw) {
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
