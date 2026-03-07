import 'package:dab_api/src/application/activity_service.dart';
import 'package:dab_api/src/application/auth_service.dart';
import 'package:dab_api/src/application/logging_service.dart';
import 'package:dab_api/src/application/metadata_service.dart';
import 'package:dab_api/src/application/presence_service.dart';
import 'package:dab_api/src/application/push_notification_service.dart';
import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_metadata_repository.dart';
import 'package:dab_api/src/infrastructure/config/config.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_connector.dart';
import 'package:dab_api/src/infrastructure/database/app_database.dart';
import 'package:dab_api/src/infrastructure/database/postgres_client.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_client.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/repositories/activity_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/auth_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_metadata_repository.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

Future<void> serviceLocator() async {
  // 1. Infrastructure
  final pgClient = PostgresClient();
  final db = pgClient.db;
  sl.registerSingleton<PostgresClient>(pgClient);
  sl.registerSingleton<AppDatabase>(db);

  final config = Config(); // Use existing config or inject it
  sl.registerSingleton<Config>(config);

  final redisClient = RedisClient(
    host: config.redisHost,
    port: config.redisPort,
  );
  await redisClient.connect();
  sl.registerSingleton<RedisClient>(redisClient);
  sl.registerSingleton<RedisService>(RedisService(redisClient));

  // 2. Repositories
  sl.registerSingleton<AbsIAuthRepository>(AuthRepository(db));
  sl.registerSingleton<AbsIActivityRepository>(ActivityRepository(db));

  // 3. Services (Application Layer)
  sl.registerSingleton<PresenceService>(PresenceService());
  sl.registerSingleton<LoggingService>(LoggingService());
  sl.registerSingleton<PushNotificationService>(PushNotificationService());

  // Inter-service Connectors
  sl.registerSingleton<PhorgeConnector>(PhorgeConnector());

  sl.registerSingleton<AuthService>(
    AuthService(sl<AbsIAuthRepository>(), sl<PhorgeConnector>()),
  );

  // Metadata
  sl.registerSingleton<AbsIProviderMetadataRepository>(
    ProviderMetadataRepository(phorgeConnector: sl<PhorgeConnector>()),
  );
  sl.registerSingleton<AbsIProviderConfigRepository>(
    ProviderConfigRepository(config: sl<Config>()),
  );
  sl.registerSingleton<MetadataService>(
    MetadataService(
      repo: sl<AbsIProviderMetadataRepository>(),
      configRepo: sl<AbsIProviderConfigRepository>(),
    ),
  );
  sl.registerSingleton<ActivityService>(
    ActivityService(
      activityRepo: sl<AbsIActivityRepository>(),
      authRepo: sl<AbsIAuthRepository>(),
      presence: sl<PresenceService>(),
      redis: sl<RedisService>(),
    ),
  );
}
