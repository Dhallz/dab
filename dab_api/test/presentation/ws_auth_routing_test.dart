import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

void main() {
  group('ws auth routing', () {
    test('GET /ws is protected by auth middleware', () async {
      Handler authRejectHandler(Handler next) {
        return (Request req) =>
            Response.unauthorized(body: Body.fromString('auth'));
      }

      Response okHandler(Request req) =>
          Response.ok(body: Body.fromString('ok'));

      final router = RelicRouter()
        ..use('/ws', authRejectHandler)
        ..get('/ws', okHandler);

      final request = TestRequest.create(url: Uri.parse('http://localhost/ws'));
      final response = await router.asHandler(request) as Response;

      expect(response.statusCode, 401);
    });
  });
}
