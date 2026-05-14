import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:path/path.dart' as p;

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
  /// File values from dotenv [load] overlay [Platform.environment] keys (later wins).
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

  /// Reads merged env (platform + `.env` file).
  String _getEnv(String key, String defaultValue) {
    return _env[key] ?? defaultValue;
  }

  String get dbHost => _getEnv('DB_HOST', 'localhost');
  int get dbPort => int.parse(_getEnv('DB_PORT', '5432'));
  String get dbName => _getEnv('DB_NAME', 'db');
  String get dbUser => _getEnv('DB_USER', 'postgres');
  String get dbPass => _getEnv('DB_PASS', 'postgres');

  String get redisHost => _getEnv('REDIS_HOST', 'localhost');
  int get redisPort => int.parse(_getEnv('REDIS_PORT', '6379'));

  String get jwtSecret =>
      _getEnv('JWT_SECRET', 'change_me_to_something_secure');
  int get jwtExpiryMinutes => int.parse(_getEnv('JWT_EXPIRY_MINUTES', '60'));

  int get port => int.parse(_getEnv('PORT', '8080'));

  bool get isDevelopment => _getEnv('APP_ENV', 'development') == 'development';

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

  // Phorge Configuration
  String get phorgeUrl => _getEnv('PHORGE_URL', '');
  String get phorgeApiToken => _getEnv('PHORGE_API_TOKEN', '');
  String get phorgeWebhookSecret => _getEnv('PHORGE_WEBHOOK_SECRET', '');

  /// When true, bypass TLS verification for outbound HTTPS (Phorge). Use for
  /// self-signed or internal-CA in Docker dev. Set PHORGE_TLS_INSECURE=true.
  bool get phorgeTlsInsecure =>
      _getEnv('PHORGE_TLS_INSECURE', 'false').toLowerCase() == 'true';
}
