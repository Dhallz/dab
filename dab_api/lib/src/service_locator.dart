import 'package:get_it/get_it.dart';

// domain
import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_metadata_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_health_repository.dart';

// application / usecases
import 'package:dab_api/src/application/usecases/activity/fetch_remote_activities.dart';
import 'package:dab_api/src/application/usecases/activity/get_recent_activities.dart';
import 'package:dab_api/src/application/usecases/activity/search_activities.dart';
import 'package:dab_api/src/application/usecases/activity/log_activity.dart';

import 'package:dab_api/src/application/usecases/auth/login_user.dart';
import 'package:dab_api/src/application/usecases/auth/register_user.dart';
import 'package:dab_api/src/application/usecases/auth/authenticate_user.dart';
import 'package:dab_api/src/application/usecases/auth/register_new_user.dart';
import 'package:dab_api/src/application/usecases/auth/refresh_token.dart';
import 'package:dab_api/src/application/usecases/auth/logout_user.dart';

import 'package:dab_api/src/application/usecases/user/sync_phorge_users.dart';
import 'package:dab_api/src/application/usecases/user/get_users.dart';
import 'package:dab_api/src/application/usecases/user/get_user_by_id.dart';
import 'package:dab_api/src/application/usecases/user/get_users_by_group.dart';

import 'package:dab_api/src/application/usecases/group/get_groups.dart';
import 'package:dab_api/src/application/usecases/group/save_group.dart';
import 'package:dab_api/src/application/usecases/group/delete_group.dart';

import 'package:dab_api/src/application/usecases/metadata/get_provider_metadata.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_configs.dart';

import 'package:dab_api/src/application/usecases/health/check_database_health.dart';

// containers
import 'package:dab_api/src/application/containers/auth_usecases.dart';
import 'package:dab_api/src/application/containers/activity_usecases.dart';
import 'package:dab_api/src/application/containers/user_usecases.dart';
import 'package:dab_api/src/application/containers/group_usecases.dart';
import 'package:dab_api/src/application/containers/metadata_usecases.dart';
import 'package:dab_api/src/application/containers/health_usecases.dart';

// infrastructure
import 'package:dab_api/src/infrastructure/config/config.dart';
import 'package:dab_api/src/infrastructure/connectors/phorge/phorge_client.dart';
import 'package:dab_api/src/infrastructure/database/app_database.dart';
import 'package:dab_api/src/infrastructure/database/postgres_client.dart';
import 'package:dab_api/src/infrastructure/database/postgres_health_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_client.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/repositories/activity_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/auth_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_metadata_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/user_repository.dart';
import 'package:dab_api/src/infrastructure/security/jwt_provider.dart';
import 'package:dab_api/src/infrastructure/websockets/presence_service.dart';
import 'package:dab_api/src/infrastructure/logging/logging_service.dart';
import 'package:dab_api/src/infrastructure/notifications/push_notification_service.dart';

// Activity Architecture
import 'package:dab_api/src/domain/services/phorge_sprint_service.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_task_mapper.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_revision_mapper.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_user_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';

import 'package:dab_api/src/domain/mappers/slack/slack_message_mapper.dart';
import 'package:dab_api/src/infrastructure/sources/slack/slack_message_source.dart';
import 'package:dab_api/src/domain/mappers/teams/teams_message_mapper.dart';
import 'package:dab_api/src/infrastructure/sources/teams/teams_message_source.dart';
import 'package:dab_api/src/domain/mappers/jira/jira_issue_mapper.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_issue_source.dart';
import 'package:dab_api/src/domain/mappers/linear/linear_issue_mapper.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_issue_source.dart';
import 'package:dab_api/src/domain/mappers/discord/discord_message_mapper.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_message_source.dart';

import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';

final GetIt sl = GetIt.instance;

Future<void> serviceLocator() async {
  // 1. Infrastructure Core
  final pgClient = PostgresClient();
  final db = pgClient.db;
  sl.registerSingleton<PostgresClient>(pgClient);
  sl.registerSingleton<AppDatabase>(db);

  final config = Config();
  sl.registerSingleton<Config>(config);

  final redisClient = RedisClient(
    host: config.redisHost,
    port: config.redisPort,
  );
  await redisClient.connect();
  sl.registerSingleton<RedisClient>(redisClient);
  sl.registerSingleton<RedisService>(RedisService(redisClient));

  // clients
  final phorgeClient = PhorgeClient();
  sl.registerSingleton<PhorgeClient>(phorgeClient);
  sl.registerSingleton<JwtProvider>(JwtProvider());

  // -----------------------------------------------------
  // 2. Activity Architecture (Domain & Infrastructure)
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Activity System Initialization.
  // CONTRACT: Registers all ConnectorPairs (Source + Mapper) into the Registry.
  // -----------------------------------------------------

  // Domain Services & Mappers
  final phorgeSprintService = PhorgeSprintService();
  sl.registerSingleton<PhorgeSprintService>(phorgeSprintService);
  
  final phorgeTaskMapper = PhorgeTaskMapper();
  final phorgeRevisionMapper = PhorgeRevisionMapper();
  
  // Infrastructure Sources (Raw I/O)
  final phorgeTaskSource = PhorgeTaskSource(phorgeClient, phorgeSprintService);
  final phorgeRevisionSource = PhorgeRevisionSource(phorgeClient);
  final phorgeUserSource = PhorgeUserSource(phorgeClient);
  final phorgeProjectSource = PhorgeProjectSource(phorgeClient, phorgeSprintService);

  // New Scaffolds (Slack, Teams, Jira, Linear, Discord)
  final slackMapper = SlackMessageMapper();
  final slackSource = SlackMessageSource();
  final teamsMapper = TeamsMessageMapper();
  final teamsSource = TeamsMessageSource();
  final jiraMapper = JiraIssueMapper();
  final jiraSource = JiraIssueSource();
  final linearMapper = LinearIssueMapper();
  final linearSource = LinearIssueSource();
  final discordMapper = DiscordMessageMapper();
  final discordSource = DiscordMessageSource();

  sl.registerSingleton<PhorgeUserSource>(phorgeUserSource);
  sl.registerSingleton<PhorgeProjectSource>(phorgeProjectSource);

  // Application Orchestration: Mapping Sources to Mappers
  final registry = ConnectorRegistry();
  registry.register(phorgeTaskSource, phorgeTaskMapper);
  registry.register(phorgeRevisionSource, phorgeRevisionMapper);
  
  // Registering new scaffolds
  registry.register(slackSource, slackMapper);
  registry.register(teamsSource, teamsMapper);
  registry.register(jiraSource, jiraMapper);
  registry.register(linearSource, linearMapper);
  registry.register(discordSource, discordMapper);

  sl.registerSingleton<ConnectorRegistry>(registry);

  final fetcher = UnifiedActivityFetcher(registry);
  sl.registerSingleton<UnifiedActivityFetcher>(fetcher);

  // -----------------------------------------------------
  // 3. System Services
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Cross-cutting system utilities.
  // -----------------------------------------------------
  sl.registerSingleton<PresenceService>(PresenceService());
  sl.registerSingleton<LoggingService>(LoggingService());
  sl.registerSingleton<PushNotificationService>(PushNotificationService());

  // Repositories
  sl.registerSingleton<AbsIAuthRepository>(AuthRepository(db));
  sl.registerSingleton<AbsIActivityRepository>(ActivityRepository(db));
  sl.registerSingleton<IUserRepository>(UserRepository(db));
  sl.registerSingleton<AbsIHealthRepository>(PostgresHealthRepository(sl<PostgresClient>()));
  sl.registerSingleton<AbsIProviderMetadataRepository>(
    ProviderMetadataRepository(projectSource: sl<PhorgeProjectSource>()),
  );
  sl.registerSingleton<AbsIProviderConfigRepository>(
    ProviderConfigRepository(config: sl<Config>()),
  );

  // -----------------------------------------------------
  // 4. USECASES
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Encapsulates high-level business flows.
  // CONTRACT: Injects required Repositories and Services into UseCase instances.
  // -----------------------------------------------------
  
  // Auth
  sl.registerSingleton<LoginUser>(LoginUser(sl<AbsIAuthRepository>()));
  sl.registerSingleton<RegisterUser>(RegisterUser(sl<AbsIAuthRepository>(), sl<PhorgeUserSource>()));
  sl.registerSingleton<AuthenticateUser>(AuthenticateUser(sl<AbsIAuthRepository>(), sl<LoginUser>(), sl<JwtProvider>()));
  sl.registerSingleton<RegisterNewUser>(RegisterNewUser(sl<AbsIAuthRepository>(), sl<RegisterUser>(), sl<JwtProvider>()));
  sl.registerSingleton<RefreshToken>(RefreshToken(sl<AbsIAuthRepository>(), sl<JwtProvider>()));
  sl.registerSingleton<LogoutUser>(LogoutUser(sl<AbsIAuthRepository>()));

  // Activity
  sl.registerSingleton<FetchRemoteActivities>(FetchRemoteActivities(sl<UnifiedActivityFetcher>()));
  sl.registerSingleton<GetRecentActivities>(GetRecentActivities(sl<AbsIActivityRepository>()));
  sl.registerSingleton<SearchActivities>(SearchActivities(sl<AbsIAuthRepository>(), sl<FetchRemoteActivities>()));
  sl.registerSingleton<LogActivity>(LogActivity(sl<AbsIActivityRepository>(), sl<AbsIAuthRepository>(), sl<PresenceService>(), sl<RedisService>()));

  // User
  sl.registerSingleton<SyncPhorgeUsers>(SyncPhorgeUsers(sl<IUserRepository>(), sl<PhorgeUserSource>()));
  sl.registerSingleton<GetUsers>(GetUsers(sl<IUserRepository>()));
  sl.registerSingleton<GetUserById>(GetUserById(sl<IUserRepository>()));
  sl.registerSingleton<GetUsersByGroup>(GetUsersByGroup(sl<IUserRepository>()));

  // Group
  sl.registerSingleton<GetGroups>(GetGroups(sl<IUserRepository>()));
  sl.registerSingleton<SaveGroup>(SaveGroup(sl<IUserRepository>()));
  sl.registerSingleton<DeleteGroup>(DeleteGroup(sl<IUserRepository>()));

  // Metadata
  sl.registerSingleton<GetProviderMetadata>(GetProviderMetadata(sl<AbsIProviderMetadataRepository>()));
  sl.registerSingleton<GetProviderConfigs>(GetProviderConfigs(sl<AbsIProviderConfigRepository>()));

  // Health
  sl.registerSingleton<CheckDatabaseHealth>(CheckDatabaseHealth(sl<AbsIHealthRepository>()));

  // -----------------------------------------------------
  // 5. CONTAINERS
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Aggregates related UseCases for clean injection into Controllers.
  // -----------------------------------------------------

  sl.registerSingleton<AuthUseCases>(AuthUseCases(
    authenticateUser: sl<AuthenticateUser>(),
    loginUser: sl<LoginUser>(),
    logoutUser: sl<LogoutUser>(),
    refreshToken: sl<RefreshToken>(),
    registerNewUser: sl<RegisterNewUser>(),
    registerUser: sl<RegisterUser>(),
  ));

  sl.registerSingleton<ActivityUseCases>(ActivityUseCases(
    fetchRemoteActivities: sl<FetchRemoteActivities>(),
    getRecentActivities: sl<GetRecentActivities>(),
    logActivity: sl<LogActivity>(),
    searchActivities: sl<SearchActivities>(),
  ));

  sl.registerSingleton<UserUseCases>(UserUseCases(
    getUserById: sl<GetUserById>(),
    getUsers: sl<GetUsers>(),
    getUsersByGroup: sl<GetUsersByGroup>(),
    syncPhorgeUsers: sl<SyncPhorgeUsers>(),
  ));

  sl.registerSingleton<GroupUseCases>(GroupUseCases(
    deleteGroup: sl<DeleteGroup>(),
    getGroups: sl<GetGroups>(),
    saveGroup: sl<SaveGroup>(),
  ));

  sl.registerSingleton<MetadataUseCases>(MetadataUseCases(
    getProviderConfigs: sl<GetProviderConfigs>(),
    getProviderMetadata: sl<GetProviderMetadata>(),
  ));

  sl.registerSingleton<HealthUseCases>(HealthUseCases(
    checkDatabaseHealth: sl<CheckDatabaseHealth>(),
  ));
}
