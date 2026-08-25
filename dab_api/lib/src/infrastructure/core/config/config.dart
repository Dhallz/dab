import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as p;

import 'database_connection_settings.dart';
import 'redis_connection_settings.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Process env + optional `.env` for API boot.
/// CONTRACT: `DATABASE_URL` / `REDIS_URL` win over discrete `DB_*` / `REDIS_*`.
class Config {
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  Config._internal()
    : _env = DotEnv(includePlatformEnvironment: true, quiet: true) {
    _loadEnvFiles();
  }

  /// [quiet]: no stderr spam when `.env` is absent (Docker/K8s use env vars only).
  final DotEnv _env;

  /// Loads `<dab_api package root>/.env`.
  ///
  /// Resolution order:
  /// 1. [Platform.environment]`DAB_API_ROOT` — absolute path to the `dab_api` package (for
  ///    Docker / compiled binaries with no nearby [pubspec.yaml]).
  /// 2. Walk parents of [Platform.script] until a [pubspec.yaml] with `name: dab_api` is found.
  ///    (Needed because for `dart compile exe`, [Platform.script] is the binary path, not
  ///    `bin/dab_api.dart`, so `script/../` is not the package root.)
  /// 3. Same walk from [Directory.current] (covers running a binary from the repo with cwd set).
  ///
  /// `.env` fills defaults; [Platform.environment] wins on conflict (Docker/CI).
  void _loadEnvFiles() {
    try {
      final envPath = _dabApiDotEnvPath();
      if (envPath != null && File(envPath).existsSync()) {
        _env.load([envPath]);
      } else {
        // DotEnv only merges Platform.environment into its internal map during a load() call.
        // We must call it even if no file is present to pick up Docker/shell environment variables.
        _env.load([]);
      }
    } catch (_) {
      // If load fails (e.g. no read permission), we still want to proceed with whatever is defined.
    }
  }

  static String? _dabApiDotEnvPath() {
    final root = _resolveDabApiPackageRoot();
    if (root == null) return null;
    return p.join(root, '.env');
  }

  static String? _resolveDabApiPackageRoot() {
    final override = Platform.environment['DAB_API_ROOT']?.trim();
    if (override != null && override.isNotEmpty) {
      final dir = Directory(p.normalize(override));
      if (dir.existsSync()) {
        return p.normalize(dir.absolute.path);
      }
    }

    String? walkUpForPackage(Directory start) {
      var dir = start;
      for (var i = 0; i < 24; i++) {
        final pubspec = File(p.join(dir.path, 'pubspec.yaml'));
        if (pubspec.existsSync() && _pubspecIsDabApi(pubspec.path)) {
          return p.normalize(dir.absolute.path);
        }
        final parent = dir.parent;
        if (parent.path == dir.path) return null;
        dir = parent;
      }
      return null;
    }

    String? fromScript;
    final scriptUri = Platform.script;
    if (scriptUri.scheme == 'file') {
      final scriptFile = scriptUri.toFilePath();
      fromScript =
          walkUpForPackage(Directory(p.dirname(p.normalize(scriptFile))));
    }
    if (fromScript != null) return fromScript;

    return walkUpForPackage(Directory.current);
  }

  static bool _pubspecIsDabApi(String pubspecPath) {
    try {
      final content = File(pubspecPath).readAsStringSync();
      return RegExp(r'^name:\s*dab_api\s*$', multiLine: true).hasMatch(content);
    } catch (_) {
      return false;
    }
  }

  /// Process environment overrides `.env` (e.g. `REDIS_HOST=redis` in compose).
  String _getEnv(String key, String defaultValue) {
    final fromPlatform = Platform.environment[key];
    if (fromPlatform != null && fromPlatform.isNotEmpty) {
      return fromPlatform;
    }
    return _env[key] ?? defaultValue;
  }

  DatabaseConnectionSettings? _database;
  RedisConnectionSettings? _redis;

  /// Postgres from `DATABASE_URL` when set, otherwise discrete `DB_*` vars.
  DatabaseConnectionSettings get database =>
      _database ??= DatabaseConnectionSettings.resolve(
        url: _getEnv('DATABASE_URL', ''),
        host: _getEnv('DB_HOST', 'localhost'),
        port: int.parse(_getEnv('DB_PORT', '5432')),
        database: _getEnv('DB_NAME', 'db'),
        user: _getEnv('DB_USER', 'postgres'),
        password: _getEnv('DB_PASS', 'postgres'),
        sslOverride: _getEnv('DAB_DB_SSL', ''),
      );

  String get dbHost => database.host;
  int get dbPort => database.port;
  String get dbName => database.database;
  String get dbUser => database.user;
  String get dbPass => database.password;
  bool get dbUseSsl => database.useSsl;

  /// Redis from `REDIS_URL` when set, otherwise discrete `REDIS_*` vars.
  RedisConnectionSettings get redis =>
      _redis ??= RedisConnectionSettings.resolve(
        url: _getEnv('REDIS_URL', ''),
        host: _getEnv('REDIS_HOST', 'localhost'),
        port: int.parse(_getEnv('REDIS_PORT', '6379')),
        password: _getEnv('REDIS_PASSWORD', ''),
      );

  String get redisHost => redis.host;
  int get redisPort => redis.port;
  String? get redisPassword => redis.authPassword;

  /// Placeholder rejected when [isDevelopment] is false.
  static const insecureJwtPlaceholder = 'change_me_to_something_secure';

  String get jwtSecret => _getEnv('JWT_SECRET', insecureJwtPlaceholder);
  int get jwtExpiryMinutes => int.parse(_getEnv('JWT_EXPIRY_MINUTES', '60'));

  int get port => int.parse(_getEnv('PORT', '8080'));

  bool get isDevelopment => _getEnv('APP_ENV', 'development') == 'development';

  /// Screenshot seed (`POST /mock/demo-day`). On in development, or when
  /// `DAB_ENABLE_MOCK=true`. Explicit `false` disables even in development.
  bool get enableMock {
    final flag = _getEnv('DAB_ENABLE_MOCK', '').trim().toLowerCase();
    if (flag == 'true' || flag == '1') return true;
    if (flag == 'false' || flag == '0') return false;
    return isDevelopment;
  }

  /// Google FCM HTTP v1 service-account JSON or a path to that file.
  ///
  /// Empty in development; wake is a no-op when unset or unreadable.
  String get fcmServiceAccountJson {
    final raw = _getEnv('FCM_SERVICE_ACCOUNT_JSON', '').trim();
    if (raw.isEmpty) return '';
    if (raw.startsWith('{')) return raw;
    try {
      final file = File(raw);
      if (file.existsSync()) return file.readAsStringSync();
    } catch (_) {
      return '';
    }
    return raw;
  }

  /// Throws when production would boot with the compiled-in JWT default.
  void ensureProductionSecrets() {
    if (isDevelopment) return;
    if (jwtSecret == insecureJwtPlaceholder) {
      throw StateError(
        'JWT_SECRET must be set when APP_ENV is not development.',
      );
    }
  }

  /// Allowed registration email domain from [DAB_ALLOWED_DOMAIN] (merged `.env` + platform).
  ///
  /// Bare hostname (`corp.com`) or, if pasted by mistake, `user@corp.com` (host after `@`).
  String get allowedDomain {
    final raw = _getEnv('DAB_ALLOWED_DOMAIN', '').trim();
    if (raw.isEmpty) return '';
    return _domainFromHostOrEmail(raw);
  }

  static String _domainFromHostOrEmail(String raw) {
    final t = raw.trim();
    final at = t.lastIndexOf('@');
    if (at > 0 && at < t.length - 1) {
      return t.substring(at + 1).toLowerCase();
    }
    return t.toLowerCase();
  }

  String get initialAdminEmail => _getEnv('DAB_INITIAL_ADMIN_EMAIL', '');

  /// AES key material for per-user provider credentials. Falls back to [jwtSecret].
  String get credentialsKey {
    final raw = _getEnv('DAB_CREDENTIALS_KEY', '').trim();
    return raw.isEmpty ? jwtSecret : raw;
  }

  /// OAuth app client id from `DAB_{PROVIDER}_OAUTH_CLIENT_ID`.
  String oauthClientId(String providerId) => _getEnv(
    'DAB_${providerId.trim().toUpperCase()}_OAUTH_CLIENT_ID',
    '',
  ).trim();

  /// OAuth app client secret from `DAB_{PROVIDER}_OAUTH_CLIENT_SECRET`.
  String oauthClientSecret(String providerId) => _getEnv(
    'DAB_${providerId.trim().toUpperCase()}_OAUTH_CLIENT_SECRET',
    '',
  ).trim();

  // Phorge Configuration
  String get phorgeUrl => _getEnv('PHORGE_URL', '');
  String get phorgeApiToken => _getEnv('PHORGE_API_TOKEN', '');
  String get phorgeWebhookSecret => _getEnv('PHORGE_WEBHOOK_SECRET', '');

  /// When true, bypass TLS verification for outbound HTTPS (Phorge). Use for
  /// self-signed or internal-CA in Docker dev. Set PHORGE_TLS_INSECURE=true.
  bool get phorgeTlsInsecure =>
      _getEnv('PHORGE_TLS_INSECURE', 'false').toLowerCase() == 'true';
}
