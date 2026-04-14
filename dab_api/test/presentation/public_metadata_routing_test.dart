import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

/// Regression: Relic [Router.use] applies middleware to every route whose lookup
/// walks through that prefix node. `use('/metadata', auth)` incorrectly wrapped
/// `/metadata/configs` and `/metadata/status`. The API must scope auth to
/// `/metadata/providers` only; this test models that shape.
void main() {
  group('public metadata routing', () {
    test('GET /metadata/configs and /metadata/status skip auth under '
        '/metadata/providers middleware', () async {
      Handler authRejectHandler(Handler next) {
        return (Request req) =>
            Response.unauthorized(body: Body.fromString('auth'));
      }

      Response okHandler(Request req) =>
          Response.ok(body: Body.fromString('ok'));

      final router = RelicRouter()
        ..get('/metadata/status', okHandler)
        ..get('/metadata/configs', okHandler)
        ..use('/metadata/providers', authRejectHandler)
        ..use('/metadata/capabilities', authRejectHandler)
        ..get('/metadata/capabilities', okHandler)
        ..get('/metadata/providers', okHandler);

      final configsReq = TestRequest.create(
        url: Uri.parse('http://localhost/metadata/configs'),
      );
      final statusReq = TestRequest.create(
        url: Uri.parse('http://localhost/metadata/status'),
      );
      final providersReq = TestRequest.create(
        url: Uri.parse('http://localhost/metadata/providers'),
      );
      final capabilitiesReq = TestRequest.create(
        url: Uri.parse('http://localhost/metadata/capabilities'),
      );

      final configsRes = await router.asHandler(configsReq) as Response;
      final statusRes = await router.asHandler(statusReq) as Response;
      final providersRes = await router.asHandler(providersReq) as Response;
      final capabilitiesRes =
          await router.asHandler(capabilitiesReq) as Response;

      expect(configsRes.statusCode, 200);
      expect(statusRes.statusCode, 200);
      expect(providersRes.statusCode, 401);
      expect(capabilitiesRes.statusCode, 401);
    });
  });
}
