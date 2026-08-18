import 'package:dab_api/src/application/containers/activity_usecases.dart';
// containers
import 'package:dab_api/src/application/containers/auth_usecases.dart';
import 'package:dab_api/src/application/containers/group_usecases.dart';
import 'package:dab_api/src/application/containers/health_usecases.dart';
import 'package:dab_api/src/application/containers/metadata_usecases.dart';
import 'package:dab_api/src/application/containers/user_usecases.dart';
import 'package:dab_api/src/application/services/activity_live_poll_scheduler.dart';
import 'package:dab_api/src/application/services/activity_live_publisher.dart';
import 'package:dab_api/src/application/services/activity_purge_scheduler.dart';
import 'package:dab_api/src/application/services/connector_registry.dart';
import 'package:dab_api/src/application/services/identity_discovery_service.dart';
import 'package:dab_api/src/application/services/live_ingest_persister.dart';
import 'package:dab_api/src/application/services/provider_capability_catalog.dart';
import 'package:dab_api/src/application/services/provider_config_connectivity_service.dart';
import 'package:dab_api/src/application/services/provider_live_connectivity_checker.dart';
import 'package:dab_api/src/application/services/provider_live_webhook_test_service.dart';
import 'package:dab_api/src/application/services/register_activity_connectors.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
// application / usecases
import 'package:dab_api/src/application/usecases/activity/archive_live_activity.dart';
import 'package:dab_api/src/application/usecases/activity/fetch_remote_activities.dart';
import 'package:dab_api/src/application/usecases/activity/get_live_activities.dart';
import 'package:dab_api/src/application/usecases/activity/get_recent_activities.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_github_webhook.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_bitbucket_webhook.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_discord_message.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_gitlab_webhook.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_jira_webhook.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_linear_webhook.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_phorge_webhook.dart';
import 'package:dab_api/src/application/usecases/activity/ingest_slack_event.dart';
import 'package:dab_api/src/application/usecases/activity/log_activity.dart';
import 'package:dab_api/src/application/usecases/activity/search_activities.dart';
import 'package:dab_api/src/application/usecases/activity/unarchive_live_activity.dart';
import 'package:dab_api/src/application/usecases/auth/authenticate_user.dart';
import 'package:dab_api/src/application/usecases/auth/count_unresolved_identities.dart';
import 'package:dab_api/src/application/usecases/auth/create_user_by_admin.dart';
import 'package:dab_api/src/application/usecases/auth/find_all_users.dart';
import 'package:dab_api/src/application/usecases/auth/get_all_identities.dart';
import 'package:dab_api/src/application/usecases/auth/link_user_identity.dart';
import 'package:dab_api/src/application/usecases/auth/login_user.dart';
import 'package:dab_api/src/application/usecases/auth/logout_user.dart';
import 'package:dab_api/src/application/usecases/auth/refresh_token.dart';
import 'package:dab_api/src/application/usecases/auth/register_new_user.dart';
import 'package:dab_api/src/application/usecases/auth/register_user.dart';
import 'package:dab_api/src/application/usecases/auth/delete_user_identity.dart';
import 'package:dab_api/src/application/usecases/auth/resolve_user_identity.dart';
import 'package:dab_api/src/application/usecases/auth/update_user_role.dart';
import 'package:dab_api/src/application/usecases/group/delete_group.dart';
import 'package:dab_api/src/application/usecases/group/get_groups.dart';
import 'package:dab_api/src/application/usecases/group/save_group.dart';
import 'package:dab_api/src/application/usecases/health/check_database_health.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_capabilities.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_configs.dart';
import 'package:dab_api/src/application/usecases/metadata/get_provider_metadata.dart';
import 'package:dab_api/src/application/usecases/metadata/get_system_status.dart';
import 'package:dab_api/src/application/usecases/metadata/save_provider_config.dart';
import 'package:dab_api/src/application/usecases/metadata/test_provider_config.dart';
import 'package:dab_api/src/application/usecases/user/complete_provider_oauth.dart';
import 'package:dab_api/src/application/usecases/user/delete_user_provider_credential.dart';
import 'package:dab_api/src/application/usecases/user/get_git_branch_list.dart';
import 'package:dab_api/src/application/usecases/user/get_git_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/list_follow_candidates.dart';
import 'package:dab_api/src/application/usecases/user/list_my_activity_follows.dart';
import 'package:dab_api/src/application/usecases/user/save_activity_follow.dart';
import 'package:dab_api/src/application/usecases/user/delete_activity_follow.dart';
import 'package:dab_api/src/application/usecases/user/get_jira_project_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/get_linear_team_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/get_user_by_id.dart';
import 'package:dab_api/src/application/usecases/user/get_users.dart';
import 'package:dab_api/src/application/usecases/user/get_users_by_group.dart';
import 'package:dab_api/src/application/usecases/user/list_user_provider_credentials.dart';
import 'package:dab_api/src/application/usecases/user/save_git_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/save_jira_project_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/save_linear_team_watch_list.dart';
import 'package:dab_api/src/application/usecases/user/save_user_provider_credential.dart';
import 'package:dab_api/src/application/usecases/user/start_provider_oauth.dart';
import 'package:dab_api/src/application/usecases/user/sync_phorge_users.dart';
import 'package:dab_api/src/application/usecases/user/test_user_provider_credential.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_phorge_gateway.dart';
import 'package:dab_api/src/domain/contracts/ports/i_access_token_issuer.dart';
import 'package:dab_api/src/domain/contracts/ports/i_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/i_discord_live_ingestor.dart';
import 'package:dab_api/src/domain/contracts/ports/i_live_feed_store.dart';
import 'package:dab_api/src/domain/contracts/ports/i_phorge_task_hydrator.dart';
import 'package:dab_api/src/domain/contracts/ports/i_presence_broadcaster.dart';
import 'package:dab_api/src/domain/contracts/ports/i_provider_identity_probe.dart';
import 'package:dab_api/src/domain/core/phorge_scope.dart';
import 'package:dab_api/src/domain/contracts/ports/i_bitbucket_branch_catalog.dart';
import 'package:dab_api/src/domain/contracts/ports/i_github_branch_catalog.dart';
import 'package:dab_api/src/domain/contracts/ports/i_gitlab_branch_catalog.dart';
import 'package:dab_api/src/domain/contracts/ports/i_jira_project_catalog.dart';
import 'package:dab_api/src/domain/contracts/ports/i_linear_team_catalog.dart';
import 'package:dab_api/src/domain/contracts/ports/i_oauth_client_credential_resolver.dart';
import 'package:dab_api/src/domain/contracts/ports/i_oauth_credential_refresher.dart';
import 'package:dab_api/src/domain/contracts/ports/i_oauth_pkce.dart';
import 'package:dab_api/src/domain/contracts/ports/i_oauth_state_store.dart';
import 'package:dab_api/src/domain/contracts/ports/i_oauth_token_client.dart';
import 'package:dab_api/src/domain/contracts/ports/i_webhook_request_authenticator.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_provider_credential_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_follow_repository.dart';
// domain
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_health_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_metadata_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_system_settings_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/system_settings_repository.dart';
import 'package:dab_api/src/application/usecases/metadata/get_system_settings.dart';
import 'package:dab_api/src/application/usecases/metadata/save_system_settings.dart';
// Activity Architecture
// infrastructure
import 'package:dab_api/src/infrastructure/core/config/config.dart';
import 'package:dab_api/src/infrastructure/core/security/github_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/jwt_provider.dart';
import 'package:dab_api/src/infrastructure/core/security/linear_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/phorge_webhook_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/oauth_pkce.dart';
import 'package:dab_api/src/infrastructure/core/security/settings_cipher.dart';
import 'package:dab_api/src/infrastructure/core/security/shared_secret_verifier.dart';
import 'package:dab_api/src/infrastructure/core/security/slack_request_verifier.dart';
import 'package:dab_api/src/infrastructure/persistence/postgres/app_database.dart';
import 'package:dab_api/src/infrastructure/persistence/postgres/postgres_client.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/postgres_health_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_client.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
import 'package:dab_api/src/infrastructure/core/logging/logging_service.dart';
import 'package:dab_api/src/infrastructure/core/logging/push_notification_service.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/conduit/http_conduit_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/graphql/http_graphql_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/http_json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/http_slack_web_protocol.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/slack_web_protocol.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/activity_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/auth_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/provider_config_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/provider_metadata_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/user_provider_credential_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/activity_follow_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/repositories/user_repository.dart';
import 'package:dab_api/src/infrastructure/core/adapters/credential_resolver.dart';
import 'package:dab_api/src/infrastructure/core/adapters/oauth_client_credential_resolver.dart';
import 'package:dab_api/src/infrastructure/core/adapters/oauth_credential_refresher.dart';
import 'package:dab_api/src/infrastructure/core/adapters/oauth_state_store.dart';
import 'package:dab_api/src/infrastructure/core/adapters/oauth_token_client.dart';
import 'package:dab_api/src/infrastructure/core/adapters/provider_identity_probe.dart';
import 'package:dab_api/src/infrastructure/core/adapters/webhook_request_authenticator.dart';
import 'package:dab_api/src/infrastructure/sources/bitbucket/bitbucket_branch_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/bitbucket/bitbucket_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_gateway_service.dart';
import 'package:dab_api/src/infrastructure/sources/discord/discord_message_source.dart';
import 'package:dab_api/src/infrastructure/sources/gitlab/gitlab_branch_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/gitlab/gitlab_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_branch_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/github/github_commit_source.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_follow_candidate_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/jira/jira_project_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_follow_candidate_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_issue_source.dart';
import 'package:dab_api/src/infrastructure/sources/linear/linear_team_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_follow_candidate_catalog.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_gateway.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_project_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_revision_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_task_source.dart';
import 'package:dab_api/src/infrastructure/sources/phorge/phorge_user_source.dart';
import 'package:dab_api/src/infrastructure/sources/slack/slack_message_source.dart';
import 'package:dab_api/src/infrastructure/core/realtime/presence_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

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

  // clients
  final jsonRestProtocol = HttpJsonRestProtocol();
  sl.registerSingleton<JsonRestProtocol>(jsonRestProtocol);

  final slackWebProtocol = HttpSlackWebProtocol();
  sl.registerSingleton<SlackWebProtocol>(slackWebProtocol);

  final graphqlProtocol = HttpGraphqlProtocol();
  sl.registerSingleton<GraphqlProtocol>(graphqlProtocol);
  final jwtProvider = JwtProvider();
  sl.registerSingleton<JwtProvider>(jwtProvider);
  sl.registerSingleton<IAccessTokenIssuer>(jwtProvider);
  sl.registerSingleton<http.Client>(http.Client());
  sl.registerSingleton<SlackRequestVerifier>(SlackRequestVerifier());
  sl.registerSingleton<GitHubWebhookVerifier>(GitHubWebhookVerifier());
  sl.registerSingleton<PhorgeWebhookVerifier>(PhorgeWebhookVerifier());
  sl.registerSingleton<SharedSecretVerifier>(SharedSecretVerifier());
  sl.registerSingleton<LinearWebhookVerifier>(LinearWebhookVerifier());

  // -----------------------------------------------------
  // 2. Activity Architecture (Domain & Infrastructure)
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Activity System Initialization.
  // CONTRACT: Registers all ConnectorPairs (Source + Mapper) into the Registry.
  // -----------------------------------------------------

  final userRepository = UserRepository(db);
  final providerConfigRepository = ProviderConfigRepository(db);
  final conduitProtocol = HttpConduitProtocol(
    resolveBaseUrl: () async {
      final listed = await providerConfigRepository.getConfigs();
      final configs = listed.getOrElse((_) => const []);
      for (final c in configs) {
        if (c.id.trim().toLowerCase() != 'phorge') continue;
        return phorgeInstanceUrl(
          instanceUrl: (c.settings['instanceUrl'] ?? '').toString(),
          baseUrl: c.baseUrl,
        );
      }
      return null;
    },
  );
  sl.registerSingleton<ConduitProtocol>(conduitProtocol);
  sl.registerSingleton<SettingsCipher>(SettingsCipher(config.credentialsKey));
  sl.registerSingleton<AbsIUserProviderCredentialRepository>(
    UserProviderCredentialRepository(db, sl<SettingsCipher>()),
  );
  sl.registerSingleton<AbsIActivityFollowRepository>(
    ActivityFollowRepository(db),
  );
  sl.registerSingleton<ICredentialResolver>(
    CredentialResolver(sl<AbsIUserProviderCredentialRepository>()),
  );
  sl.registerSingleton<IProviderIdentityProbe>(
    ProviderIdentityProbe(
      jsonRest: jsonRestProtocol,
      graphql: graphqlProtocol,
      slackWeb: slackWebProtocol,
      conduit: conduitProtocol,
    ),
  );

  // Infrastructure Sources (Raw I/O)
  final phorgeTaskSource = PhorgeTaskSource(
    conduitProtocol,
    credentials: sl<ICredentialResolver>(),
    configs: providerConfigRepository,
  );
  final phorgeRevisionSource = PhorgeRevisionSource(
    conduitProtocol,
    credentials: sl<ICredentialResolver>(),
    configs: providerConfigRepository,
  );
  final phorgeUserSource = PhorgeUserSource(conduitProtocol);
  final phorgeProjectSource = PhorgeProjectSource(conduitProtocol);
  final phorgeGateway = PhorgeGateway(
    userSource: phorgeUserSource,
    taskSource: phorgeTaskSource,
    revisionSource: phorgeRevisionSource,
    projectSource: phorgeProjectSource,
  );
  sl.registerSingleton<AbsIPhorgeGateway>(phorgeGateway);

  // New Scaffolds (Slack, Jira, Linear, Discord)
  final slackSource = SlackMessageSource(
    providerConfigRepository,
    userRepository,
    slackWebProtocol,
  );
  final jiraSource = JiraIssueSource(
    providerConfigRepository,
    userRepository,
    jsonRestProtocol,
    sl<ICredentialResolver>(),
  );
  final linearSource = LinearIssueSource(
    providerConfigRepository,
    userRepository,
    graphqlProtocol,
    sl<ICredentialResolver>(),
  );
  final discordSource = DiscordMessageSource(
    providerConfigRepository,
    userRepository,
    jsonRestProtocol,
  );
  final githubSource = GitHubCommitSource(
    providerConfigRepository,
    userRepository,
    jsonRestProtocol,
    sl<ICredentialResolver>(),
  );
  final gitlabSource = GitLabCommitSource(
    providerConfigRepository,
    userRepository,
    jsonRestProtocol,
    sl<ICredentialResolver>(),
  );
  final bitbucketSource = BitbucketCommitSource(
    providerConfigRepository,
    userRepository,
    jsonRestProtocol,
    sl<ICredentialResolver>(),
  );

  sl.registerSingleton<PhorgeUserSource>(phorgeUserSource);
  sl.registerSingleton<IPhorgeTaskHydrator>(phorgeTaskSource);
  sl.registerSingleton<SlackMessageSource>(slackSource);
  sl.registerSingleton<JiraIssueSource>(jiraSource);
  sl.registerSingleton<LinearIssueSource>(linearSource);
  sl.registerSingleton<DiscordMessageSource>(discordSource);
  sl.registerSingleton<GitHubCommitSource>(githubSource);
  sl.registerSingleton<GitLabCommitSource>(gitlabSource);
  sl.registerSingleton<BitbucketCommitSource>(bitbucketSource);

  // Application Orchestration: Mapping Sources to Mappers (single registration site)
  final registry = ConnectorRegistry();
  registerActivityConnectors(
    registry: registry,
    phorgeTaskSource: phorgeTaskSource,
    phorgeRevisionSource: phorgeRevisionSource,
    slackSource: slackSource,
    jiraSource: jiraSource,
    linearSource: linearSource,
    discordSource: discordSource,
    githubSource: githubSource,
    gitlabSource: gitlabSource,
    bitbucketSource: bitbucketSource,
  );

  sl.registerSingleton<ConnectorRegistry>(registry);

  // Repositories
  sl.registerSingleton<AbsIAuthRepository>(AuthRepository(db));
  sl.registerSingleton<AbsIActivityRepository>(ActivityRepository(db));
  sl.registerSingleton<IUserRepository>(userRepository);
  sl.registerSingleton<AbsIHealthRepository>(
    PostgresHealthRepository(sl<PostgresClient>()),
  );
  sl.registerSingleton<AbsIProviderMetadataRepository>(
    ProviderMetadataRepository(phorgeGateway: phorgeGateway),
  );
  sl.registerSingleton<AbsIProviderConfigRepository>(providerConfigRepository);
  sl.registerSingleton<ISystemSettingsRepository>(SystemSettingsRepository(db));
  sl.registerSingleton<RedisService>(
    RedisService(redisClient, sl<ISystemSettingsRepository>()),
  );
  sl.registerSingleton<ILiveFeedStore>(sl<RedisService>());
  sl.registerSingleton<IWebhookRequestAuthenticator>(
    WebhookRequestAuthenticator(
      sl<AbsIProviderConfigRepository>(),
      sl<SlackRequestVerifier>(),
      sl<GitHubWebhookVerifier>(),
      sl<PhorgeWebhookVerifier>(),
      sl<LinearWebhookVerifier>(),
      sl<SharedSecretVerifier>(),
    ),
  );
  sl.registerSingleton<IOauthPkce>(OauthPkce());
  sl.registerSingleton<IOauthStateStore>(
    RedisOauthStateStore(sl<RedisService>()),
  );
  sl.registerSingleton<IOauthTokenClient>(HttpOauthTokenClient());
  sl.registerSingleton<IOauthClientCredentialResolver>(
    OauthClientCredentialResolver(config),
  );
  sl.registerSingleton<IOauthCredentialRefresher>(
    OauthCredentialRefresher(
      sl<AbsIUserProviderCredentialRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<IOauthClientCredentialResolver>(),
      sl<IOauthTokenClient>(),
    ),
  );

  // -----------------------------------------------------
  // 3. System Services
  // [ARCH: APPLICATION_BOOTSTRAP]
  // ROLE: Cross-cutting system utilities.
  // -----------------------------------------------------
  sl.registerSingleton<PresenceService>(PresenceService());
  sl.registerSingleton<IPresenceBroadcaster>(sl<PresenceService>());
  sl.registerSingleton<LoggingService>(LoggingService());
  sl.registerSingleton<PushNotificationService>(PushNotificationService());
  sl.registerSingleton<ProviderCapabilityCatalog>(ProviderCapabilityCatalog());
  sl.registerSingleton<ActivityLivePublisher>(
    ActivityLivePublisher(sl<ILiveFeedStore>(), sl<IPresenceBroadcaster>()),
  );
  sl.registerSingleton<LiveIngestPersister>(
    LiveIngestPersister(
      activities: sl<AbsIActivityRepository>(),
      liveFeed: sl<ILiveFeedStore>(),
      presence: sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
    ),
  );

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
        'jira': sl<JiraIssueSource>(),
        'linear': sl<LinearIssueSource>(),
        'discord': sl<DiscordMessageSource>(),
        'gitlab': sl<GitLabCommitSource>(),
        'bitbucket': sl<BitbucketCommitSource>(),
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
  sl.registerSingleton<CreateUserByAdmin>(
    CreateUserByAdmin(
      sl<AbsIAuthRepository>(),
      sl<IUserRepository>(),
      sl<PhorgeUserSource>(),
      sl<ISystemSettingsRepository>(),
    ),
  );
  sl.registerSingleton<AuthenticateUser>(
    AuthenticateUser(
      sl<AbsIAuthRepository>(),
      sl<LoginUser>(),
      sl<IAccessTokenIssuer>(),
    ),
  );
  sl.registerSingleton<RegisterNewUser>(
    RegisterNewUser(
      sl<AbsIAuthRepository>(),
      sl<RegisterUser>(),
      sl<IAccessTokenIssuer>(),
    ),
  );
  sl.registerSingleton<LinkUserIdentity>(
    LinkUserIdentity(sl<IUserRepository>()),
  );
  sl.registerSingleton<RefreshToken>(
    RefreshToken(sl<AbsIAuthRepository>(), sl<IAccessTokenIssuer>()),
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
  sl.registerSingleton<DeleteUserIdentity>(
    DeleteUserIdentity(sl<IUserRepository>()),
  );

  // Activity
  sl.registerSingleton<FetchRemoteActivities>(
    FetchRemoteActivities(sl<UnifiedActivityFetcher>()),
  );
  sl.registerSingleton<GetRecentActivities>(
    GetRecentActivities(sl<AbsIActivityRepository>()),
  );
  sl.registerSingleton<GetLiveActivities>(
    GetLiveActivities(sl<ILiveFeedStore>()),
  );
  sl.registerSingleton<SearchActivities>(
    SearchActivities(sl<AbsIAuthRepository>(), sl<FetchRemoteActivities>()),
  );
  sl.registerSingleton<IngestGitHubWebhook>(
    IngestGitHubWebhook(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      credentials: sl<ICredentialResolver>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IngestSlackEvent>(
    IngestSlackEvent(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      httpClient: sl<http.Client>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IngestPhorgeWebhook>(
    IngestPhorgeWebhook(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<IPhorgeTaskHydrator>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IngestJiraWebhook>(
    IngestJiraWebhook(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IngestLinearWebhook>(
    IngestLinearWebhook(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IngestGitLabWebhook>(
    IngestGitLabWebhook(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      credentials: sl<ICredentialResolver>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IngestBitbucketWebhook>(
    IngestBitbucketWebhook(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      credentials: sl<ICredentialResolver>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IngestDiscordMessage>(
    IngestDiscordMessage(
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ILiveFeedStore>(),
      sl<IPresenceBroadcaster>(),
      livePublisher: sl<ActivityLivePublisher>(),
      persister: sl<LiveIngestPersister>(),
      follows: sl<AbsIActivityFollowRepository>(),
    ),
  );
  sl.registerSingleton<IDiscordLiveIngestor>(sl<IngestDiscordMessage>());
  sl.registerSingleton<DiscordGatewayService>(
    DiscordGatewayService(
      sl<AbsIProviderConfigRepository>(),
      sl<IDiscordLiveIngestor>(),
    ),
  );
  sl.registerSingleton<LogActivity>(
    LogActivity(
      sl<AbsIActivityRepository>(),
      sl<AbsIAuthRepository>(),
      sl<IPresenceBroadcaster>(),
      sl<ILiveFeedStore>(),
      livePublisher: sl<ActivityLivePublisher>(),
    ),
  );
  sl.registerSingleton<ArchiveLiveActivity>(
    ArchiveLiveActivity(sl<ILiveFeedStore>(), sl<IPresenceBroadcaster>()),
  );
  sl.registerSingleton<UnarchiveLiveActivity>(
    UnarchiveLiveActivity(sl<ILiveFeedStore>(), sl<IPresenceBroadcaster>()),
  );
  sl.registerSingleton<ActivityPurgeScheduler>(
    ActivityPurgeScheduler(
      sl<ILiveFeedStore>(),
      sl<ISystemSettingsRepository>(),
    ),
  );
  sl.registerSingleton<ActivityLivePollScheduler>(
    ActivityLivePollScheduler(
      sl<UnifiedActivityFetcher>(),
      sl<IUserRepository>(),
      sl<AbsIActivityRepository>(),
      sl<ILiveFeedStore>(),
      sl<ActivityLivePublisher>(),
    ),
  );

  // User
  sl.registerLazySingleton<SyncPhorgeUsers>(
    () => SyncPhorgeUsers(
      sl<IUserRepository>(),
      sl<AbsIPhorgeGateway>(),
      sl<AbsIProviderConfigRepository>(),
      allowedDomain: sl<Config>().allowedDomain,
    ),
  );
  sl.registerSingleton<GetUsers>(GetUsers(sl<IUserRepository>()));
  sl.registerSingleton<GetUserById>(GetUserById(sl<IUserRepository>()));
  sl.registerSingleton<GetUsersByGroup>(GetUsersByGroup(sl<IUserRepository>()));
  sl.registerSingleton<ListUserProviderCredentials>(
    ListUserProviderCredentials(
      sl<AbsIUserProviderCredentialRepository>(),
      sl<IUserRepository>(),
      sl<AbsIProviderConfigRepository>(),
    ),
  );
  sl.registerSingleton<SaveUserProviderCredential>(
    SaveUserProviderCredential(
      sl<AbsIUserProviderCredentialRepository>(),
      sl<IUserRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<IProviderIdentityProbe>(),
    ),
  );
  sl.registerSingleton<DeleteUserProviderCredential>(
    DeleteUserProviderCredential(
      sl<AbsIUserProviderCredentialRepository>(),
      sl<AbsIProviderConfigRepository>(),
    ),
  );
  sl.registerSingleton<TestUserProviderCredential>(
    TestUserProviderCredential(
      sl<AbsIUserProviderCredentialRepository>(),
      sl<AbsIProviderConfigRepository>(),
      sl<IProviderIdentityProbe>(),
    ),
  );
  sl.registerSingleton<StartProviderOauth>(
    StartProviderOauth(
      sl<AbsIProviderConfigRepository>(),
      sl<ISystemSettingsRepository>(),
      sl<IOauthStateStore>(),
      sl<IOauthClientCredentialResolver>(),
      sl<IOauthPkce>(),
    ),
  );
  sl.registerSingleton<CompleteProviderOauth>(
    CompleteProviderOauth(
      sl<IOauthStateStore>(),
      sl<IOauthTokenClient>(),
      sl<IOauthClientCredentialResolver>(),
      sl<AbsIProviderConfigRepository>(),
      sl<SaveUserProviderCredential>(),
    ),
  );
  sl.registerSingleton<IJiraProjectCatalog>(
    JiraProjectCatalog(jsonRestProtocol),
  );
  sl.registerSingleton<IGitHubBranchCatalog>(
    GitHubBranchCatalog(jsonRestProtocol),
  );
  sl.registerSingleton<IGitLabBranchCatalog>(
    GitLabBranchCatalog(jsonRestProtocol),
  );
  sl.registerSingleton<IBitbucketBranchCatalog>(
    BitbucketBranchCatalog(jsonRestProtocol),
  );
  sl.registerSingleton<GetGitWatchList>(
    GetGitWatchList(
      sl<ICredentialResolver>(),
      sl<AbsIProviderConfigRepository>(),
    ),
  );
  sl.registerSingleton<GetGitBranchList>(
    GetGitBranchList(
      sl<GetGitWatchList>(),
      sl<ICredentialResolver>(),
      sl<IGitHubBranchCatalog>(),
      sl<IGitLabBranchCatalog>(),
      sl<IBitbucketBranchCatalog>(),
      sl<AbsIProviderConfigRepository>(),
      sl<IOauthCredentialRefresher>(),
    ),
  );
  sl.registerSingleton<SaveGitWatchList>(
    SaveGitWatchList(
      sl<GetGitWatchList>(),
      sl<AbsIUserProviderCredentialRepository>(),
    ),
  );
  sl.registerSingleton<GetJiraProjectWatchList>(
    GetJiraProjectWatchList(
      sl<ICredentialResolver>(),
      sl<IJiraProjectCatalog>(),
      sl<AbsIProviderConfigRepository>(),
      sl<IOauthCredentialRefresher>(),
    ),
  );
  sl.registerSingleton<SaveJiraProjectWatchList>(
    SaveJiraProjectWatchList(
      sl<GetJiraProjectWatchList>(),
      sl<AbsIProviderConfigRepository>(),
      sl<ICredentialResolver>(),
    ),
  );
  sl.registerSingleton<ILinearTeamCatalog>(LinearTeamCatalog(graphqlProtocol));
  sl.registerSingleton<GetLinearTeamWatchList>(
    GetLinearTeamWatchList(
      sl<ICredentialResolver>(),
      sl<ILinearTeamCatalog>(),
      sl<AbsIProviderConfigRepository>(),
      sl<IOauthCredentialRefresher>(),
    ),
  );
  sl.registerSingleton<SaveLinearTeamWatchList>(
    SaveLinearTeamWatchList(
      sl<GetLinearTeamWatchList>(),
      sl<AbsIProviderConfigRepository>(),
    ),
  );
  sl.registerSingleton<ListFollowCandidates>(
    ListFollowCandidates(
      [
        JiraFollowCandidateCatalog(
          sl<AbsIProviderConfigRepository>(),
          sl<ICredentialResolver>(),
          jsonRestProtocol,
        ),
        LinearFollowCandidateCatalog(
          sl<AbsIProviderConfigRepository>(),
          sl<ICredentialResolver>(),
          sl<GraphqlProtocol>(),
          sl<IUserRepository>(),
        ),
        PhorgeFollowCandidateCatalog(
          sl<AbsIProviderConfigRepository>(),
          sl<ICredentialResolver>(),
          sl<IUserRepository>(),
          sl<ConduitProtocol>(),
        ),
      ],
      sl<GetGitWatchList>(),
      sl<GetGitBranchList>(),
    ),
  );
  sl.registerSingleton<ListMyActivityFollows>(
    ListMyActivityFollows(sl<AbsIActivityFollowRepository>()),
  );
  sl.registerSingleton<SaveActivityFollow>(
    SaveActivityFollow(sl<AbsIActivityFollowRepository>()),
  );
  sl.registerSingleton<DeleteActivityFollow>(
    DeleteActivityFollow(sl<AbsIActivityFollowRepository>()),
  );

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
  sl.registerSingleton<GetSystemSettings>(
    GetSystemSettings(sl<ISystemSettingsRepository>()),
  );
  sl.registerSingleton<SaveSystemSettings>(
    SaveSystemSettings(sl<ISystemSettingsRepository>()),
  );
  sl.registerSingleton<ProviderLiveConnectivityChecker>(
    ProviderLiveConnectivityChecker(
      sl<ILiveFeedStore>(),
      sl<DiscordGatewayService>(),
    ),
  );
  sl.registerSingleton<ProviderLiveWebhookTestService>(
    ProviderLiveWebhookTestService(
      sl<ILiveFeedStore>(),
      sl<DiscordGatewayService>(),
      sl<GitHubWebhookVerifier>(),
      sl<SlackRequestVerifier>(),
      sl<LinearWebhookVerifier>(),
      sl<PhorgeWebhookVerifier>(),
      sl<SharedSecretVerifier>(),
    ),
  );
  sl.registerSingleton<ProviderConfigConnectivityService>(
    ProviderConfigConnectivityService(
      sl<ProviderLiveConnectivityChecker>(),
      sl<ProviderLiveWebhookTestService>(),
    ),
  );
  sl.registerSingleton<TestProviderConfig>(
    TestProviderConfig(sl<ProviderConfigConnectivityService>()),
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
      createUserByAdmin: sl<CreateUserByAdmin>(),
      linkUserIdentity: sl<LinkUserIdentity>(),
      getAllIdentities: sl<GetAllIdentities>(),
      countUnresolvedIdentities: sl<CountUnresolvedIdentities>(),
      findAllUsers: sl<FindAllUsers>(),
      updateUserRole: sl<UpdateUserRole>(),
      resolveUserIdentity: sl<ResolveUserIdentity>(),
      deleteUserIdentity: sl<DeleteUserIdentity>(),
    ),
  );

  sl.registerSingleton<ActivityUseCases>(
    ActivityUseCases(
      archiveLiveActivity: sl<ArchiveLiveActivity>(),
      fetchRemoteActivities: sl<FetchRemoteActivities>(),
      getLiveActivities: sl<GetLiveActivities>(),
      getRecentActivities: sl<GetRecentActivities>(),
      ingestBitbucketWebhook: sl<IngestBitbucketWebhook>(),
      ingestGitHubWebhook: sl<IngestGitHubWebhook>(),
      ingestGitLabWebhook: sl<IngestGitLabWebhook>(),
      ingestJiraWebhook: sl<IngestJiraWebhook>(),
      ingestLinearWebhook: sl<IngestLinearWebhook>(),
      ingestPhorgeWebhook: sl<IngestPhorgeWebhook>(),
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
      listUserProviderCredentials: sl<ListUserProviderCredentials>(),
      saveUserProviderCredential: sl<SaveUserProviderCredential>(),
      deleteUserProviderCredential: sl<DeleteUserProviderCredential>(),
      testUserProviderCredential: sl<TestUserProviderCredential>(),
      startProviderOauth: sl<StartProviderOauth>(),
      getGitWatchList: sl<GetGitWatchList>(),
      getGitBranchList: sl<GetGitBranchList>(),
      saveGitWatchList: sl<SaveGitWatchList>(),
      getJiraProjectWatchList: sl<GetJiraProjectWatchList>(),
      saveJiraProjectWatchList: sl<SaveJiraProjectWatchList>(),
      getLinearTeamWatchList: sl<GetLinearTeamWatchList>(),
      saveLinearTeamWatchList: sl<SaveLinearTeamWatchList>(),
      listMyActivityFollows: sl<ListMyActivityFollows>(),
      listFollowCandidates: sl<ListFollowCandidates>(),
      saveActivityFollow: sl<SaveActivityFollow>(),
      deleteActivityFollow: sl<DeleteActivityFollow>(),
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
      getSystemSettings: sl<GetSystemSettings>(),
      saveSystemSettings: sl<SaveSystemSettings>(),
      testProviderConfig: sl<TestProviderConfig>(),
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
          'slack',
          'Slack',
          'https://slack.com',
          'https://slack.com/favicon.ico',
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
        (
          'bitbucket',
          'Bitbucket',
          'https://bitbucket.org',
          'https://bitbucket.org/favicon.ico',
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
