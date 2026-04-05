import 'package:dab_api/src/infrastructure/logging/logging_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

class MockHandler extends Mock {
  Future<Result> call(Request request);
}

void main() {
  group('LoggingService & RequestLogger', () {
    late RequestLogger middleware;
    late MockHandler nextHandler;

    setUp(() {
      middleware = RequestLogger();
      nextHandler = MockHandler();
      registerFallbackValue(
        TestRequest.create(url: Uri.parse('http://localhost')),
      );
    });

    test('RequestLogger should add X-Request-ID to response headers', () async {
      final request = TestRequest.create(
        url: Uri.parse('http://localhost/test'),
      );

      final response = Response.ok(body: Body.fromString('ok'));

      when(
        () => nextHandler.call(any()),
      ).thenAnswer((_) async => response as Result);

      final handler = middleware.call((req) => nextHandler.call(req));
      final result = await handler(request);

      expect(result, isA<Response>());
      final finalResponse = result as Response;
      expect(finalResponse.headers['X-Request-ID'], isNotNull);
      expect(finalResponse.headers['X-Request-ID']!.first, startsWith('req_'));
    });

    test('RequestLogger should respect existing X-Request-ID', () async {
      final request = TestRequest.create(
        url: Uri.parse('http://localhost/test'),
        headers: {
          'X-Request-ID': ['existing_id'],
        },
      );

      final response = Response.ok(body: Body.fromString('ok'));

      when(() => nextHandler.call(any())).thenAnswer((_) async => response);

      final handler = middleware.call((req) => nextHandler.call(req));
      final result = await handler(request);

      expect(result, isA<Response>());
      final finalResponse = result as Response;
      expect(
        finalResponse.headers['X-Request-ID']!.first,
        equals('existing_id'),
      );
    });
  });
}
