import 'dart:io';

import 'package:dotenv/dotenv.dart';

class Config {
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  Config._internal();

  final DotEnv _env = DotEnv(includePlatformEnvironment: true)..load();

  String _getEnv(String key, String defaultValue) {
    return Platform.environment[key] ?? _env[key] ?? defaultValue;
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

  String get allowedDomain => _getEnv('DAB_ALLOWED_DOMAIN', 'example.com');
  String get initialAdminEmail => _getEnv('DAB_INITIAL_ADMIN_EMAIL', '');

  // Phorge Configuration
  String get phorgeUrl => _getEnv('PHORGE_URL', 'https://phorge.example.com');
  String get phorgeApiToken => _getEnv('PHORGE_API_TOKEN', '');
  String get phorgeWebhookSecret => _getEnv('PHORGE_WEBHOOK_SECRET', '');
}
