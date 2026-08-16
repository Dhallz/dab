// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get dashboardIslandLive => 'Direct';

  @override
  String get dashboardIslandArchived => 'Archivé';

  @override
  String get dashboardFeedModeTimeline => 'Chronologie';

  @override
  String get dashboardFeedModeCategory => 'Catégorie';

  @override
  String get dashboardFeedModeProvider => 'Fournisseur';

  @override
  String get dashboardGroupEmptyQuiet => 'Calme — aucune activité en direct';

  @override
  String get navExplorer => 'Explorateur';

  @override
  String get navAdmin => 'Administration';

  @override
  String get explorerModeSingleDay => 'Jour';

  @override
  String get explorerModeRange => 'Plage';

  @override
  String get explorerQuickToday => 'Aujourd\'hui';

  @override
  String get explorerQuickWeek => 'Semaine';

  @override
  String get explorerPickRange => 'Choisir pl.';

  @override
  String get explorerSectionDirectory => 'Répertoire';

  @override
  String get explorerSectionActivities => 'Activités';

  @override
  String get explorerSectionProviders => 'Fournisseurs';

  @override
  String get explorerDirectoryUsers => 'Utilisateurs';

  @override
  String get explorerDirectoryGroups => 'Groupes';

  @override
  String get explorerCreateGroup => 'Créer un groupe';

  @override
  String get explorerGroupActions => 'Actions du groupe';

  @override
  String get explorerEditGroupMembers => 'Modifier les membres du groupe';

  @override
  String get explorerSelectGroupMembers => 'Sélectionner les membres';

  @override
  String get explorerRenameGroup => 'Renommer le groupe';

  @override
  String get explorerDeleteGroup => 'Supprimer le groupe';

  @override
  String get explorerGroupNamePlaceholder => 'Nom du groupe';

  @override
  String get explorerCancel => 'Annuler';

  @override
  String get explorerSave => 'Enregistrer';

  @override
  String get explorerActivityFilterCommit => 'Commits';

  @override
  String get explorerActivityFilterRevision => 'Révisions';

  @override
  String get explorerActivityFilterTask => 'Tâches';

  @override
  String get explorerActivityFilterMessage => 'Messages';

  @override
  String get explorerActivityFilterGeneric => 'Générique';

  @override
  String get activityKindComment => 'Commentaire';

  @override
  String get activityKindTag => 'Étiquette';

  @override
  String get activityKindStatus => 'Statut';

  @override
  String get activityKindReview => 'Revue';

  @override
  String get activityKindAssignment => 'Affectation';

  @override
  String get activityKindCommit => 'Commit';

  @override
  String get activityKindMessage => 'Message';

  @override
  String get activityKindActivity => 'Activité';

  @override
  String get insightsTitle => 'Analyses';

  @override
  String get insightsFiltersTitle => 'Filtres';

  @override
  String get insightsUsersSectionTitle => 'Utilisateurs';

  @override
  String get insightsProvidersSectionTitle => 'Fournisseurs';

  @override
  String get insightsActivityTypesSectionTitle => 'Types d\'activité';

  @override
  String get insightsPresetToday => 'Aujourd\'hui';

  @override
  String get insightsPresetLast7Days => '7 j';

  @override
  String get insightsPresetLast30Days => '30 j';

  @override
  String get insightsPresetCustom => 'Personnalisé';

  @override
  String get insightsKpiTotalActivities => 'Activités totales';

  @override
  String get insightsKpiActiveUsers => 'Utilisateurs actifs';

  @override
  String get insightsKpiActiveProviders => 'Fournisseurs actifs';

  @override
  String get insightsKpiTopActivityType => 'Type d\'activité principal';

  @override
  String get insightsTrendTitle => 'Tendance d\'activité';

  @override
  String get insightsBreakdownProviders => 'Par fournisseur';

  @override
  String get insightsBreakdownActivityTypes => 'Par type d\'activité';

  @override
  String get insightsBreakdownTopUsers => 'Top utilisateurs';

  @override
  String get insightsDetailsTitle => 'Détails';

  @override
  String get insightsNoData => 'Aucune donnée';

  @override
  String get insightsNoDataForFilters =>
      'Aucune donnée pour les filtres sélectionnés.';

  @override
  String get insightsErrorLoading => 'Impossible de charger les insights.';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get logoutTitle => 'Se déconnecter';

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsSectionLanguage => 'Langue';

  @override
  String get settingsSectionAbout => 'À propos';

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
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDab => 'DAB';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguageSystemDefault => 'Paramètre système';

  @override
  String get settingsLanguageEnglish => 'Anglais';

  @override
  String get settingsLanguageSpanish => 'Espagnol';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageGerman => 'Allemand';

  @override
  String get settingsLanguagePortuguese => 'Portugais';

  @override
  String get settingsLanguageItalian => 'Italien';

  @override
  String get settingsVersionLabel => 'Version';

  @override
  String get settingsSave => 'Enregistrer';

  @override
  String get settingsClose => 'Fermer';

  @override
  String get settingsSavedMessage => 'Paramètres enregistrés';

  @override
  String get brandTagline => 'Dev Activity Board';

  @override
  String get brandShortName => 'DAB';

  @override
  String get navFeed => 'Flux';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonOpen => 'Ouvrir';

  @override
  String get commonDismiss => 'Fermer';

  @override
  String get commonTry => 'Réessayer';

  @override
  String get commonOr => 'OU';

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
  String get adminNavManagement => 'GESTION';

  @override
  String get adminNavProviders => 'Fournisseurs';

  @override
  String get adminNavIdentities => 'Identités';

  @override
  String get adminNavSecurity => 'Sécurité';

  @override
  String get adminSectionProvidersTitle => 'Configuration fournisseur';

  @override
  String get adminSectionIdentitiesTitle => 'Gestion des identités';

  @override
  String get adminSectionSecurityTitle => 'Sécurité système';

  @override
  String get adminSectionProvidersSubtitle =>
      'Définir et gérer les connexions aux services externes.';

  @override
  String get adminSectionIdentitiesSubtitle =>
      'Résoudre et lier les identités plateforme aux utilisateurs.';

  @override
  String get adminSectionSecuritySubtitle =>
      'Gérer les rôles utilisateurs et la sécurité du déploiement.';

  @override
  String get adminIdentitiesSectionTitle => 'IDENTITÉS EXTERNES';

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
  String get adminSecuritySectionTitle => 'GESTION DES UTILISATEURS';

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
  String get adminIslandProvidersTitle => 'Fournisseurs';

  @override
  String get adminIslandProvidersTooltip => 'Active / total providers';

  @override
  String get adminIslandUnresolvedTitle => 'Non résolues';

  @override
  String get adminIslandUnresolvedTooltip => 'Identities not linked';

  @override
  String get adminIslandUsersTitle => 'Utilisateurs';

  @override
  String get adminIslandUsersTooltip => 'Registered users';

  @override
  String get adminIslandLinksOkTitle => 'Liens OK';

  @override
  String get adminIslandLinksOkTooltip =>
      'Active providers with successful connection test';

  @override
  String get adminIslandLinksOkTooltipPersonal =>
      'Active providers with OAuth app or bot credentials saved';

  @override
  String get adminIslandFailedTitle => 'Échecs';

  @override
  String get adminIslandFailedTooltip => 'Connection failures';

  @override
  String get adminIslandFailedTooltipPersonal =>
      'Active providers missing OAuth client credentials or bot token';

  @override
  String get adminIslandPendingTitle => 'En attente';

  @override
  String get adminIslandPendingTooltip => 'Untested or in progress';

  @override
  String get adminIslandRefreshTooltip => 'Refresh admin data';

  @override
  String get adminIslandRefreshLabel => 'RAFRAÎCHIR';

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
  String get dashboardLiveNowTitle => 'Direct';

  @override
  String dashboardLiveUpdated(Object relativeTime) {
    return 'Direct · maj. $relativeTime';
  }

  @override
  String commonTimeAgoSeconds(Object n) {
    return '${n}s';
  }

  @override
  String commonTimeAgoMinutes(Object n) {
    return '$n min';
  }

  @override
  String dashboardReconnectNotice(Object time) {
    return 'Reconnecté — $time';
  }

  @override
  String get dashboardFailedLoadLive => 'Échec chargement.';

  @override
  String get dashboardEmptyLiveCaughtUp => 'À jour — archives.';

  @override
  String get dashboardEmptyLiveNoActivities => 'Rien en direct.';

  @override
  String get dashboardArchiveShow => 'Archives';

  @override
  String get dashboardArchiveHide => 'Masquer';

  @override
  String dashboardArchiveShowCount(Object count) {
    return 'Archives ($count)';
  }

  @override
  String get activityTooltipArchive => 'Archiver';

  @override
  String get activityTooltipFollow => 'Follow';

  @override
  String get activityTooltipFollowing => 'Following';

  @override
  String get activityTooltipUnarchive => 'Restaurer';

  @override
  String activitySemanticsActive(Object title) {
    return 'Activité : $title';
  }

  @override
  String activitySemanticsArchived(Object title) {
    return 'Activité archivée : $title';
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
  String get dashboardProviderHealthTitle => 'Fourniss.';

  @override
  String dashboardActivityFromAuthor(Object authorName) {
    return 'De $authorName';
  }

  @override
  String get dashboardCardArchivedBadge => 'ARCHIVÉ';

  @override
  String get dashboardProviderHealthLive => 'Actif';

  @override
  String get dashboardProviderHealthDegraded => 'Dégradé';

  @override
  String get dashboardProviderHealthOffline => 'Hors ligne';

  @override
  String get dashboardNoProviderActivity => 'Aucune activité.';

  @override
  String get dashboardNoSyncYet => 'Pas sync';

  @override
  String dashboardLastSync(Object time) {
    return 'Sync $time';
  }

  @override
  String get authErrorFailed => 'Échec de l\'authentification';

  @override
  String get appBrandShortName => 'DAB';

  @override
  String get appWindowTitle => 'DAB App';

  @override
  String dashboardRelativeDaysAgo(Object n) {
    return 'il y a $n j';
  }

  @override
  String dashboardRelativeHoursAgo(Object n) {
    return 'il y a $n h';
  }

  @override
  String dashboardRelativeMinutesAgo(Object n) {
    return 'il y a $n min';
  }

  @override
  String get dashboardRelativeJustNow => 'à l\'instant';

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
      'Connect the providers you use so DAB can deliver a personal inbound inbox. Mentions, assignments, and git watches require a linked identity. DAB never asks for your password — you sign in at the provider.';

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
  String get settingsGitWatchesTitle => 'Inbox repos';

  @override
  String get settingsGitWatchesSubtitle =>
      'Choose which repos land in your Dashboard inbox. Saving none means no git inbox. Your own commits are excluded.';

  @override
  String get settingsGitWatchesEmpty =>
      'No repos are on the instance allow-list yet. Ask an admin to add them in Admin → Providers.';

  @override
  String get settingsGitWatchesSave => 'Save watches';

  @override
  String get settingsGitWatchesBranchesHint =>
      'Optional branches (comma-separated). Leave blank for all branches.';

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
