import 'package:dab_api/src/infrastructure/core/config/redis_connection_settings.dart';
import 'package:test/test.dart';

void main() {
  group('RedisConnectionSettings.parseUrl', () {
    test('parses Railway redis URL with default user and password', () {
      final settings = RedisConnectionSettings.parseUrl(
        'redis://default:s3cret@redis.railway.internal:6379',
      );
      expect(settings.host, 'redis.railway.internal');
      expect(settings.port, 6379);
      expect(settings.authPassword, 's3cret');
    });

    test('treats redis://:password@host as password-only userinfo', () {
      final settings = RedisConnectionSettings.parseUrl(
        'redis://:hunter2@localhost:6379',
      );
      expect(settings.authPassword, 'hunter2');
    });

    test('rejects rediss://', () {
      expect(
        () => RedisConnectionSettings.parseUrl(
          'rediss://default:s3cret@redis.example:6379',
        ),
        throwsFormatException,
      );
    });
  });

  group('RedisConnectionSettings.resolve', () {
    test('uses discrete REDIS_* with no AUTH when password is empty', () {
      final settings = RedisConnectionSettings.resolve(
        url: '',
        host: 'redis',
        port: 6379,
      );
      expect(settings.host, 'redis');
      expect(settings.authPassword, isNull);
    });

    test('REDIS_PASSWORD is used when REDIS_URL is empty', () {
      final settings = RedisConnectionSettings.resolve(
        url: '',
        host: 'redis',
        port: 6379,
        password: 'localpass',
      );
      expect(settings.authPassword, 'localpass');
    });
  });
}
