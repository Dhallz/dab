// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get dashboardTitle => 'Tablero';

  @override
  String get dashboardOverview => 'Resumen';

  @override
  String get dashboardSubtitle => 'Flujo en vivo próx.';

  @override
  String get navExplorer => 'Explorador';

  @override
  String get navAdmin => 'Administración';

  @override
  String get explorerModeSingleDay => 'Día';

  @override
  String get explorerModeRange => 'Rango';

  @override
  String get explorerQuickToday => 'Hoy';

  @override
  String get explorerQuickWeek => 'Semana';

  @override
  String get explorerPickRange => 'Elegir rng.';

  @override
  String get explorerSectionDirectory => 'Directorio';

  @override
  String get explorerSectionActivities => 'Actividades';

  @override
  String get explorerSectionProviders => 'Proveedores';

  @override
  String get explorerDirectoryUsers => 'Usuarios';

  @override
  String get explorerDirectoryGroups => 'Grupos';

  @override
  String get explorerCreateGroup => 'Crear grupo';

  @override
  String get explorerGroupActions => 'Acciones de grupo';

  @override
  String get explorerEditGroupMembers => 'Editar miembros del grupo';

  @override
  String get explorerSelectGroupMembers => 'Seleccionar miembros';

  @override
  String get explorerRenameGroup => 'Renombrar grupo';

  @override
  String get explorerDeleteGroup => 'Eliminar grupo';

  @override
  String get explorerGroupNamePlaceholder => 'Nombre del grupo';

  @override
  String get explorerCancel => 'Cancelar';

  @override
  String get explorerSave => 'Guardar';

  @override
  String get explorerActivityFilterCommit => 'Commits';

  @override
  String get explorerActivityFilterRevision => 'Revisiones';

  @override
  String get explorerActivityFilterTask => 'Tareas';

  @override
  String get explorerActivityFilterMessage => 'Mensajes';

  @override
  String get explorerActivityFilterGeneric => 'Genérico';

  @override
  String get activityKindComment => 'Comentario';

  @override
  String get activityKindTag => 'Etiqueta';

  @override
  String get activityKindStatus => 'Estado';

  @override
  String get activityKindReview => 'Revisión';

  @override
  String get activityKindAssignment => 'Asignación';

  @override
  String get activityKindCommit => 'Commit';

  @override
  String get activityKindMessage => 'Mensaje';

  @override
  String get activityKindActivity => 'Actividad';

  @override
  String get insightsTitle => 'Análisis';

  @override
  String get insightsFiltersTitle => 'Filtros';

  @override
  String get insightsUsersSectionTitle => 'Usuarios';

  @override
  String get insightsProvidersSectionTitle => 'Proveedores';

  @override
  String get insightsActivityTypesSectionTitle => 'Tipos de actividad';

  @override
  String get insightsPresetToday => 'Hoy';

  @override
  String get insightsPresetLast7Days => 'Últ. 7 d';

  @override
  String get insightsPresetLast30Days => 'Últ. 30 d';

  @override
  String get insightsPresetCustom => 'Personalizado';

  @override
  String get insightsKpiTotalActivities => 'Actividades totales';

  @override
  String get insightsKpiActiveUsers => 'Usuarios activos';

  @override
  String get insightsKpiActiveProviders => 'Proveedores activos';

  @override
  String get insightsKpiTopActivityType => 'Tipo de actividad principal';

  @override
  String get insightsTrendTitle => 'Tendencia de actividad';

  @override
  String get insightsBreakdownProviders => 'Por proveedor';

  @override
  String get insightsBreakdownActivityTypes => 'Por tipo de actividad';

  @override
  String get insightsBreakdownTopUsers => 'Usuarios principales';

  @override
  String get insightsDetailsTitle => 'Detalles';

  @override
  String get insightsNoData => 'Sin datos';

  @override
  String get insightsNoDataForFilters =>
      'Sin datos para los filtros seleccionados.';

  @override
  String get insightsErrorLoading => 'No se pudieron cargar los insights.';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get logoutTitle => 'Cerrar sesión';

  @override
  String get settingsSectionAppearance => 'Apariencia';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsSectionIslandBar => 'Barra Island';

  @override
  String get settingsSectionAbout => 'Acerca de';

  @override
  String get settingsSectionExplorerCache => 'Explorer cache';

  @override
  String get settingsExplorerCacheDescription =>
      'Remove cached Explorer activities for selected providers and dates. The next browse refetches from provider APIs.';

  @override
  String get settingsExplorerCacheDateRange => 'Date range';

  @override
  String get settingsExplorerCacheProviders => 'Providers';

  @override
  String get settingsExplorerCacheSelectAll => 'Select all';

  @override
  String get settingsExplorerCacheClearSelection => 'Clear selection';

  @override
  String get settingsExplorerCacheClearButton => 'Clear cache';

  @override
  String get settingsExplorerCacheConfirmTitle => 'Clear Explorer cache?';

  @override
  String settingsExplorerCacheConfirmMessage(
    String startDate,
    String endDate,
    String providers,
  ) {
    return 'Remove cached Explorer data from $startDate through $endDate for: $providers.';
  }

  @override
  String settingsExplorerCacheSuccess(int count) {
    return 'Cleared $count cached Explorer entries.';
  }

  @override
  String get settingsExplorerCacheFailure => 'Unable to clear Explorer cache.';

  @override
  String get settingsExplorerCacheNoProviders =>
      'No active providers are configured.';

  @override
  String get settingsExplorerCacheSelectProvider =>
      'Select at least one provider.';

  @override
  String get settingsThemeLight => 'Claro';

  @override
  String get settingsThemeDab => 'DAB';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsLanguageSystemDefault => 'Predeterminado del sistema';

  @override
  String get settingsLanguageEnglish => 'Inglés';

  @override
  String get settingsLanguageSpanish => 'Español';

  @override
  String get settingsLanguageFrench => 'Francés';

  @override
  String get settingsLanguageGerman => 'Alemán';

  @override
  String get settingsLanguagePortuguese => 'Portugués';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsVersionLabel => 'Versión';

  @override
  String get settingsIslandBarDashboard => 'Tablero';

  @override
  String get settingsIslandBarExplorer => 'Explor.';

  @override
  String get settingsIslandBarInsights => 'Análisis';

  @override
  String get settingsIslandBarItemTitle => 'Título';

  @override
  String get settingsIslandBarItemSubtitle => 'Subtítulo';

  @override
  String get settingsIslandBarItemDateControls => 'Fechas';

  @override
  String get settingsIslandBarItemQuickPreset => 'Preajuste';

  @override
  String get settingsIslandBarItemDateModeToggle => 'Modo fecha';

  @override
  String get settingsIslandBarItemActivitySummary => 'Resum. act.';

  @override
  String get settingsIslandBarItemHeatBar => 'Calor';

  @override
  String get settingsIslandBarItemDateRange => 'Rango';

  @override
  String get settingsIslandBarItemPresets => 'Preaj.';

  @override
  String get settingsSave => 'Guardar';

  @override
  String get settingsClose => 'Cerrar';

  @override
  String get settingsSavedMessage => 'Configuración guardada';

  @override
  String get brandTagline => 'Dev Activity Board';

  @override
  String get brandShortName => 'DAB';

  @override
  String get navFeed => 'Actividad';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOpen => 'Open';

  @override
  String get commonDismiss => 'Dismiss';

  @override
  String get commonTry => 'Try';

  @override
  String get commonOr => 'OR';

  @override
  String get commonPasswordMaskHint => '••••••••';

  @override
  String get authWelcomeBack => 'Welcome Back';

  @override
  String get authCreateAccount => 'Create Account';

  @override
  String get authSignInWithSso => 'Sign in with Company SSO';

  @override
  String get authLabelName => 'Name';

  @override
  String get authHintName => 'Your full name';

  @override
  String get authLabelEmail => 'Email';

  @override
  String get authHintEmail => 'you@company.com';

  @override
  String get authLabelPassword => 'Password';

  @override
  String get authSignIn => 'Sign In';

  @override
  String get authRegister => 'Register';

  @override
  String get authToggleRegister => 'Don\'t have an account? Register';

  @override
  String get authToggleSignIn => 'Already have an account? Sign In';

  @override
  String get adminNavManagement => 'GESTIÓN';

  @override
  String get adminNavProviders => 'Proveedores';

  @override
  String get adminNavIdentities => 'Identidades';

  @override
  String get adminNavSecurity => 'Seguridad';

  @override
  String get adminSectionProvidersTitle => 'Proveedores';

  @override
  String get adminSectionIdentitiesTitle => 'Identidades';

  @override
  String get adminSectionSecurityTitle => 'Seguridad del sistema';

  @override
  String get adminSectionProvidersSubtitle =>
      'Define y gestiona conexiones con servicios externos.';

  @override
  String get adminSectionIdentitiesSubtitle =>
      'Resuelve y vincula identidades de la plataforma con usuarios.';

  @override
  String get adminSectionSecuritySubtitle =>
      'Gestiona roles de usuario y seguridad del despliegue.';

  @override
  String get adminIdentitiesSectionTitle => 'IDENTIDADES EXTERNAS';

  @override
  String get adminIdentitiesSearchHint => 'Search identities…';

  @override
  String get adminIdentitiesCreateLink => 'Create Link';

  @override
  String get adminIdentitiesEmpty => 'No identities found';

  @override
  String get adminTableFullName => 'Full Name';

  @override
  String get adminTableProvider => 'Provider';

  @override
  String get adminTableExternalId => 'External ID';

  @override
  String get adminTableProviderUsername => 'Provider Username';

  @override
  String get adminTableStatus => 'Status';

  @override
  String get adminTableActions => 'Actions';

  @override
  String get adminTooltipAddUsername => 'Add provider username';

  @override
  String get adminSecuritySectionTitle => 'GESTIÓN DE USUARIOS';

  @override
  String get adminSecuritySearchHint => 'Search by name or email';

  @override
  String get adminDomainValidationTitle => 'Domain Validation';

  @override
  String get adminDomainValidationSubtitle =>
      'Restrict account creation to a specific email domain.';

  @override
  String get adminDomainValidationToggle => 'Enforce allowed email domain';

  @override
  String get adminAllowedDomainLabel => 'Allowed Email Domain';

  @override
  String get adminAllowedDomainHint => 'e.g. acme.com';

  @override
  String get adminSaveDomain => 'Save Domain';

  @override
  String get adminDomainSavedSnack => 'Allowed domain updated successfully';

  @override
  String get adminOrgTimezoneTitle => 'Organization timezone';

  @override
  String get adminOrgTimezoneSubtitle =>
      'Calendar days in Explorer, Insights, and the live feed follow this timezone.';

  @override
  String get adminOrgTimezoneLabel => 'Timezone';

  @override
  String get adminTimezoneSavedSnack =>
      'Organization timezone updated. Explorer cache was cleared.';

  @override
  String get adminNonCompliantAccountsWarning =>
      'Accounts outside the allowed domain (existing accounts keep working):';

  @override
  String get adminAddUser => 'Add User';

  @override
  String get userDialogCreateTitle => 'Add User';

  @override
  String get userDialogCreateSubtitle =>
      'Create a new account. The user will sign in with this email and password.';

  @override
  String get userFieldName => 'Full Name';

  @override
  String get userFieldEmail => 'Email';

  @override
  String get userFieldPassword => 'Initial Password';

  @override
  String get userFieldRole => 'Role';

  @override
  String get userDialogCreateSubmit => 'Create User';

  @override
  String get userCreatedSnack => 'User created successfully';

  @override
  String get adminIslandProvidersTitle => 'Proveedores';

  @override
  String get adminIslandProvidersTooltip => 'Active / total providers';

  @override
  String get adminIslandUnresolvedTitle => 'Sin resolver';

  @override
  String get adminIslandUnresolvedTooltip => 'Identities not linked';

  @override
  String get adminIslandUsersTitle => 'Usuarios';

  @override
  String get adminIslandUsersTooltip => 'Registered users';

  @override
  String get adminIslandLinksOkTitle => 'Enlaces OK';

  @override
  String get adminIslandLinksOkTooltip =>
      'Active providers with successful connection test';

  @override
  String get adminIslandLinksOkTooltipPersonal =>
      'Active providers with OAuth app or bot credentials saved';

  @override
  String get adminIslandFailedTitle => 'Fallidos';

  @override
  String get adminIslandFailedTooltip => 'Connection failures';

  @override
  String get adminIslandFailedTooltipPersonal =>
      'Active providers missing OAuth client credentials or bot token';

  @override
  String get adminIslandPendingTitle => 'Pendientes';

  @override
  String get adminIslandPendingTooltip => 'Untested or in progress';

  @override
  String get adminIslandRefreshTooltip => 'Refresh admin data';

  @override
  String get adminIslandRefreshLabel => 'ACTUALIZAR';

  @override
  String get adminBootstrapLockTitle => 'Bootstrap Lock: ACTIVE';

  @override
  String get adminBootstrapLockSubtitle =>
      'System is locked and requires an administrative account.';

  @override
  String get adminUserRoleAdmin => 'ADMIN';

  @override
  String get adminUserRoleManager => 'MANAGER';

  @override
  String get adminUserRoleStandard => 'STANDARD';

  @override
  String get identityDialogCreateTitle => 'Create Identity Link';

  @override
  String get identityDialogUpdateTitle => 'Update Identity Link';

  @override
  String get identityDialogCreateSubtitle =>
      'Link a provider external identity to a DAB user.';

  @override
  String get identityFieldDabUser => 'DAB User';

  @override
  String get identityFieldProvider => 'Provider';

  @override
  String get identityFieldExternalId =>
      'External ID (e.g. github login, phorge PHID)';

  @override
  String get identityFieldProviderUsernameOptional =>
      'Provider Username (optional, e.g. dlimier)';

  @override
  String get identityCreateLink => 'Create Link';

  @override
  String get identityUpdateLink => 'Update Link';

  @override
  String get identityDeleteLink => 'Delete Link';

  @override
  String get identityDeleteLinkConfirmTitle => 'Delete identity link?';

  @override
  String get identityDeleteLinkConfirmMessage =>
      'Remove the link between this DAB user and the provider identity.';

  @override
  String identityLinkAssociateUser(Object externalId) {
    return 'Associate $externalId with a DAB user account.';
  }

  @override
  String get identityTargetUserId => 'Target User ID';

  @override
  String get identityProviderUsernameOptionalLabel =>
      'Provider Username (optional)';

  @override
  String get providerCardShowFields => 'Show fields';

  @override
  String get providerCardHideFields => 'Hide fields';

  @override
  String get providerCardMultilineHint =>
      'Use one value per line (comma-separated also works).';

  @override
  String get providerCardSaveCredentials => 'Save Provider Credentials';

  @override
  String providerCardEnterField(Object fieldLabel) {
    return 'Enter $fieldLabel…';
  }

  @override
  String get adminFieldApiToken => 'API Token';

  @override
  String get adminFieldBaseUrl => 'Base URL';

  @override
  String get adminFieldApiKey => 'API Key';

  @override
  String get adminFieldAtlassianEmail => 'Atlassian Email';

  @override
  String get adminFieldJiraInstanceUrl =>
      'Jira Instance URL (e.g. company.atlassian.net)';

  @override
  String get adminFieldApplicationClientId => 'Application (Client) ID';

  @override
  String get adminFieldClientSecret => 'Client Secret';

  @override
  String get adminFieldDirectoryTenantId => 'Directory (Tenant) ID';

  @override
  String get adminFieldBotToken => 'Bot Token';

  @override
  String get adminFieldSigningSecret => 'Signing Secret';

  @override
  String get adminFieldWorkspaceTeamId =>
      'Workspace/Team ID (e.g. T0123456789)';

  @override
  String get adminFieldChannelIdsOnePerLine => 'Channel IDs (one per line)';

  @override
  String get adminFieldSlackApiBaseOptional =>
      'API Base URL (optional, defaults to https://slack.com/api)';

  @override
  String get adminFieldGuildServerId => 'Guild (Server) ID';

  @override
  String get adminFieldPersonalAccessToken => 'Personal Access Token';

  @override
  String get adminFieldWebhookSecret => 'Webhook Secret';

  @override
  String get adminFieldWebhookEndpointUrl => 'Webhook Endpoint URL';

  @override
  String adminFieldWebhookEndpointUrlHint(String defaultUrl) {
    return 'Default: $defaultUrl. Edit to expose a different public URL for this provider.';
  }

  @override
  String get adminFieldRepositoryOwner => 'Repository Owner';

  @override
  String get adminFieldRepositoryName => 'Repository Name';

  @override
  String get adminFieldBranchOptional =>
      'Branch (optional, defaults to repository default)';

  @override
  String get adminFieldRepositoriesOnePerLine =>
      'Repositories (one owner/repo per line, optional)';

  @override
  String get adminFieldGithubApiBaseOptional =>
      'API Base URL (optional, defaults to https://api.github.com)';

  @override
  String get adminFieldGitLabInstanceUrl =>
      'GitLab Instance URL (e.g. gitlab.com)';

  @override
  String get adminFieldApiTokenOrSecret => 'API Token / Secret';

  @override
  String get dashboardAwaitingReplyTitle => 'Tu respuesta';

  @override
  String get dashboardAwaitingReplySubtitle => 'Hilos pendientes.';

  @override
  String get dashboardNoReplyThreads => 'Sin hilos.';

  @override
  String get dashboardLiveNowTitle => 'En vivo';

  @override
  String get dashboardSnoozed => 'Pospuesto';

  @override
  String get dashboardReviewQueue => 'Cola rev.';

  @override
  String dashboardLiveUpdated(Object relativeTime) {
    return 'En vivo · act. $relativeTime';
  }

  @override
  String commonTimeAgoSeconds(Object n) {
    return 'hace ${n}s';
  }

  @override
  String commonTimeAgoMinutes(Object n) {
    return 'hace $n m';
  }

  @override
  String dashboardReconnectNotice(Object time) {
    return 'Reconectado — $time';
  }

  @override
  String get dashboardFailedLoadLive => 'Error al cargar.';

  @override
  String get dashboardEmptyLiveCaughtUp => 'Al día — ver archivo.';

  @override
  String get dashboardEmptyLiveNoActivities => 'Sin actividad.';

  @override
  String get dashboardArchiveShow => 'Ver archivo';

  @override
  String get dashboardArchiveHide => 'Ocultar arch.';

  @override
  String dashboardArchiveShowCount(Object count) {
    return 'Archivo ($count)';
  }

  @override
  String get activityTooltipArchive => 'Archive';

  @override
  String get activityTooltipUnarchive => 'Unarchive';

  @override
  String activitySemanticsActive(Object title) {
    return 'Activity: $title';
  }

  @override
  String activitySemanticsArchived(Object title) {
    return 'Archived activity: $title';
  }

  @override
  String get explorerCouldNotLaunchUrl => 'Could not launch URL';

  @override
  String explorerTooltipCategory(Object category) {
    return 'Category: $category';
  }

  @override
  String explorerTooltipSource(Object name) {
    return 'Source: $name';
  }

  @override
  String get explorerCreateGroupSubmit => 'Create Group';

  @override
  String get explorerCreateNewGroupTitle => 'Create New Group';

  @override
  String get explorerGroupNameSectionLabel => 'GROUP NAME';

  @override
  String get explorerSelectMembersSectionLabel => 'SELECT MEMBERS';

  @override
  String get explorerGroupNameHintExample => 'e.g. Mobile Team';

  @override
  String get settingsVersionPlaceholder => '1.0.0';

  @override
  String get dashboardProviderHealthTitle => 'Estado proveed.';

  @override
  String dashboardActivityFromAuthor(Object authorName) {
    return 'De $authorName';
  }

  @override
  String get dashboardCardArchivedBadge => 'ARCHIVADO';

  @override
  String get dashboardProviderHealthLive => 'En línea';

  @override
  String get dashboardProviderHealthDegraded => 'Degradado';

  @override
  String get dashboardProviderHealthOffline => 'Sin conexión';

  @override
  String get dashboardUpcomingSourceCalendar => 'Calendario';

  @override
  String get dashboardNoProviderActivity => 'Sin actividad.';

  @override
  String get dashboardNoSyncYet => 'Sin sync';

  @override
  String dashboardLastSync(Object time) {
    return 'Últ. sync $time';
  }

  @override
  String get dashboardUpcomingSoonTitle => 'Próximo';

  @override
  String get dashboardUpcomingNoEvents => 'Sin eventos';

  @override
  String get upcomingRelativeInProgress => 'in progress';

  @override
  String get upcomingRelativeNow => 'now';

  @override
  String upcomingRelativeInMinutes(Object count) {
    return 'in ${count}m';
  }

  @override
  String upcomingRelativeInHours(Object count) {
    return 'in ${count}h';
  }

  @override
  String upcomingRelativeInDays(Object count) {
    return 'in ${count}d';
  }

  @override
  String get authErrorFailed => 'Auth failed';

  @override
  String get appBrandShortName => 'DAB';

  @override
  String get appWindowTitle => 'DAB App';

  @override
  String dashboardRelativeDaysAgo(Object n) {
    return '${n}d ago';
  }

  @override
  String dashboardRelativeHoursAgo(Object n) {
    return '${n}h ago';
  }

  @override
  String dashboardRelativeMinutesAgo(Object n) {
    return '${n}m ago';
  }

  @override
  String get dashboardRelativeJustNow => 'just now';

  @override
  String get bannerStartingNow => 'Starting now';

  @override
  String get bannerStartsInOneMinute => 'Starts in 1 minute';

  @override
  String bannerStartsInMinutes(Object count) {
    return 'Starts in $count minutes';
  }

  @override
  String get bannerStartsInOneHour => 'Starts in 1 hour';

  @override
  String bannerStartsInHours(Object count) {
    return 'Starts in $count hours';
  }

  @override
  String get explorerNoActivitiesFound => 'No activities found.';

  @override
  String get explorerNoActivitiesForDate =>
      'No activities found for this date.';

  @override
  String explorerViewingArchivedFromRange(Object count) {
    return 'Viewing $count archived activities from this range.';
  }

  @override
  String explorerViewingArchivedFromDate(Object count) {
    return 'Viewing $count archived activities from this date.';
  }

  @override
  String get explorerJumpToDateTooltip => 'Jump to date';

  @override
  String get explorerClearCacheRefreshTooltip => 'Clear cache and refresh';

  @override
  String get explorerSectionActivityProviders => 'ACTIVITY PROVIDERS';

  @override
  String get homeSearchArchivesPlaceholder => 'Search archives…';

  @override
  String get adminConnectionConnected => 'Connected';

  @override
  String get adminConnectionDisconnected => 'Disconnected';

  @override
  String get adminConnectionTimedOut => 'Connection timed out';

  @override
  String get adminIdentityStatusLinked => 'LINKED';

  @override
  String get adminIdentityStatusPending => 'PENDING';

  @override
  String get adminIdentityStatusFailed => 'FAILED';

  @override
  String get activityCategoryAbbrevCommit => 'COMMIT';

  @override
  String get activityCategoryAbbrevRevision => 'REVISION';

  @override
  String get activityCategoryAbbrevTask => 'TASK';

  @override
  String get activityCategoryAbbrevMessage => 'MESSAGE';

  @override
  String get activityCategoryAbbrevGeneric => 'ACTIVITY';

  @override
  String activityKindCountTooltip(Object label, Object count) {
    return '$label: $count';
  }

  @override
  String get settingsConnectedAccountsTitle => 'Connected accounts';

  @override
  String get settingsConnectedAccountsSubtitle =>
      'Connect the providers you use. DAB never asks for your password — you sign in at the provider.';

  @override
  String get settingsBotTokenHint =>
      'Paste a bot token (one per workspace), not your user token.';

  @override
  String get settingsCredentialConnect => 'Connect';

  @override
  String get settingsCredentialTest => 'Test';

  @override
  String get settingsCredentialDisconnect => 'Disconnect';

  @override
  String get settingsCredentialConnected => 'Connected';

  @override
  String get settingsCredentialTestOk => 'Connection succeeded';

  @override
  String get settingsCredentialDisconnected => 'Disconnected';

  @override
  String get settingsTeamTitle => 'Team';

  @override
  String get settingsTeamSubtitle =>
      'Add a teammate so they can connect their own tokens.';

  @override
  String explorerUserNotConnected(String provider) {
    return 'Hasn\'t connected $provider';
  }

  @override
  String get adminDeploymentModeTitle => 'Deployment mode';

  @override
  String get adminDeploymentModeSubtitle =>
      'Personal mode lets each teammate connect providers from Settings. Organization mode keeps Admin-owned tokens and Identities.';

  @override
  String get adminDeploymentModeOrganization => 'Organization';

  @override
  String get adminDeploymentModePersonal => 'Personal / small team';

  @override
  String get adminDeploymentModeSavedSnack => 'Deployment mode saved';

  @override
  String get adminFieldOauthClientId => 'OAuth client ID';

  @override
  String get adminFieldOauthClientIdJiraHint =>
      'Copy Client ID from Authorization → OAuth 2.0 (3LO), not App ID. Add Jira API scopes read:jira-work and read:jira-user under Permissions first.';

  @override
  String adminOauthCallbackMustMatch(String url) {
    return 'Callback URL in the provider console must be exactly: $url';
  }

  @override
  String get adminFieldOauthClientSecret => 'OAuth client secret';

  @override
  String get adminFieldInstanceUrl => 'Instance URL';

  @override
  String get adminPersonalProvidersHint =>
      'Register DAB as an OAuth app once per provider. Teammates connect from Settings. Slack and Discord use a workspace bot, not per-user login.';

  @override
  String get adminPersonalLiveWebhookHint =>
      'Instant Dashboard uses this webhook; otherwise the poller runs about every 45s.';

  @override
  String settingsConnectWithProvider(String provider) {
    return 'Connect with $provider';
  }

  @override
  String get settingsOauthOpened =>
      'Finish signing in in your browser, then return here.';

  @override
  String get settingsOauthNotConfigured =>
      'An admin must save this provider’s OAuth app in Admin → Providers first.';

  @override
  String get settingsPhorgeTokenHint =>
      'Phorge has no user OAuth. Paste a Conduit API token if you use Phorge.';

  @override
  String get settingsJiraProjectsTitle => 'Projects';

  @override
  String get settingsJiraProjectsSubtitle =>
      'Choose which Jira projects DAB should watch for tasks. This list is shared with your team.';

  @override
  String get settingsJiraProjectsEmpty =>
      'No projects were visible for this account.';

  @override
  String get settingsJiraProjectsSave => 'Save projects';

  @override
  String get settingsLinearTeamsTitle => 'Teams';

  @override
  String get settingsLinearTeamsSubtitle =>
      'Choose which Linear teams DAB should watch for issues. This list is shared with your team.';

  @override
  String get settingsLinearTeamsEmpty =>
      'No teams were visible for this account.';

  @override
  String get settingsLinearTeamsSave => 'Save teams';

  @override
  String get adminPublicApiUrlTitle => 'Public API URL';

  @override
  String get adminPublicApiUrlSubtitle =>
      'Reachable base URL for OAuth callbacks and webhook defaults (no trailing slash).';

  @override
  String get adminPublicApiUrlLabel => 'https://your-dab-api.example';

  @override
  String get adminPublicApiUrlSavedSnack => 'Public API URL saved';
}
