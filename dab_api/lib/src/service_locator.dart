import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:get_it/get_it.dart';

import 'application/activity_service.dart';
import 'application/auth_service.dart';
import 'application/logging_service.dart';
import 'application/presence_service.dart';
import 'application/push_notification_service.dart';
import 'infrastructure/config/config.dart';
import 'infrastructure/database/app_database.dart';
import 'infrastructure/database/postgres_client.dart';
import 'infrastructure/database/redis/redis_client.dart';
import 'infrastructure/database/redis/redis_service.dart';
import 'infrastructure/repositories/activity_repository.dart';
import 'infrastructure/repositories/auth_repository.dart';

final GetIt sl = GetIt.instance;

Future<void> serviceLocator() async {
  // 1. Infrastructure
  final db = PostgresClient().db;
  sl.registerSingleton<AppDatabase>(db);

  final config = Config(); // Use existing config or inject it
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

  sl.registerSingleton<AuthService>(AuthService(sl<AbsIAuthRepository>()));

  sl.registerSingleton<ActivityService>(
    ActivityService(
      activityRepo: sl<AbsIActivityRepository>(),
      authRepo: sl<AbsIAuthRepository>(),
      presence: sl<PresenceService>(),
      redis: sl<RedisService>(),
    ),
  );
}
