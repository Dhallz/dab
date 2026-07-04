// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get dashboardTitle => 'Painel';

  @override
  String get dashboardOverview => 'Visão geral';

  @override
  String get dashboardSubtitle => 'Feed ao vivo em breve.';

  @override
  String get navExplorer => 'Explorador';

  @override
  String get navAdmin => 'Administração';

  @override
  String get explorerModeSingleDay => 'Dia';

  @override
  String get explorerModeRange => 'Intervalo';

  @override
  String get explorerQuickToday => 'Hoje';

  @override
  String get explorerQuickWeek => 'Semana';

  @override
  String get explorerPickRange => 'Esc. período';

  @override
  String get explorerSectionDirectory => 'Diretório';

  @override
  String get explorerSectionActivities => 'Atividades';

  @override
  String get explorerSectionProviders => 'Provedores';

  @override
  String get explorerDirectoryUsers => 'Usuários';

  @override
  String get explorerDirectoryGroups => 'Grupos';

  @override
  String get explorerCreateGroup => 'Criar grupo';

  @override
  String get explorerGroupActions => 'Ações do grupo';

  @override
  String get explorerEditGroupMembers => 'Editar membros do grupo';

  @override
  String get explorerSelectGroupMembers => 'Selecionar membros';

  @override
  String get explorerRenameGroup => 'Renomear grupo';

  @override
  String get explorerDeleteGroup => 'Excluir grupo';

  @override
  String get explorerGroupNamePlaceholder => 'Nome do grupo';

  @override
  String get explorerCancel => 'Cancelar';

  @override
  String get explorerSave => 'Salvar';

  @override
  String get explorerActivityFilterCommit => 'Commits';

  @override
  String get explorerActivityFilterRevision => 'Revisões';

  @override
  String get explorerActivityFilterTask => 'Tarefas';

  @override
  String get explorerActivityFilterMessage => 'Mensagens';

  @override
  String get explorerActivityFilterGeneric => 'Genérico';

  @override
  String get activityKindComment => 'Comentário';

  @override
  String get activityKindTag => 'Tag';

  @override
  String get activityKindStatus => 'Status';

  @override
  String get activityKindReview => 'Revisão';

  @override
  String get activityKindAssignment => 'Atribuição';

  @override
  String get activityKindCommit => 'Commit';

  @override
  String get activityKindMessage => 'Mensagem';

  @override
  String get activityKindActivity => 'Atividade';

  @override
  String get insightsTitle => 'Análises';

  @override
  String get insightsFiltersTitle => 'Filtros';

  @override
  String get insightsUsersSectionTitle => 'Usuários';

  @override
  String get insightsProvidersSectionTitle => 'Provedores';

  @override
  String get insightsActivityTypesSectionTitle => 'Tipos de atividade';

  @override
  String get insightsPresetToday => 'Hoje';

  @override
  String get insightsPresetLast7Days => 'Últ. 7 d';

  @override
  String get insightsPresetLast30Days => 'Últ. 30 d';

  @override
  String get insightsPresetCustom => 'Personalizado';

  @override
  String get insightsKpiTotalActivities => 'Total de atividades';

  @override
  String get insightsKpiActiveUsers => 'Usuários ativos';

  @override
  String get insightsKpiActiveProviders => 'Provedores ativos';

  @override
  String get insightsKpiTopActivityType => 'Tipo de atividade principal';

  @override
  String get insightsTrendTitle => 'Tendência de atividade';

  @override
  String get insightsBreakdownProviders => 'Por provedor';

  @override
  String get insightsBreakdownActivityTypes => 'Por tipo de atividade';

  @override
  String get insightsBreakdownTopUsers => 'Principais usuários';

  @override
  String get insightsDetailsTitle => 'Detalhes';

  @override
  String get insightsNoData => 'Sem dados';

  @override
  String get insightsNoDataForFilters =>
      'Sem dados para os filtros selecionados.';

  @override
  String get insightsErrorLoading => 'Não foi possível carregar os insights.';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get logoutTitle => 'Sair';

  @override
  String get settingsSectionAppearance => 'Aparência';

  @override
  String get settingsSectionLanguage => 'Idioma';

  @override
  String get settingsSectionIslandBar => 'Barra Island';

  @override
  String get settingsSectionAbout => 'Sobre';

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
  String get settingsThemeDark => 'Escuro';

  @override
  String get settingsLanguageSystemDefault => 'Padrão do sistema';

  @override
  String get settingsLanguageEnglish => 'Inglês';

  @override
  String get settingsLanguageSpanish => 'Espanhol';

  @override
  String get settingsLanguageFrench => 'Francês';

  @override
  String get settingsLanguageGerman => 'Alemão';

  @override
  String get settingsLanguagePortuguese => 'Português';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsVersionLabel => 'Versão';

  @override
  String get settingsIslandBarDashboard => 'Painel';

  @override
  String get settingsIslandBarExplorer => 'Explor.';

  @override
  String get settingsIslandBarInsights => 'Análises';

  @override
  String get settingsIslandBarItemTitle => 'Título';

  @override
  String get settingsIslandBarItemSubtitle => 'Subtítulo';

  @override
  String get settingsIslandBarItemDateControls => 'Datas';

  @override
  String get settingsIslandBarItemQuickPreset => 'Preset';

  @override
  String get settingsIslandBarItemDateModeToggle => 'Modo data';

  @override
  String get settingsIslandBarItemActivitySummary => 'Resum. ativ.';

  @override
  String get settingsIslandBarItemHeatBar => 'Calor';

  @override
  String get settingsIslandBarItemDateRange => 'Intervalo';

  @override
  String get settingsIslandBarItemPresets => 'Presets';

  @override
  String get settingsSave => 'Salvar';

  @override
  String get settingsClose => 'Fechar';

  @override
  String get settingsSavedMessage => 'Configurações salvas';

  @override
  String get brandTagline => 'Dev Activity Board';

  @override
  String get brandShortName => 'DAB';

  @override
  String get navFeed => 'Atividade';

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
  String get adminNavManagement => 'GESTÃO';

  @override
  String get adminNavProviders => 'Provedores';

  @override
  String get adminNavIdentities => 'Identidades';

  @override
  String get adminNavSecurity => 'Segurança';

  @override
  String get adminSectionProvidersTitle => 'Configuração de provedores';

  @override
  String get adminSectionIdentitiesTitle => 'Gestão de identidades';

  @override
  String get adminSectionSecurityTitle => 'Segurança do sistema';

  @override
  String get adminSectionProvidersSubtitle =>
      'Defina e gerencie conexões com serviços externos.';

  @override
  String get adminSectionIdentitiesSubtitle =>
      'Resolva e vincule identidades da plataforma aos usuários.';

  @override
  String get adminSectionSecuritySubtitle =>
      'Gerencie funções de usuário e segurança da implantação.';

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
  String get adminSecuritySectionTitle => 'GESTÃO DE USUÁRIOS';

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
  String get adminIslandProvidersTitle => 'Provedores';

  @override
  String get adminIslandProvidersTooltip => 'Active / total providers';

  @override
  String get adminIslandUnresolvedTitle => 'Pendentes';

  @override
  String get adminIslandUnresolvedTooltip => 'Identities not linked';

  @override
  String get adminIslandUsersTitle => 'Usuários';

  @override
  String get adminIslandUsersTooltip => 'Registered users';

  @override
  String get adminIslandLinksOkTitle => 'Links OK';

  @override
  String get adminIslandLinksOkTooltip =>
      'Active providers with successful connection test';

  @override
  String get adminIslandFailedTitle => 'Falhas';

  @override
  String get adminIslandFailedTooltip => 'Connection failures';

  @override
  String get adminIslandPendingTitle => 'Em espera';

  @override
  String get adminIslandPendingTooltip => 'Untested or in progress';

  @override
  String get adminIslandRefreshTooltip => 'Refresh admin data';

  @override
  String get adminIslandRefreshLabel => 'ATUALIZAR';

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
  String get dashboardAwaitingReplyTitle => 'Sua resposta';

  @override
  String get dashboardAwaitingReplySubtitle => 'Threads pendentes.';

  @override
  String get dashboardNoReplyThreads => 'Sem threads.';

  @override
  String get dashboardLiveNowTitle => 'Ao vivo';

  @override
  String get dashboardSnoozed => 'Adiado';

  @override
  String get dashboardReviewQueue => 'Fila rev.';

  @override
  String dashboardLiveUpdated(Object relativeTime) {
    return 'Ao vivo · atual. $relativeTime';
  }

  @override
  String commonTimeAgoSeconds(Object n) {
    return 'há ${n}s';
  }

  @override
  String commonTimeAgoMinutes(Object n) {
    return 'há $n min';
  }

  @override
  String dashboardReconnectNotice(Object time) {
    return 'Reconectado — $time';
  }

  @override
  String get dashboardFailedLoadLive => 'Falha ao carregar.';

  @override
  String get dashboardEmptyLiveCaughtUp => 'Em dia — arquivo.';

  @override
  String get dashboardEmptyLiveNoActivities => 'Sem atividade.';

  @override
  String get dashboardArchiveShow => 'Arquivo';

  @override
  String get dashboardArchiveHide => 'Ocultar';

  @override
  String dashboardArchiveShowCount(Object count) {
    return 'Arquivo ($count)';
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
  String get dashboardProviderHealthTitle => 'Estado fornec.';

  @override
  String dashboardActivityFromAuthor(Object authorName) {
    return 'De $authorName';
  }

  @override
  String get dashboardCardArchivedBadge => 'ARQUIVADO';

  @override
  String get dashboardProviderHealthLive => 'Ativo';

  @override
  String get dashboardProviderHealthDegraded => 'Degradado';

  @override
  String get dashboardProviderHealthOffline => 'Offline';

  @override
  String get dashboardUpcomingSourceCalendar => 'Calendário';

  @override
  String get dashboardNoProviderActivity => 'Sem atividade.';

  @override
  String get dashboardNoSyncYet => 'Sem sync';

  @override
  String dashboardLastSync(Object time) {
    return 'Últ. sync $time';
  }

  @override
  String get dashboardUpcomingSoonTitle => 'Em breve';

  @override
  String get dashboardUpcomingNoEvents => 'Sem eventos';

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
}
