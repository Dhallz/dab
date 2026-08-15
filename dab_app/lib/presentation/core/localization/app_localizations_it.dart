// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get dashboardTitle => 'Pannello';

  @override
  String get dashboardIslandLive => 'Live';

  @override
  String get dashboardIslandArchived => 'Archiviato';

  @override
  String get dashboardFeedModeTimeline => 'Cronologia';

  @override
  String get dashboardFeedModeCategory => 'Categoria';

  @override
  String get dashboardFeedModeProvider => 'Provider';

  @override
  String get dashboardGroupEmptyQuiet => 'Silenzio — nessuna attività live';

  @override
  String get navExplorer => 'Esploratore';

  @override
  String get navAdmin => 'Amministrazione';

  @override
  String get explorerModeSingleDay => 'Giorno';

  @override
  String get explorerModeRange => 'Intervallo';

  @override
  String get explorerQuickToday => 'Oggi';

  @override
  String get explorerQuickWeek => 'Settimana';

  @override
  String get explorerPickRange => 'Scegli int.';

  @override
  String get explorerSectionDirectory => 'Rubrica';

  @override
  String get explorerSectionActivities => 'Attività';

  @override
  String get explorerSectionProviders => 'Fornitori';

  @override
  String get explorerDirectoryUsers => 'Utenti';

  @override
  String get explorerDirectoryGroups => 'Gruppi';

  @override
  String get explorerCreateGroup => 'Crea gruppo';

  @override
  String get explorerGroupActions => 'Azioni gruppo';

  @override
  String get explorerEditGroupMembers => 'Modifica membri';

  @override
  String get explorerSelectGroupMembers => 'Seleziona membri';

  @override
  String get explorerRenameGroup => 'Rinomina gruppo';

  @override
  String get explorerDeleteGroup => 'Elimina gruppo';

  @override
  String get explorerGroupNamePlaceholder => 'Nome gruppo';

  @override
  String get explorerCancel => 'Annulla';

  @override
  String get explorerSave => 'Salva';

  @override
  String get explorerActivityFilterCommit => 'Commit';

  @override
  String get explorerActivityFilterRevision => 'Revisioni';

  @override
  String get explorerActivityFilterTask => 'Attività';

  @override
  String get explorerActivityFilterMessage => 'Messaggi';

  @override
  String get explorerActivityFilterGeneric => 'Generico';

  @override
  String get activityKindComment => 'Commento';

  @override
  String get activityKindTag => 'Tag';

  @override
  String get activityKindStatus => 'Stato';

  @override
  String get activityKindReview => 'Revisione';

  @override
  String get activityKindAssignment => 'Assegnazione';

  @override
  String get activityKindCommit => 'Commit';

  @override
  String get activityKindMessage => 'Messaggio';

  @override
  String get activityKindActivity => 'Attività';

  @override
  String get insightsTitle => 'Analisi';

  @override
  String get insightsFiltersTitle => 'Filtri';

  @override
  String get insightsUsersSectionTitle => 'Utenti';

  @override
  String get insightsProvidersSectionTitle => 'Fornitori';

  @override
  String get insightsActivityTypesSectionTitle => 'Tipi di attività';

  @override
  String get insightsPresetToday => 'Oggi';

  @override
  String get insightsPresetLast7Days => 'Ult. 7 g';

  @override
  String get insightsPresetLast30Days => 'Ult. 30 g';

  @override
  String get insightsPresetCustom => 'Personalizzato';

  @override
  String get insightsKpiTotalActivities => 'Attività totali';

  @override
  String get insightsKpiActiveUsers => 'Utenti attivi';

  @override
  String get insightsKpiActiveProviders => 'Fornitori attivi';

  @override
  String get insightsKpiTopActivityType => 'Tipo principale';

  @override
  String get insightsTrendTitle => 'Andamento attività';

  @override
  String get insightsBreakdownProviders => 'Per fornitore';

  @override
  String get insightsBreakdownActivityTypes => 'Per tipo';

  @override
  String get insightsBreakdownTopUsers => 'Utenti principali';

  @override
  String get insightsDetailsTitle => 'Dettagli';

  @override
  String get insightsNoData => 'Nessun dato';

  @override
  String get insightsNoDataForFilters =>
      'Nessun dato per i filtri selezionati.';

  @override
  String get insightsErrorLoading => 'Impossibile caricare gli insights.';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get logoutTitle => 'Esci';

  @override
  String get settingsSectionAppearance => 'Aspetto';

  @override
  String get settingsSectionLanguage => 'Lingua';

  @override
  String get settingsSectionAbout => 'Informazioni';

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
  String get settingsThemeLight => 'Chiaro';

  @override
  String get settingsThemeDab => 'DAB';

  @override
  String get settingsThemeDark => 'Scuro';

  @override
  String get settingsLanguageSystemDefault => 'Predefinito di sistema';

  @override
  String get settingsLanguageEnglish => 'Inglese';

  @override
  String get settingsLanguageSpanish => 'Spagnolo';

  @override
  String get settingsLanguageFrench => 'Francese';

  @override
  String get settingsLanguageGerman => 'Tedesco';

  @override
  String get settingsLanguagePortuguese => 'Portoghese';

  @override
  String get settingsLanguageItalian => 'Italiano';

  @override
  String get settingsVersionLabel => 'Versione';

  @override
  String get settingsSave => 'Salva';

  @override
  String get settingsClose => 'Chiudi';

  @override
  String get settingsSavedMessage => 'Impostazioni salvate';

  @override
  String get brandTagline => 'Dev Activity Board';

  @override
  String get brandShortName => 'DAB';

  @override
  String get navFeed => 'Attività';

  @override
  String get commonCancel => 'Annulla';

  @override
  String get commonOpen => 'Apri';

  @override
  String get commonDismiss => 'Ignora';

  @override
  String get commonTry => 'Riprova';

  @override
  String get commonOr => 'OPPURE';

  @override
  String get commonPasswordMaskHint => '••••••••';

  @override
  String get authWelcomeBack => 'Bentornato';

  @override
  String get authCreateAccount => 'Crea account';

  @override
  String get authSignInWithSso => 'Accedi con SSO aziendale';

  @override
  String get authLabelName => 'Nome';

  @override
  String get authHintName => 'Nome e cognome';

  @override
  String get authLabelEmail => 'Email';

  @override
  String get authHintEmail => 'tu@azienda.it';

  @override
  String get authLabelPassword => 'Password';

  @override
  String get authSignIn => 'Accedi';

  @override
  String get authRegister => 'Registrati';

  @override
  String get authToggleRegister => 'Non hai un account? Registrati';

  @override
  String get authToggleSignIn => 'Hai già un account? Accedi';

  @override
  String get adminNavManagement => 'GESTIONE';

  @override
  String get adminNavProviders => 'Fornitori';

  @override
  String get adminNavIdentities => 'Identità';

  @override
  String get adminNavSecurity => 'Sicurezza';

  @override
  String get adminSectionProvidersTitle => 'Fornitori';

  @override
  String get adminSectionIdentitiesTitle => 'Identità';

  @override
  String get adminSectionSecurityTitle => 'Sicurezza di sistema';

  @override
  String get adminSectionProvidersSubtitle =>
      'Definisci e gestisci le connessioni ai servizi esterni.';

  @override
  String get adminSectionIdentitiesSubtitle =>
      'Risolvi e collega le identità della piattaforma agli utenti.';

  @override
  String get adminSectionSecuritySubtitle =>
      'Gestisci i ruoli utente e la sicurezza del deployment.';

  @override
  String get adminIdentitiesSectionTitle => 'IDENTITÀ ESTERNE';

  @override
  String get adminIdentitiesSearchHint => 'Cerca identità…';

  @override
  String get adminIdentitiesCreateLink => 'Crea collegamento';

  @override
  String get adminIdentitiesEmpty => 'Nessuna identità trovata';

  @override
  String get adminTableFullName => 'Nome completo';

  @override
  String get adminTableProvider => 'Fornitore';

  @override
  String get adminTableExternalId => 'ID esterno';

  @override
  String get adminTableProviderUsername => 'Utente fornitore';

  @override
  String get adminTableStatus => 'Stato';

  @override
  String get adminTableActions => 'Azioni';

  @override
  String get adminTooltipAddUsername => 'Aggiungi nome utente fornitore';

  @override
  String get adminSecuritySectionTitle => 'GESTIONE UTENTI';

  @override
  String get adminSecuritySearchHint => 'Cerca per nome o email';

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
  String get adminIslandProvidersTitle => 'Fornitori';

  @override
  String get adminIslandProvidersTooltip => 'Fornitori attivi / totali';

  @override
  String get adminIslandUnresolvedTitle => 'Non risolte';

  @override
  String get adminIslandUnresolvedTooltip => 'Identità non collegate';

  @override
  String get adminIslandUsersTitle => 'Utenti';

  @override
  String get adminIslandUsersTooltip => 'Utenti registrati';

  @override
  String get adminIslandLinksOkTitle => 'Collegamenti OK';

  @override
  String get adminIslandLinksOkTooltip =>
      'Fornitori attivi con test di connessione riuscito';

  @override
  String get adminIslandLinksOkTooltipPersonal =>
      'Active providers with OAuth app or bot credentials saved';

  @override
  String get adminIslandFailedTitle => 'Errori';

  @override
  String get adminIslandFailedTooltip => 'Errori di connessione';

  @override
  String get adminIslandFailedTooltipPersonal =>
      'Active providers missing OAuth client credentials or bot token';

  @override
  String get adminIslandPendingTitle => 'In attesa';

  @override
  String get adminIslandPendingTooltip => 'Non testati o in corso';

  @override
  String get adminIslandRefreshTooltip => 'Aggiorna dati admin';

  @override
  String get adminIslandRefreshLabel => 'AGGIORNA';

  @override
  String get adminBootstrapLockTitle => 'Blocco bootstrap: ATTIVO';

  @override
  String get adminBootstrapLockSubtitle =>
      'Il sistema è bloccato e richiede un account amministrativo.';

  @override
  String get adminUserRoleAdmin => 'ADMIN';

  @override
  String get adminUserRoleManager => 'MANAGER';

  @override
  String get adminUserRoleStandard => 'STANDARD';

  @override
  String get identityDialogCreateTitle => 'Crea collegamento identità';

  @override
  String get identityDialogUpdateTitle => 'Aggiorna collegamento identità';

  @override
  String get identityDialogCreateSubtitle =>
      'Collega un\'identità esterna del fornitore a un utente DAB.';

  @override
  String get identityFieldDabUser => 'Utente DAB';

  @override
  String get identityFieldProvider => 'Fornitore';

  @override
  String get identityFieldExternalId =>
      'ID esterno (es. login GitHub, PHID phorge)';

  @override
  String get identityFieldProviderUsernameOptional =>
      'Nome utente fornitore (opzionale, es. dlimier)';

  @override
  String get identityCreateLink => 'Crea collegamento';

  @override
  String get identityUpdateLink => 'Aggiorna collegamento';

  @override
  String get identityDeleteLink => 'Delete Link';

  @override
  String get identityDeleteLinkConfirmTitle => 'Delete identity link?';

  @override
  String get identityDeleteLinkConfirmMessage =>
      'Remove the link between this DAB user and the provider identity.';

  @override
  String identityLinkAssociateUser(Object externalId) {
    return 'Associa $externalId a un account utente DAB.';
  }

  @override
  String get identityTargetUserId => 'ID utente di destinazione';

  @override
  String get identityProviderUsernameOptionalLabel =>
      'Nome utente fornitore (opzionale)';

  @override
  String get providerCardShowFields => 'Mostra campi';

  @override
  String get providerCardHideFields => 'Nascondi campi';

  @override
  String get providerCardMultilineHint =>
      'Un valore per riga (anche separati da virgola).';

  @override
  String get providerCardSaveCredentials => 'Salva credenziali fornitore';

  @override
  String providerCardEnterField(Object fieldLabel) {
    return 'Inserisci $fieldLabel…';
  }

  @override
  String get adminFieldApiToken => 'Token API';

  @override
  String get adminFieldBaseUrl => 'URL base';

  @override
  String get adminFieldApiKey => 'Chiave API';

  @override
  String get adminFieldAtlassianEmail => 'Email Atlassian';

  @override
  String get adminFieldJiraInstanceUrl =>
      'URL istanza Jira (es. azienda.atlassian.net)';

  @override
  String get adminFieldApplicationClientId => 'ID applicazione (client)';

  @override
  String get adminFieldClientSecret => 'Secret client';

  @override
  String get adminFieldDirectoryTenantId => 'ID directory (tenant)';

  @override
  String get adminFieldBotToken => 'Token bot';

  @override
  String get adminFieldSigningSecret => 'Secret firma';

  @override
  String get adminFieldWorkspaceTeamId => 'ID workspace/team (es. T0123456789)';

  @override
  String get adminFieldChannelIdsOnePerLine => 'ID canale (uno per riga)';

  @override
  String get adminFieldSlackApiBaseOptional =>
      'URL base API (opzionale, predefinito https://slack.com/api)';

  @override
  String get adminFieldGuildServerId => 'ID guild (server)';

  @override
  String get adminFieldPersonalAccessToken => 'Token di accesso personale';

  @override
  String get adminFieldWebhookSecret => 'Secret webhook';

  @override
  String get adminFieldWebhookEndpointUrl => 'URL endpoint webhook';

  @override
  String adminFieldWebhookEndpointUrlHint(String defaultUrl) {
    return 'Predefinito: $defaultUrl. Modifica per un URL pubblico diverso per questo provider.';
  }

  @override
  String get adminFieldRepositoryOwner => 'Proprietario repository';

  @override
  String get adminFieldRepositoryName => 'Nome repository';

  @override
  String get adminFieldBranchOptional =>
      'Branch (opzionale, predefinito del repo)';

  @override
  String get adminFieldRepositoriesOnePerLine =>
      'Repository (un owner/repo per riga, opzionale)';

  @override
  String get adminFieldGithubApiBaseOptional =>
      'URL base API (opzionale, predefinito https://api.github.com)';

  @override
  String get adminFieldGitLabInstanceUrl =>
      'URL istanza GitLab (es. gitlab.com)';

  @override
  String get adminFieldApiTokenOrSecret => 'Token API / secret';

  @override
  String get dashboardLiveNowTitle => 'In diretta';

  @override
  String dashboardLiveUpdated(Object relativeTime) {
    return 'Live · agg. $relativeTime';
  }

  @override
  String commonTimeAgoSeconds(Object n) {
    return '${n}s fa';
  }

  @override
  String commonTimeAgoMinutes(Object n) {
    return '$n min fa';
  }

  @override
  String dashboardReconnectNotice(Object time) {
    return 'Riconnesso — $time';
  }

  @override
  String get dashboardFailedLoadLive => 'Caricamento non riuscito.';

  @override
  String get dashboardEmptyLiveCaughtUp => 'Tutto letto — archivio.';

  @override
  String get dashboardEmptyLiveNoActivities => 'Nessuna attività.';

  @override
  String get dashboardArchiveShow => 'Archivio';

  @override
  String get dashboardArchiveHide => 'Nascondi arch.';

  @override
  String dashboardArchiveShowCount(Object count) {
    return 'Archivio ($count)';
  }

  @override
  String get activityTooltipArchive => 'Archivia';

  @override
  String get activityTooltipUnarchive => 'Ripristina';

  @override
  String activitySemanticsActive(Object title) {
    return 'Attività: $title';
  }

  @override
  String activitySemanticsArchived(Object title) {
    return 'Attività archiviata: $title';
  }

  @override
  String get explorerCouldNotLaunchUrl => 'Impossibile aprire l\'URL';

  @override
  String explorerTooltipCategory(Object category) {
    return 'Categoria: $category';
  }

  @override
  String explorerTooltipSource(Object name) {
    return 'Origine: $name';
  }

  @override
  String get explorerCreateGroupSubmit => 'Crea gruppo';

  @override
  String get explorerCreateNewGroupTitle => 'Nuovo gruppo';

  @override
  String get explorerGroupNameSectionLabel => 'NOME GRUPPO';

  @override
  String get explorerSelectMembersSectionLabel => 'SELEZIONA MEMBRI';

  @override
  String get explorerGroupNameHintExample => 'es. Team mobile';

  @override
  String get settingsVersionPlaceholder => '1.0.0';

  @override
  String get dashboardProviderHealthTitle => 'Stato forn.';

  @override
  String dashboardActivityFromAuthor(Object authorName) {
    return 'Da $authorName';
  }

  @override
  String get dashboardCardArchivedBadge => 'ARCHIVIATO';

  @override
  String get dashboardProviderHealthLive => 'Online';

  @override
  String get dashboardProviderHealthDegraded => 'Degradato';

  @override
  String get dashboardProviderHealthOffline => 'Offline';

  @override
  String get dashboardNoProviderActivity => 'Nessuna attività.';

  @override
  String get dashboardNoSyncYet => 'Mai sincr.';

  @override
  String dashboardLastSync(Object time) {
    return 'Ult. sync $time';
  }

  @override
  String get authErrorFailed => 'Autenticazione non riuscita';

  @override
  String get appBrandShortName => 'DAB';

  @override
  String get appWindowTitle => 'DAB App';

  @override
  String dashboardRelativeDaysAgo(Object n) {
    return '${n}g fa';
  }

  @override
  String dashboardRelativeHoursAgo(Object n) {
    return '${n}h fa';
  }

  @override
  String dashboardRelativeMinutesAgo(Object n) {
    return '$n min fa';
  }

  @override
  String get dashboardRelativeJustNow => 'proprio ora';

  @override
  String get explorerNoActivitiesFound => 'Nessuna attività trovata.';

  @override
  String get explorerNoActivitiesForDate => 'Nessuna attività per questa data.';

  @override
  String explorerViewingArchivedFromRange(Object count) {
    return 'Visualizzi $count attività archiviate da questo intervallo.';
  }

  @override
  String explorerViewingArchivedFromDate(Object count) {
    return 'Visualizzi $count attività archiviate da questa data.';
  }

  @override
  String get explorerJumpToDateTooltip => 'Vai alla data';

  @override
  String get explorerClearCacheRefreshTooltip => 'Clear cache and refresh';

  @override
  String get explorerSectionActivityProviders => 'FORNITORI ATTIVITÀ';

  @override
  String get adminConnectionConnected => 'Connesso';

  @override
  String get adminConnectionDisconnected => 'Disconnesso';

  @override
  String get adminConnectionTimedOut => 'Connessione scaduta';

  @override
  String get adminIdentityStatusLinked => 'COLLEGATO';

  @override
  String get adminIdentityStatusPending => 'IN ATTESA';

  @override
  String get adminIdentityStatusFailed => 'FALLITO';

  @override
  String get activityCategoryAbbrevCommit => 'COMMIT';

  @override
  String get activityCategoryAbbrevRevision => 'REVISIONE';

  @override
  String get activityCategoryAbbrevTask => 'TASK';

  @override
  String get activityCategoryAbbrevMessage => 'MESSAGGIO';

  @override
  String get activityCategoryAbbrevGeneric => 'ATTIVITÀ';

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
