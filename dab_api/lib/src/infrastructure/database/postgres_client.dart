import 'package:postgres/postgres.dart' as pg hide Session;

import '../core/config/config.dart';
import 'app_database.dart';

class PostgresClient {
  static final PostgresClient _instance = PostgresClient._internal();
  factory PostgresClient() => _instance;
  PostgresClient._internal();

  pg.Pool? _pool;
  AppDatabase? _db;

  pg.Pool get pool {
    if (_pool == null) {
      final config = Config();
      _pool = pg.Pool.withEndpoints(
        [
          pg.Endpoint(
            host: config.dbHost,
            port: config.dbPort,
            database: config.dbName,
            username: config.dbUser,
            password: config.dbPass,
          ),
        ],
        settings: pg.PoolSettings(
          maxConnectionCount: 10,
          sslMode: pg.SslMode.disable,
        ),
      );
    }
    return _pool!;
  }

  AppDatabase get db {
    if (_db == null) {
      final config = Config();
      _db = AppDatabase.connect(
        host: config.dbHost,
        port: config.dbPort,
        database: config.dbName,
        user: config.dbUser,
        password: config.dbPass,
      );
    }
    return _db!;
  }

  Future<void> close() async {
    await _pool?.close();
    await _db?.close();
    _pool = null;
    _db = null;
  }
}
