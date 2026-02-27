import 'package:dotenv/dotenv.dart';

class Config {
  static final Config _instance = Config._internal();
  factory Config() => _instance;
  Config._internal();

  final DotEnv _env = DotEnv(includePlatformEnvironment: true)..load();

  String get dbHost => _env['DB_HOST'] ?? 'localhost';
  int get dbPort => int.parse(_env['DB_PORT'] ?? '5432');
  String get dbName => _env['DB_NAME'] ?? 'db';
  String get dbUser => _env['DB_USER'] ?? 'postgres';
  String get dbPass => _env['DB_PASS'] ?? 'postgres';

  String get jwtSecret => _env['JWT_SECRET'] ?? 'change_me_to_something_secure';
  int get jwtExpiryMinutes => int.parse(_env['JWT_EXPIRY_MINUTES'] ?? '60');

  int get port => int.parse(_env['PORT'] ?? '8080');

  bool get isDevelopment =>
      _env['APP_ENV'] == 'development' || _env['APP_ENV'] == null;
}
