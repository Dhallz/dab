import 'package:dab_api/src/infrastructure/core/config/database_connection_settings.dart';
import 'package:test/test.dart';

void main() {
  group('DatabaseConnectionSettings.parseUrl', () {
    test('parses Railway-style postgresql URL with sslmode=require', () {
      final settings = DatabaseConnectionSettings.parseUrl(
        'postgresql://postgres:s3cret@postgres.railway.internal:5432/railway?sslmode=require',
      );
      expect(settings.host, 'postgres.railway.internal');
      expect(settings.port, 5432);
      expect(settings.database, 'railway');
      expect(settings.user, 'postgres');
      expect(settings.password, 's3cret');
      expect(settings.useSsl, isTrue);
    });

    test('defaults port 5432 and leaves SSL off without sslmode', () {
      final settings = DatabaseConnectionSettings.parseUrl(
        'postgres://user:pass@db/dab_api_db',
      );
      expect(settings.port, 5432);
      expect(settings.database, 'dab_api_db');
      expect(settings.useSsl, isFalse);
    });

    test('decodes percent-encoded passwords', () {
      final settings = DatabaseConnectionSettings.parseUrl(
        'postgres://user:p%40ss@localhost:5432/db',
      );
      expect(settings.password, 'p@ss');
    });
  });

  group('DatabaseConnectionSettings.resolve', () {
    test('uses discrete DB_* when DATABASE_URL is empty (local Compose)', () {
      final settings = DatabaseConnectionSettings.resolve(
        url: '',
        host: 'db',
        port: 5432,
        database: 'dab_api_db',
        user: 'user',
        password: 'password',
      );
      expect(settings.host, 'db');
      expect(settings.useSsl, isFalse);
    });

    test('DAB_DB_SSL=true forces SSL on a URL without sslmode', () {
      final settings = DatabaseConnectionSettings.resolve(
        url: 'postgres://user:pass@db:5432/dab',
        host: 'localhost',
        port: 5432,
        database: 'db',
        user: 'postgres',
        password: 'postgres',
        sslOverride: 'true',
      );
      expect(settings.host, 'db');
      expect(settings.useSsl, isTrue);
    });

    test('DAB_DB_SSL=false forces SSL off even when sslmode=require', () {
      final settings = DatabaseConnectionSettings.resolve(
        url: 'postgres://user:pass@host:5432/db?sslmode=require',
        host: 'localhost',
        port: 5432,
        database: 'db',
        user: 'postgres',
        password: 'postgres',
        sslOverride: 'false',
      );
      expect(settings.useSsl, isFalse);
    });
  });
}
