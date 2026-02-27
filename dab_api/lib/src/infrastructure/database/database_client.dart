import 'package:postgres/postgres.dart';

import '../config/config.dart';

class DatabaseClient {
  static final DatabaseClient _instance = DatabaseClient._internal();
  factory DatabaseClient() => _instance;
  DatabaseClient._internal();

  Pool? _pool;

  Pool get pool {
    if (_pool == null) {
      final config = Config();
      _pool = Pool.withEndpoints(
        [
          Endpoint(
            host: config.dbHost,
            port: config.dbPort,
            database: config.dbName,
            username: config.dbUser,
            password: config.dbPass,
          ),
        ],
        settings: PoolSettings(
          maxConnectionCount: 10,
          sslMode: SslMode.disable,
        ),
      );
    }
    return _pool!;
  }

  Future<void> close() async {
    await _pool?.close();
    _pool = null;
  }
}
