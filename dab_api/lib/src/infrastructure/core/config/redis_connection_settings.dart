/// [ARCH: INFRASTRUCTURE]
/// ROLE: Resolved Redis endpoint for local Compose or Railway `REDIS_URL`.
/// CONTRACT: [parseUrl] understands `redis://`. `rediss://` is rejected — use
/// the private `redis://` URL. AUTH runs only when [password] is non-empty.
class RedisConnectionSettings {
  const RedisConnectionSettings({
    required this.host,
    required this.port,
    this.password,
  });

  final String host;
  final int port;
  final String? password;

  /// Non-empty password for `AUTH`; otherwise `null` (local Alpine Redis).
  String? get authPassword {
    final p = password?.trim();
    if (p == null || p.isEmpty) return null;
    return p;
  }

  /// Discrete `REDIS_*` vars plus optional [url].
  factory RedisConnectionSettings.resolve({
    required String url,
    required String host,
    required int port,
    String password = '',
  }) {
    final trimmedUrl = url.trim();
    if (trimmedUrl.isNotEmpty) return parseUrl(trimmedUrl);
    return RedisConnectionSettings(
      host: host,
      port: port,
      password: password.trim().isEmpty ? null : password.trim(),
    );
  }

  /// Parses a Railway-style Redis URL (`redis://default:pass@host:port`).
  static RedisConnectionSettings parseUrl(String url) {
    final uri = Uri.parse(url);
    if (uri.scheme == 'rediss') {
      throw FormatException(
        'REDIS_URL rediss:// is not supported. Use the private redis:// URL.',
      );
    }
    if (uri.scheme != 'redis') {
      throw FormatException('REDIS_URL must be redis://, got $url');
    }
    final userInfo = uri.userInfo;
    String? pass;
    if (userInfo.isNotEmpty) {
      final colon = userInfo.indexOf(':');
      pass = colon < 0
          ? Uri.decodeComponent(userInfo)
          : Uri.decodeComponent(userInfo.substring(colon + 1));
      if (pass.isEmpty) pass = null;
    }
    return RedisConnectionSettings(
      host: uri.host,
      port: uri.hasPort ? uri.port : 6379,
      password: pass,
    );
  }
}
