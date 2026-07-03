import 'dart:io';

import 'package:dab_api/dab_api.dart';
import 'package:dab_api/src/infrastructure/logging/logging_service.dart';
import 'package:dab_api/src/presentation/controllers/activity_controller.dart';
import 'package:dab_api/src/presentation/controllers/admin_controller.dart';
import 'package:dab_api/src/presentation/controllers/auth_controller.dart';
import 'package:dab_api/src/presentation/controllers/group_controller.dart';
import 'package:dab_api/src/presentation/controllers/health_controller.dart';
import 'package:dab_api/src/presentation/controllers/metadata_controller.dart';
import 'package:dab_api/src/presentation/controllers/user_controller.dart';
import 'package:dab_api/src/presentation/middlewares/admin_middleware.dart';
import 'package:dab_api/src/presentation/middlewares/auth_middleware.dart';
import 'package:dab_api/src/application/services/activity_purge_scheduler.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_gateway_service.dart';
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

  // 2. Start the daily UTC midnight purge of stale live-feed entries (archived
  //    or older than the current UTC calendar day).
  sl<ActivityPurgeScheduler>().start();

  // 3. Start the Discord Gateway client (live Dashboard ingestion) when the
  //    Discord provider is active. No-op otherwise.
  await sl<DiscordGatewayService>().start();

  final app = RelicApp()
    ..use('/', GlobalErrorHandler().call)
    ..use('/', RequestLogger().call)
    ..get('/health', HealthController().check)
    ..get('/health/db', HealthController().checkDb)
    ..post('/auth/register', AuthController().register)
    ..post('/auth/login', AuthController().login)
    ..post('/auth/refresh', AuthController().refresh)
    ..get('/metadata/status', MetadataController().getStatus)
    // Public: app bootstrap (same as status) — must be BEFORE /metadata + AuthMiddleware.
    ..get('/metadata/configs', MetadataController().getConfigs)
    ..use('/activities', AuthMiddleware().call)
    ..use('/activities', VegasMiddleware.checkStaleness)
    ..get('/activities/search', ActivityController().searchActivities)
    ..post(
      '/activities/live/:id/archive',
      ActivityController().archiveLiveActivity,
    )
    ..post(
      '/activities/live/:id/unarchive',
      ActivityController().unarchiveLiveActivity,
    )
    ..get('/activities/live', ActivityController().getLiveActivities)
    ..get('/activities', ActivityController().getActivities)
    ..post(
      '/integrations/slack/events',
      ActivityController().receiveSlackEvents,
    )
    ..post(
      '/integrations/github/webhook',
      ActivityController().receiveGitHubWebhook,
    )
    ..post(
      '/integrations/phorge/webhook',
      ActivityController().receivePhorgeWebhook,
    )
    ..post(
      '/integrations/jira/webhook',
      ActivityController().receiveJiraWebhook,
    )
    ..post(
      '/integrations/linear/webhook',
      ActivityController().receiveLinearWebhook,
    )
    ..post(
      '/integrations/gitlab/webhook',
      ActivityController().receiveGitLabWebhook,
    )
    ..post(
      '/integrations/bitbucket/webhook',
      ActivityController().receiveBitbucketWebhook,
    )
    ..use('/ws', AuthMiddleware().call)
    ..get('/ws', ActivityController().wsHandler)
    ..post('/mock/activity', ActivityController().createMock)
    // Auth only on /metadata/providers — Relic's use(prefix) wraps ALL deeper
    // routes under that prefix, so use('/metadata', …) also wrapped /configs and /status.
    ..use('/metadata/providers', AuthMiddleware().call)
    ..use('/metadata/capabilities', AuthMiddleware().call)
    ..get('/metadata/providers', MetadataController().getProviders)
    ..get('/metadata/capabilities', MetadataController().getCapabilities)
    ..use('/users', AuthMiddleware().call)
    ..get('/users', UserController().getUsers)
    ..get('/users/:id', UserController().getUser)
    ..post('/users/sync', UserController().syncUsers)
    ..use('/groups', AuthMiddleware().call)
    ..get('/groups', GroupController().getGroups)
    ..post('/groups', GroupController().saveGroup)
    ..delete('/groups/:id', GroupController().deleteGroup)
    // --- Admin Console (DAB-40) ---
    // All routes under /admin require both authentication and admin role.
    ..use('/admin', AuthMiddleware().call)
    ..use('/admin', AdminMiddleware().call)
    // Provider Management
    ..get('/admin/configs', MetadataController().getConfigs)
    ..post('/admin/configs', MetadataController().saveConfig)
    ..post('/admin/configs/test', MetadataController().testConfig)
    // System Settings
    ..get('/admin/system-settings', MetadataController().getSystemSettings)
    ..put('/admin/system-settings', MetadataController().saveSystemSettings)
    // Identity Resolution (specific paths before list route)
    ..get('/admin/identities/summary', AdminController().getIdentitiesSummary)
    ..get('/admin/identities', AdminController().getIdentities)
    ..post('/admin/identities/link', AdminController().linkIdentity)
    ..post('/admin/identities/resolve', AdminController().resolveIdentity)
    // User Management
    ..get('/admin/users', AdminController().getUsers)
    ..post('/admin/users', AdminController().createUser)
    ..post('/admin/users/role', AdminController().postUpdateUserRole)
    // ------------------------------
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
