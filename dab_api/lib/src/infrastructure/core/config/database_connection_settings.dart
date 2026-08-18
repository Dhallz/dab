/// [ARCH: INFRASTRUCTURE]
/// ROLE: Resolved Postgres endpoint for local Compose or Railway `DATABASE_URL`.
/// CONTRACT: [parseUrl] understands `postgres://` and `postgresql://`. SSL is
/// on only when [sslmode] is `require` / `verify-full` / `verify-ca`, unless
/// [sslOverride] forces it.
class DatabaseConnectionSettings {
  const DatabaseConnectionSettings({
    required this.host,
    required this.port,
    required this.database,
    required this.user,
    required this.password,
    required this.useSsl,
  });

  final String host;
  final int port;
  final String database;
  final String user;
  final String password;
  final bool useSsl;

  /// Discrete `DB_*` vars (Docker Compose) plus optional [url] / [sslOverride].
  ///
  /// [sslOverride] `true`/`false` wins over the URL. Empty keeps URL `sslmode`
  /// (or off when using discrete vars).
  factory DatabaseConnectionSettings.resolve({
    required String url,
    required String host,
    required int port,
    required String database,
    required String user,
    required String password,
    String sslOverride = '',
  }) {
    final trimmedUrl = url.trim();
    final fromUrl = trimmedUrl.isEmpty ? null : parseUrl(trimmedUrl);
    final resolved = fromUrl ??
        DatabaseConnectionSettings(
          host: host,
          port: port,
          database: database,
          user: user,
          password: password,
          useSsl: false,
        );
    final override = _parseBoolOverride(sslOverride);
    if (override == null) return resolved;
    return DatabaseConnectionSettings(
      host: resolved.host,
      port: resolved.port,
      database: resolved.database,
      user: resolved.user,
      password: resolved.password,
      useSsl: override,
    );
  }

  /// Parses a Railway-style Postgres URL.
  static DatabaseConnectionSettings parseUrl(String url) {
    final uri = Uri.parse(url);
    if (uri.scheme != 'postgres' && uri.scheme != 'postgresql') {
      throw FormatException('DATABASE_URL must be postgres(ql)://, got $url');
    }
    final userInfo = _splitUserInfo(uri.userInfo);
    final pathDb = uri.pathSegments.where((s) => s.isNotEmpty).firstOrNull;
    final sslMode = uri.queryParameters['sslmode']?.toLowerCase();
    final useSsl =
        sslMode == 'require' ||
        sslMode == 'verify-full' ||
        sslMode == 'verify_ca';
    return DatabaseConnectionSettings(
      host: uri.host,
      port: uri.hasPort ? uri.port : 5432,
      database: pathDb ?? '',
      user: userInfo.$1,
      password: userInfo.$2,
      useSsl: useSsl,
    );
  }
}

(String, String) _splitUserInfo(String userInfo) {
  if (userInfo.isEmpty) return ('', '');
  final colon = userInfo.indexOf(':');
  if (colon < 0) {
    return (Uri.decodeComponent(userInfo), '');
  }
  return (
    Uri.decodeComponent(userInfo.substring(0, colon)),
    Uri.decodeComponent(userInfo.substring(colon + 1)),
  );
}

bool? _parseBoolOverride(String raw) {
  switch (raw.trim().toLowerCase()) {
    case 'true':
    case '1':
    case 'yes':
      return true;
    case 'false':
    case '0':
    case 'no':
      return false;
    default:
      return null;
  }
}
