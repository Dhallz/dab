import 'package:dab_api/src/application/containers/activity_usecases.dart';
// containers
import 'package:dab_api/src/application/containers/auth_usecases.dart';
import 'package:dab_api/src/application/containers/group_usecases.dart';
import 'package:dab_api/src/application/containers/health_usecases.dart';
import 'package:dab_api/src/application/containers/metadata_usecases.dart';
import 'package:dab_api/src/application/containers/user_usecases.dart';
import 'package:dab_api/src/application/services/activity_purge_scheduler.dart';
import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/application/services/identity_discovery_service.dart';
import 'package:dab_api/src/application/services/provider_capability_catalog.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
// application / usecases
import 'package:dab_api/src/application/usecases/activity/archive_live_activity.dart';
import 'package:dab_api/src/application/usecases/activity/fetch_remote_activities.dart';
import 'package:dab_api/src/application/usecases/activity/get_live_activities.dart';
import 'package:dab_api/src/application/usecases/activity/get_recent_activities.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_github_webhook.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_slack_event.dart';
import 'package:dab_api/src/application/usecases/activity/log_activity.dart';
import 'package:dab_api/src/application/usecases/activity/search_activities.dart';
import 'package:dab_api/src/application/usecases/activity/unarchive_live_activity.dart';
import 'package:dab_api/src/application/usecases/auth/authenticate_user.dart';
import 'package:dab_api/src/application/usecases/auth/find_all_users.dart';
import 'package:dab_api/src/application/usecases/auth/count_unresolved_identities.dart';
import 'package:dab_api/src/application/usecases/auth/get_all_identities.dart';
import 'package:dab_api/src/application/usecases/auth/link_user_identity.dart';
import 'package:dab_api/src/application/usecases/auth/login_user.dart';
import 'package:dab_api/src/application/usecases/auth/logout_user.dart';
import 'package:dab_api/src/application/usecases/auth/refresh_token.dart';
import 'package:dab_api/src/application/usecases/auth/register_new_user.dart';
import 'package:dab_api/src/application/usecases/auth/register_user.dart';
import 'package:dab_api/src/application/usecases/auth/resolve_user_identity.dart';
import 'package:dab_api/src/application/usecases/auth/update_user_role.dart';
import 'package:dab_api/src/application/usecases/group/delete_group.dart';
import 'package:dab_api/src/application/usecases/group/get_groups.dart';
import 'package:dab_api/src/application/usecases/group/save_group.dart';
import 'package:dab_api/src/application/usecases/health/check_database_health.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_configs.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_capabilities.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_metadata.dart';
import 'package:dab_api/src/application/usecases/metadata/get_system_status.dart';
import 'package:dab_api/src/application/usecases/metadata/save_provider_config.dart';
import 'package:dab_api/src/application/usecases/user/get_user_by_id.dart';
import 'package:dab_api/src/application/usecases/user/get_users.dart';
import 'package:dab_api/src/application/usecases/user/get_users_by_group.dart';
import 'package:dab_api/src/application/usecases/user/sync_phorge_users.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/mappers/discord/discord_message_mapper.dart';
import 'package:dab_api/src/domain/mappers/github/github_commit_mapper.dart';
import 'package:dab_api/src/domain/mappers/jira/jira_issue_mapper.dart';
import 'package:dab_api/src/domain/mappers/linear/linear_issue_mapper.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_revision_mapper.dart';
import 'package:dab_api/src/domain/mappers/phorge/phorge_task_mapper.dart';
import 'package:dab_api/src/domain/mappers/slack/slack_message_mapper.dart';
import 'package:dab_api/src/domain/mappers/teams/teams_message_mapper.dart';
// domain
import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_health_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_provider_metadata_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_user_repository.dart';
// Activity Architecture
import 'package:dab_api/src/domain/services/phorge_sprint_service.dart';
// infrastructure
import 'package:dab_api/src/infrastructure/config/config.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/http_conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/http_json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/http_graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/http_slack_web_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/slack_web_protocol.dart';
import 'package:dab_api/src/infrastructure/database/app_database.dart';
import 'package:dab_api/src/infrastructure/database/postgres_client.dart';
import 'package:dab_api/src/infrastructure/database/postgres_health_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_client.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/logging/logging_service.dart';
import 'package:dab_api/src/infrastructure/notifications/push_notification_service.dart';
import 'package:dab_api/src/infrastructure/repositories/activity_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/auth_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/provider_metadata_repository.dart';
import 'package:dab_api/src/infrastructure/repositories/user_repository.dart';
import 'package:dab_api/src/infrastructure/security/jwt_provider.dart';
import 'package:dab_api/src/infrastructure/security/github_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/security/slack_request_verifier.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_message_source.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_user_source.dart';
import 'package:dab_api/src/infrastructure/sources/slack/slack_message_source.dart';
import 'package:dab_api/src/infrastructure/sources/teams/teams_message_source.dart';
import 'package:dab_api/src/infrastructure/websockets/presence_service.dart';
import 'package:get_it/get_it.dart';

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
  final conduitProtocol = HttpConduitProtocol();
  sl.registerSingleton<ConduitProtocol>(conduitProtocol);

  final jsonRestProtocol = HttpJsonRestProtocol();
  sl.registerSingleton<JsonRestProtocol>(jsonRestProtocol);

  final slackWebProtocol = HttpSlackWebProtocol();
  sl.registerSingleton<SlackWebProtocol>(slackWebProtocol);

  final graphqlProtocol = HttpGraphqlProtocol();
  sl.registerSingleton<GraphqlProtocol>(graphqlProtocol);
  sl.registerSingleton<JwtProvider>(JwtProvider());
  sl.registerSingleton<SlackRequestVerifier>(SlackRequestVerifier());
  sl.registerSingleton<GitHubWebhookVerifier>(GitHubWebhookVerifier());

  // -----------------------------------------------------
  // 2. Activity Architecture (Domain & Infrastructure)
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Activity System Initialization.
  // CONTRACT: Registers all ConnectorPairs (Source + Mapper) into the Registry.
  // -----------------------------------------------------

  // Domain Services & Mappers
  final phorgeSprintService = PhorgeSprintService();
  sl.registerSingleton<PhorgeSprintService>(phorgeSprintService);
  final userRepository = UserRepository(db);
  final providerConfigRepository = ProviderConfigRepository(db);

  final phorgeTaskMapper = PhorgeTaskMapper();
  final phorgeRevisionMapper = PhorgeRevisionMapper();

  // Infrastructure Sources (Raw I/O)
  final phorgeTaskSource = PhorgeTaskSource(conduitProtocol, phorgeSprintService);
  final phorgeRevisionSource = PhorgeRevisionSource(conduitProtocol);
  final phorgeUserSource = PhorgeUserSource(conduitProtocol);
  final phorgeProjectSource = PhorgeProjectSource(
    conduitProtocol,
    phorgeSprintService,
  );

  // New Scaffolds (Slack, Teams, Jira, Linear, Discord)
  final slackMapper = SlackMessageMapper();
  final slackSource = SlackMessageSource(
    providerConfigRepository,
    userRepository,
    slackWebProtocol,
  );
  final teamsMapper = TeamsMessageMapper();
  final teamsSource = TeamsMessageSource();
  final jiraMapper = JiraIssueMapper();
  final jiraSource = JiraIssueSource();
  final linearMapper = LinearIssueMapper();
  final linearSource = LinearIssueSource(graphqlProtocol);
  final discordMapper = DiscordMessageMapper();
  final discordSource = DiscordMessageSource();
  final githubCommitMapper = GitHubCommitMapper();
  final githubSource = GitHubCommitSource(
    providerConfigRepository,
    userRepository,
    jsonRestProtocol,
  );

  sl.registerSingleton<PhorgeUserSource>(phorgeUserSource);
  sl.registerSingleton<PhorgeProjectSource>(phorgeProjectSource);
  sl.registerSingleton<SlackMessageSource>(slackSource);
  sl.registerSingleton<TeamsMessageSource>(teamsSource);
  sl.registerSingleton<JiraIssueSource>(jiraSource);
  sl.registerSingleton<LinearIssueSource>(linearSource);
  sl.registerSingleton<GitHubCommitSource>(githubSource);

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
  registry.register(githubSource, githubCommitMapper);

  sl.registerSingleton<ConnectorRegistry>(registry);
  sl.registerSingleton<GitHubCommitMapper>(githubCommitMapper);

  // Repositories
  sl.registerSingleton<AbsIAuthRepository>(AuthRepository(db));
  sl.registerSingleton<AbsIActivityRepository>(ActivityRepository(db));
  sl.registerSingleton<IUserRepository>(userRepository);
  sl.registerSingleton<AbsIHealthRepository>(
    PostgresHealthRepository(sl<PostgresClient>()),
  );
  sl.registerSingleton<AbsIProviderMetadataRepository>(
    ProviderMetadataRepository(projectSource: sl<PhorgeProjectSource>()),
  );
  sl.registerSingleton<AbsIProviderConfigRepository>(providerConfigRepository);

  // -----------------------------------------------------
  // 3. System Services
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Cross-cutting system utilities.
  // -----------------------------------------------------
  sl.registerSingleton<PresenceService>(PresenceService());
  sl.registerSingleton<LoggingService>(LoggingService());
  sl.registerSingleton<PushNotificationService>(PushNotificationService());
  sl.registerSingleton<ProviderCapabilityCatalog>(ProviderCapabilityCatalog());

  final fetcher = UnifiedActivityFetcher(
    registry,
    sl<AbsIProviderConfigRepository>(),
    sl<IUserRepository>(),
    sl<LoggingService>().record,
  );
  sl.registerSingleton<UnifiedActivityFetcher>(fetcher);

  sl.registerSingleton<IdentityDiscoveryService>(
    IdentityDiscoveryService(
      sl<IUserRepository>(),
      sl<AbsIProviderConfigRepository>(),
      {
        'phorge': sl<PhorgeUserSource>(),
        'slack': sl<SlackMessageSource>(),
        'teams': sl<TeamsMessageSource>(),
        'jira': sl<JiraIssueSource>(),
        'linear': sl<LinearIssueSource>(),
      },
    ),
  );

  // -----------------------------------------------------
  // 4. USECASES
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Encapsulates high-level business flows.
  // CONTRACT: Injects required Repositories and Services into UseCase instances.
  // -----------------------------------------------------

  // Auth
  sl.registerSingleton<LoginUser>(LoginUser(sl<AbsIAuthRepository>()));
  sl.registerSingleton<RegisterUser>(
    RegisterUser(
      sl<AbsIAuthRepository>(),
      sl<IUserRepository>(),
      sl<PhorgeUserSource>(),
    ),
  );
  sl.registerSingleton<AuthenticateUser>(
    AuthenticateUser(
      sl<AbsIAuthRepository>(),
      sl<LoginUser>(),
      sl<JwtProvider>(),
    ),
  );
  sl.registerSingleton<RegisterNewUser>(
    RegisterNewUser(
      sl<AbsIAuthRepository>(),
      sl<RegisterUser>(),
      sl<JwtProvider>(),
    ),
  );
  sl.registerSingleton<LinkUserIdentity>(
    LinkUserIdentity(sl<IUserRepository>()),
  );
  sl.registerSingleton<RefreshToken>(
    RefreshToken(sl<AbsIAuthRepository>(), sl<JwtProvider>()),
  );
  sl.registerSingleton<LogoutUser>(LogoutUser(sl<AbsIAuthRepository>()));
  sl.registerSingleton<GetAllIdentities>(
    GetAllIdentities(sl<IUserRepository>(), sl<AbsIAuthRepository>()),
  );
  sl.registerSingleton<CountUnresolvedIdentities>(
    CountUnresolvedIdentities(sl<GetAllIdentities>()),
  );
  sl.registerSingleton<FindAllUsers>(FindAllUsers(sl<AbsIAuthRepository>()));
  sl.registerSingleton<UpdateUserRole>(
    UpdateUserRole(sl<AbsIAuthRepository>()),
  );
  sl.registerSingleton<ResolveUserIdentity>(
    ResolveUserIdentity(sl<IUserRepository>()),
  );

  // Activity
  sl.registerSingleton<FetchRemoteActivities>(
    FetchRemoteActivities(sl<UnifiedActivityFetcher>()),
  );
  sl.registerSingleton<GetRecentActivities>(
    GetRecentActivities(sl<AbsIActivityRepository>()),
  );
  sl.registerSingleton<GetLiveActivities>(
    GetLiveActivities(sl<RedisService>()),
  );
  sl.registerSingleton<SearchActivities>(
    SearchActivities(sl<AbsIAuthRepository>(), sl<FetchRemoteActivities>()),
  );
  sl.registerSingleton<IngestGitHubWebhook>(
    IngestGitHubWebhook(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<RedisService>(),
      sl<PresenceService>(),
      sl<GitHubCommitMapper>(),
    ),
  );
  sl.registerSingleton<IngestSlackEvent>(
    IngestSlackEvent(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<RedisService>(),
      sl<PresenceService>(),
    ),
  );
  sl.registerSingleton<LogActivity>(
    LogActivity(
      sl<AbsIActivityRepository>(),
      sl<AbsIAuthRepository>(),
      sl<PresenceService>(),
      sl<RedisService>(),
    ),
  );
  sl.registerSingleton<ArchiveLiveActivity>(
    ArchiveLiveActivity(sl<RedisService>(), sl<PresenceService>()),
  );
  sl.registerSingleton<UnarchiveLiveActivity>(
    UnarchiveLiveActivity(sl<RedisService>(), sl<PresenceService>()),
  );
  sl.registerSingleton<ActivityPurgeScheduler>(
    ActivityPurgeScheduler(sl<RedisService>()),
  );

  // User
  sl.registerLazySingleton<SyncPhorgeUsers>(
    () => SyncPhorgeUsers(
      sl<IUserRepository>(),
      sl<PhorgeUserSource>(),
      sl<AbsIProviderConfigRepository>(),
    ),
  );
  sl.registerSingleton<GetUsers>(GetUsers(sl<IUserRepository>()));
  sl.registerSingleton<GetUserById>(GetUserById(sl<IUserRepository>()));
  sl.registerSingleton<GetUsersByGroup>(GetUsersByGroup(sl<IUserRepository>()));

  // Group
  sl.registerSingleton<GetGroups>(GetGroups(sl<IUserRepository>()));
  sl.registerSingleton<SaveGroup>(SaveGroup(sl<IUserRepository>()));
  sl.registerSingleton<DeleteGroup>(DeleteGroup(sl<IUserRepository>()));

  // Metadata
  sl.registerSingleton<GetProviderMetadata>(
    GetProviderMetadata(
      sl<AbsIProviderMetadataRepository>(),
      sl<AbsIProviderConfigRepository>(),
    ),
  );
  sl.registerSingleton<GetProviderConfigs>(
    GetProviderConfigs(sl<AbsIProviderConfigRepository>()),
  );
  sl.registerSingleton<GetProviderCapabilities>(
    GetProviderCapabilities(
      sl<AbsIProviderConfigRepository>(),
      sl<ProviderCapabilityCatalog>(),
    ),
  );
  sl.registerSingleton<SaveProviderConfig>(
    SaveProviderConfig(sl<AbsIProviderConfigRepository>()),
  );
  sl.registerSingleton<GetSystemStatus>(
    GetSystemStatus(
      sl<AbsIAuthRepository>(),
      sl<AbsIProviderConfigRepository>(),
    ),
  );

  // Health
  sl.registerSingleton<CheckDatabaseHealth>(
    CheckDatabaseHealth(sl<AbsIHealthRepository>()),
  );

  // -----------------------------------------------------
  // 5. CONTAINERS
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Aggregates related UseCases for clean injection into Controllers.
  // -----------------------------------------------------

  sl.registerSingleton<AuthUseCases>(
    AuthUseCases(
      authenticateUser: sl<AuthenticateUser>(),
      loginUser: sl<LoginUser>(),
      logoutUser: sl<LogoutUser>(),
      refreshToken: sl<RefreshToken>(),
      registerNewUser: sl<RegisterNewUser>(),
      registerUser: sl<RegisterUser>(),
      linkUserIdentity: sl<LinkUserIdentity>(),
      getAllIdentities: sl<GetAllIdentities>(),
      countUnresolvedIdentities: sl<CountUnresolvedIdentities>(),
      findAllUsers: sl<FindAllUsers>(),
      updateUserRole: sl<UpdateUserRole>(),
      resolveUserIdentity: sl<ResolveUserIdentity>(),
    ),
  );

  sl.registerSingleton<ActivityUseCases>(
    ActivityUseCases(
      archiveLiveActivity: sl<ArchiveLiveActivity>(),
      fetchRemoteActivities: sl<FetchRemoteActivities>(),
      getLiveActivities: sl<GetLiveActivities>(),
      getRecentActivities: sl<GetRecentActivities>(),
      ingestGitHubWebhook: sl<IngestGitHubWebhook>(),
      ingestSlackEvent: sl<IngestSlackEvent>(),
      logActivity: sl<LogActivity>(),
      searchActivities: sl<SearchActivities>(),
      unarchiveLiveActivity: sl<UnarchiveLiveActivity>(),
    ),
  );

  sl.registerSingleton<UserUseCases>(
    UserUseCases(
      getUserById: sl<GetUserById>(),
      getUsers: sl<GetUsers>(),
      getUsersByGroup: sl<GetUsersByGroup>(),
      syncPhorgeUsers: sl<SyncPhorgeUsers>(),
    ),
  );

  sl.registerSingleton<GroupUseCases>(
    GroupUseCases(
      deleteGroup: sl<DeleteGroup>(),
      getGroups: sl<GetGroups>(),
      saveGroup: sl<SaveGroup>(),
    ),
  );

  sl.registerSingleton<MetadataUseCases>(
    MetadataUseCases(
      getProviderConfigs: sl<GetProviderConfigs>(),
      getProviderCapabilities: sl<GetProviderCapabilities>(),
      getProviderMetadata: sl<GetProviderMetadata>(),
      getSystemStatus: sl<GetSystemStatus>(),
      saveProviderConfig: sl<SaveProviderConfig>(),
    ),
  );

  sl.registerSingleton<HealthUseCases>(
    HealthUseCases(checkDatabaseHealth: sl<CheckDatabaseHealth>()),
  );

  // 6. Seed Data
  await _seedProviders();
}

Future<void> _seedProviders() async {
  final repo = sl<AbsIProviderConfigRepository>();
  final result = await repo.getConfigs();

  await result.fold((l) async => print('❌ Error checking providers: $l'), (
    configs,
  ) async {
    if (configs.isEmpty) {
      print('🌱 Seeding default provider configurations...');
      final defaultProviders = [
        (
          'phorge',
          'Phorge',
          'https://phorge.example.com',
          'https://phorge.it/favicon.ico',
        ),
        (
          'linear',
          'Linear',
          'https://linear.app',
          'https://linear.app/favicon.ico',
        ),
        (
          'jira',
          'Jira',
          'https://atlassian.net',
          'https://wac-cdn.atlassian.com/assets/img/favicons/atlassian/favicon.png',
        ),
        (
          'teams',
          'Microsoft Teams',
          'https://teams.microsoft.com',
          'https://statics.teams.cdn.office.net/evergreen-assets/icons/favicon.ico',
        ),
        (
          'slack',
          'Slack',
          'https://slack.com',
          'https://a.slack-edge.com/80588/img/favicon-32.png',
        ),
        (
          'discord',
          'Discord',
          'https://discord.com',
          'https://discord.com/favicon.ico',
        ),
        (
          'github',
          'GitHub',
          'https://github.com',
          'https://github.githubassets.com/favicons/favicon.svg',
        ),
        (
          'gitlab',
          'GitLab',
          'https://gitlab.com',
          'https://gitlab.com/favicon.ico',
        ),
      ];

      for (final p in defaultProviders) {
        await repo.saveConfig(
          ProviderConfig(
            id: p.$1,
            name: p.$2,
            baseUrl: p.$3,
            isActive: true,
            iconUrl: p.$4,
            settings: {},
          ),
        );
      }
      print('✅ Seeding complete.');
    }
  });
}
