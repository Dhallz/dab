// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardOverview => 'Übersicht';

  @override
  String get dashboardSubtitle => 'Live-Feed bald.';

  @override
  String get navExplorer => 'Explorer';

  @override
  String get navAdmin => 'Verwaltung';

  @override
  String get explorerModeSingleDay => 'Tag';

  @override
  String get explorerModeRange => 'Bereich';

  @override
  String get explorerQuickToday => 'Heute';

  @override
  String get explorerQuickWeek => 'Woche';

  @override
  String get explorerPickRange => 'Zeitraum';

  @override
  String get explorerSectionDirectory => 'Verzeichnis';

  @override
  String get explorerSectionActivities => 'Aktivitäten';

  @override
  String get explorerSectionProviders => 'Anbieter';

  @override
  String get explorerDirectoryUsers => 'Benutzer';

  @override
  String get explorerDirectoryGroups => 'Gruppen';

  @override
  String get explorerCreateGroup => 'Gruppe erstellen';

  @override
  String get explorerGroupActions => 'Gruppenaktionen';

  @override
  String get explorerEditGroupMembers => 'Gruppenmitglieder bearbeiten';

  @override
  String get explorerSelectGroupMembers => 'Mitglieder auswählen';

  @override
  String get explorerRenameGroup => 'Gruppe umbenennen';

  @override
  String get explorerDeleteGroup => 'Gruppe löschen';

  @override
  String get explorerGroupNamePlaceholder => 'Gruppenname';

  @override
  String get explorerCancel => 'Abbrechen';

  @override
  String get explorerSave => 'Speichern';

  @override
  String get explorerActivityFilterCommit => 'Commits';

  @override
  String get explorerActivityFilterRevision => 'Revisionen';

  @override
  String get explorerActivityFilterTask => 'Aufgaben';

  @override
  String get explorerActivityFilterMessage => 'Nachrichten';

  @override
  String get explorerActivityFilterGeneric => 'Allgemein';

  @override
  String get activityKindComment => 'Kommentar';

  @override
  String get activityKindTag => 'Tag';

  @override
  String get activityKindStatus => 'Status';

  @override
  String get activityKindReview => 'Review';

  @override
  String get activityKindAssignment => 'Zuweisung';

  @override
  String get activityKindCommit => 'Commit';

  @override
  String get activityKindMessage => 'Nachricht';

  @override
  String get activityKindActivity => 'Aktivität';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get insightsFiltersTitle => 'Filter';

  @override
  String get insightsUsersSectionTitle => 'Benutzer';

  @override
  String get insightsProvidersSectionTitle => 'Anbieter';

  @override
  String get insightsActivityTypesSectionTitle => 'Aktivitätstypen';

  @override
  String get insightsPresetToday => 'Heute';

  @override
  String get insightsPresetLast7Days => '7 T';

  @override
  String get insightsPresetLast30Days => '30 T';

  @override
  String get insightsPresetCustom => 'Benutzerdefiniert';

  @override
  String get insightsKpiTotalActivities => 'Gesamtaktivitäten';

  @override
  String get insightsKpiActiveUsers => 'Aktive Benutzer';

  @override
  String get insightsKpiActiveProviders => 'Aktive Anbieter';

  @override
  String get insightsKpiTopActivityType => 'Top-Aktivitätstyp';

  @override
  String get insightsTrendTitle => 'Aktivitätstrend';

  @override
  String get insightsBreakdownProviders => 'Nach Anbieter';

  @override
  String get insightsBreakdownActivityTypes => 'Nach Aktivitätstyp';

  @override
  String get insightsBreakdownTopUsers => 'Top-Benutzer';

  @override
  String get insightsDetailsTitle => 'Details';

  @override
  String get insightsNoData => 'Keine Daten';

  @override
  String get insightsNoDataForFilters =>
      'Keine Daten für die ausgewählten Filter.';

  @override
  String get insightsErrorLoading => 'Insights konnten nicht geladen werden.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get logoutTitle => 'Abmelden';

  @override
  String get settingsSectionAppearance => 'Darstellung';

  @override
  String get settingsSectionLanguage => 'Sprache';

  @override
  String get settingsSectionIslandBar => 'Island-Leiste';

  @override
  String get settingsSectionAbout => 'Info';

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
  String get settingsThemeLight => 'Hell';

  @override
  String get settingsThemeDab => 'DAB';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsLanguageSystemDefault => 'Systemstandard';

  @override
  String get settingsLanguageEnglish => 'Englisch';

  @override
  String get settingsLanguageSpanish => 'Spanisch';

  @override
  String get settingsLanguageFrench => 'Französisch';

  @override
  String get settingsLanguageGerman => 'Deutsch';

  @override
  String get settingsLanguagePortuguese => 'Portugiesisch';

  @override
  String get settingsLanguageItalian => 'Italienisch';

  @override
  String get settingsVersionLabel => 'Version';

  @override
  String get settingsIslandBarDashboard => 'Dashboard';

  @override
  String get settingsIslandBarExplorer => 'Explor.';

  @override
  String get settingsIslandBarInsights => 'Insights';

  @override
  String get settingsIslandBarItemTitle => 'Titel';

  @override
  String get settingsIslandBarItemSubtitle => 'Untertitel';

  @override
  String get settingsIslandBarItemDateControls => 'Datum';

  @override
  String get settingsIslandBarItemQuickPreset => 'Preset';

  @override
  String get settingsIslandBarItemDateModeToggle => 'Modus';

  @override
  String get settingsIslandBarItemActivitySummary => 'Übersicht';

  @override
  String get settingsIslandBarItemHeatBar => 'Heat';

  @override
  String get settingsIslandBarItemDateRange => 'Zeitraum';

  @override
  String get settingsIslandBarItemPresets => 'Presets';

  @override
  String get settingsSave => 'Speichern';

  @override
  String get settingsClose => 'Schließen';

  @override
  String get settingsSavedMessage => 'Einstellungen gespeichert';

  @override
  String get brandTagline => 'Dev Activity Board';

  @override
  String get brandShortName => 'DAB';

  @override
  String get navFeed => 'Aktivität';

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
  String get adminNavManagement => 'VERWALTUNG';

  @override
  String get adminNavProviders => 'Anbieter';

  @override
  String get adminNavIdentities => 'Identitäten';

  @override
  String get adminNavSecurity => 'Sicherheit';

  @override
  String get adminSectionProvidersTitle => 'Anbieterkonfiguration';

  @override
  String get adminSectionIdentitiesTitle => 'Identitätsverwaltung';

  @override
  String get adminSectionSecurityTitle => 'Systemsicherheit';

  @override
  String get adminSectionProvidersSubtitle =>
      'Externe Dienstverbindungen definieren und verwalten.';

  @override
  String get adminSectionIdentitiesSubtitle =>
      'Plattformidentitäten auflösen und mit Benutzern verknüpfen.';

  @override
  String get adminSectionSecuritySubtitle =>
      'Benutzerrollen und Bereitstellungssicherheit verwalten.';

  @override
  String get adminIdentitiesSectionTitle => 'EXTERNEN IDENTITÄTEN';

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
  String get adminSecuritySectionTitle => 'BENUTZERVERWALTUNG';

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
  String get adminIslandProvidersTitle => 'Anbieter';

  @override
  String get adminIslandProvidersTooltip => 'Active / total providers';

  @override
  String get adminIslandUnresolvedTitle => 'Ungeklärt';

  @override
  String get adminIslandUnresolvedTooltip => 'Identities not linked';

  @override
  String get adminIslandUsersTitle => 'Benutzer';

  @override
  String get adminIslandUsersTooltip => 'Registered users';

  @override
  String get adminIslandLinksOkTitle => 'Links OK';

  @override
  String get adminIslandLinksOkTooltip =>
      'Active providers with successful connection test';

  @override
  String get adminIslandFailedTitle => 'Fehlgeschlagen';

  @override
  String get adminIslandFailedTooltip => 'Connection failures';

  @override
  String get adminIslandPendingTitle => 'Ausstehend';

  @override
  String get adminIslandPendingTooltip => 'Untested or in progress';

  @override
  String get adminIslandRefreshTooltip => 'Refresh admin data';

  @override
  String get adminIslandRefreshLabel => 'AKTUALISIEREN';

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
  String get dashboardAwaitingReplyTitle => 'Antwort';

  @override
  String get dashboardAwaitingReplySubtitle => 'Offene Threads.';

  @override
  String get dashboardNoReplyThreads => 'Keine Threads.';

  @override
  String get dashboardLiveNowTitle => 'Live';

  @override
  String get dashboardSnoozed => 'Pause';

  @override
  String get dashboardReviewQueue => 'Review';

  @override
  String dashboardLiveUpdated(Object relativeTime) {
    return 'Live · Update $relativeTime';
  }

  @override
  String commonTimeAgoSeconds(Object n) {
    return 'vor ${n}s';
  }

  @override
  String commonTimeAgoMinutes(Object n) {
    return 'vor $n Min';
  }

  @override
  String dashboardReconnectNotice(Object time) {
    return 'Verbunden — $time';
  }

  @override
  String get dashboardFailedLoadLive => 'Laden fehlgeschlagen.';

  @override
  String get dashboardEmptyLiveCaughtUp => 'Alles OK — Archiv.';

  @override
  String get dashboardEmptyLiveNoActivities => 'Keine Aktivität.';

  @override
  String get dashboardArchiveShow => 'Archiv';

  @override
  String get dashboardArchiveHide => 'Ausblenden';

  @override
  String dashboardArchiveShowCount(Object count) {
    return 'Archiv ($count)';
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
  String get dashboardProviderHealthTitle => 'Anbieter';

  @override
  String dashboardActivityFromAuthor(Object authorName) {
    return 'Von $authorName';
  }

  @override
  String get dashboardCardArchivedBadge => 'ARCHIVIERT';

  @override
  String get dashboardProviderHealthLive => 'Live';

  @override
  String get dashboardProviderHealthDegraded => 'Eingeschränkt';

  @override
  String get dashboardProviderHealthOffline => 'Offline';

  @override
  String get dashboardUpcomingSourceCalendar => 'Kalender';

  @override
  String get dashboardNoProviderActivity => 'Keine Aktivität.';

  @override
  String get dashboardNoSyncYet => 'Kein Sync';

  @override
  String dashboardLastSync(Object time) {
    return 'Sync $time';
  }

  @override
  String get dashboardUpcomingSoonTitle => 'Demnächst';

  @override
  String get dashboardUpcomingNoEvents => 'Keine Termine.';

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
  String get adminPublicApiUrlTitle => 'Public API URL';

  @override
  String get adminPublicApiUrlSubtitle =>
      'Reachable base URL for OAuth callbacks and webhook defaults (no trailing slash).';

  @override
  String get adminPublicApiUrlLabel => 'https://your-dab-api.example';

  @override
  String get adminPublicApiUrlSavedSnack => 'Public API URL saved';
}
