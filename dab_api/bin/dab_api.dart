import 'dart:io';

import 'package:dab_api/src/infrastructure/config/config.dart';
import 'package:dab_api/src/infrastructure/database/database_migrator.dart';
import 'package:dab_api/src/presentation/controllers/auth_controller.dart';
import 'package:dab_api/src/presentation/controllers/health_controller.dart';
import 'package:dab_api/src/presentation/middlewares/error_handler.dart';
import 'package:dab_api/src/services/logging_service.dart';
import 'package:relic/relic.dart';

Future<void> main() async {
  final config = Config();

  // Run migrations before starting
  print('Initializing database...');
  try {
    await DatabaseMigrator.runMigrations();
    print('Migrations completed successfully.');
  } catch (e) {
    print('Migration failed: $e');
  }

  final app = RelicApp()
    // Global Middlewares (Executed in order)
    ..use('/', GlobalErrorHandler().call)
    ..use('/', RequestLogger().call)
    // Public routes
    ..get('/health', HealthController.check)
    // Auth routes
    ..post('/register', AuthController().register)
    ..post('/login', AuthController().login)
    // Sample Hello World
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
