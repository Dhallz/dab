import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/presentation/middlewares/vegas_middleware.dart';
import 'package:mocktail/mocktail.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

class MockRedisService extends Mock implements RedisService {}

void main() {
  late MockRedisService mockRedis;
  late Handler innerHandler;

  setUp(() {
    mockRedis = MockRedisService();
    // Mock inner handler that returns 200 OK
    innerHandler = (Request request) async {
      return Response(200, body: Body.empty()) as Result;
    };
  });

  group('VegasMiddleware Staleness Checks', () {
    test(
      'returns 304 Not Modified when X-Sync-Token matches Redis version',
      () async {
        when(() => mockRedis.getCurrentVersion()).thenAnswer((_) async => 1042);

        final handler = VegasMiddleware.checkStaleness(
          innerHandler,
          redisService: mockRedis,
        );
        final request = TestRequest.create(
          url: Uri.parse('http://localhost/activities'),
          headers: {
            'X-Sync-Token': ['1042'],
          },
        );

        final result = await handler(request);
        expect(result, isA<Response>());
        final response = result as Response;

        expect(response.statusCode, equals(304));
        verify(() => mockRedis.getCurrentVersion()).called(1);
      },
    );

    test(
      'calls inner handler (returns 200) when X-Sync-Token does NOT match',
      () async {
        when(() => mockRedis.getCurrentVersion()).thenAnswer((_) async => 1045);

        final handler = VegasMiddleware.checkStaleness(
          innerHandler,
          redisService: mockRedis,
        );
        final request = TestRequest.create(
          url: Uri.parse('http://localhost/activities'),
          headers: {
            'X-Sync-Token': ['1042'],
          },
        );

        final result = await handler(request);
        expect(result, isA<Response>());
        final response = result as Response;

        expect(response.statusCode, equals(200));
        verify(() => mockRedis.getCurrentVersion()).called(1);
      },
    );

    test('calls inner handler when X-Sync-Token header is missing', () async {
      final handler = VegasMiddleware.checkStaleness(
        innerHandler,
        redisService: mockRedis,
      );
      final request = TestRequest.create(
        url: Uri.parse('http://localhost/activities'),
      );

      final response = await handler(request);

      expect(response is Response, isTrue);
      expect((response as Response).statusCode, equals(200));
      verifyNever(() => mockRedis.getCurrentVersion());
    });
  });
}
