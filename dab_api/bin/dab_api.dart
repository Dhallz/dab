import 'dart:io';

import 'package:dab_api/dab_api.dart';
import 'package:dab_api/src/presentation/controllers/activity_controller.dart';
import 'package:dab_api/src/presentation/controllers/auth_controller.dart';
import 'package:dab_api/src/presentation/controllers/health_controller.dart';
import 'package:dab_api/src/presentation/middlewares/error_handler.dart';
import 'package:dab_api/src/presentation/middlewares/vegas_middleware.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:relic/relic.dart';

Future<void> main() async {
  final config = Config();

  // 1. Setup Service Locator (DI)
  // This now also initializes the database with Drift's native migrations
  await serviceLocator();
  print('Dependency injection and database ready.');

  // 2. Start background polling
  sl<ActivityService>().startPolling();
  print('Phorge polling started.');

  final app = RelicApp()
    ..use('/', GlobalErrorHandler().call)
    ..use('/', RequestLogger().call)
    ..get('/health', HealthController.check)
    ..post('/register', AuthController().register)
    ..post('/login', AuthController().login)
    ..use('/activities', VegasMiddleware.checkStaleness)
    ..get('/activities', ActivityController().getActivities)
    ..get('/ws', ActivityController().wsHandler)
    ..post('/mock/activity', ActivityController().createMock)
    ..get('/hello/:name/age/:age', helloHandler)
    ..fallback = respondWith(
      (_) => Response.notFound(
        body: Body.fromString("Sorry, that doesn't compute.\n"),
      ),
    );

  print('Starting Relic API on port ${config.port}...');
  await app.serve(address: InternetAddress.anyIPv4, port: config.port);
}

const _ageParam = PathParam<int>(#age, int.parse);

Response helloHandler(final Request req) {
  final name = req.pathParameters.raw[#name];
  final age = req.pathParameters.get(_ageParam);
  return Response.ok(
    body: Body.fromString('Hello, $name! To think you are $age years old.\n'),
  );
}
