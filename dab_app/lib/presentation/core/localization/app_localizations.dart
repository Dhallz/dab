import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('pt'),
  ];

  /// dashboardTitle: Dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// Toolbar/sidebar label for visible live activity count.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get dashboardIslandLive;

  /// Toolbar/sidebar count for the directed-at-you inbox pane.
  ///
  /// In en, this message translates to:
  /// **'Directed'**
  String get dashboardIslandDirected;

  /// Toolbar/sidebar count for the Follow inbox pane.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get dashboardIslandFollowing;

  /// Toolbar/sidebar label for archived activity count.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get dashboardIslandArchived;

  /// Dashboard toolbar chip — chronological Live Now list.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get dashboardFeedModeTimeline;

  /// Dashboard toolbar chip — group Live Now by activity category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get dashboardFeedModeCategory;

  /// Dashboard toolbar chip — group Live Now by provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get dashboardFeedModeProvider;

  /// Empty-state hint inside a Dashboard provider/category container with no visible activities.
  ///
  /// In en, this message translates to:
  /// **'Quiet — no live activities'**
  String get dashboardGroupEmptyQuiet;

  /// navExplorer: Explorer
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get navExplorer;

  /// Home tab for personal daily-report authoring.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// Label for the current org-calendar day in the Reports date list.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get reportsDateToday;

  /// Sidebar section title for the dated report list.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsSectionReports;

  /// Empty state when the selected person has no saved daily reports.
  ///
  /// In en, this message translates to:
  /// **'No reports yet'**
  String get reportsNoSavedReports;

  /// Reports toolbar action — copy Markdown to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get reportsCopy;

  /// Reports toolbar action — persist the open daily report.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get reportsSave;

  /// SnackBar after a successful daily-report save.
  ///
  /// In en, this message translates to:
  /// **'Report saved'**
  String get reportsSaved;

  /// Toolbar chip when the open own daily report is past the Admin deadline.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get reportsLockedChip;

  /// Toolbar chip when the open own daily report can still be edited.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get reportsUnlockedChip;

  /// Toolbar chip counting down to the Admin daily-report deadline.
  ///
  /// In en, this message translates to:
  /// **'Locks in {remaining}'**
  String reportsLockCountdown(String remaining);

  /// Banner on an own daily report that can no longer be edited.
  ///
  /// In en, this message translates to:
  /// **'Editing closed at {time} on {date} ({timezone}).'**
  String reportsLockedBanner(String time, String date, String timezone);

  /// Reports toolbar action — download Markdown as a .md file.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get reportsDownload;

  /// SnackBar after copying the daily-report Markdown.
  ///
  /// In en, this message translates to:
  /// **'Copied Markdown'**
  String get reportsCopied;

  /// SnackBar after downloading the daily-report Markdown.
  ///
  /// In en, this message translates to:
  /// **'Saved {path}'**
  String reportsDownloaded(String path);

  /// Hint on a report line note field. Notes stay in DAB.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get reportsNoteHint;

  /// Empty state when today's Directed ∪ authored pool is empty.
  ///
  /// In en, this message translates to:
  /// **'No activity for today yet'**
  String get reportsEmpty;

  /// Empty state when a teammate has no saved report for the selected day.
  ///
  /// In en, this message translates to:
  /// **'No report for this day'**
  String get reportsTeamEmpty;

  /// Reports search field — pick extra activities onto today's report.
  ///
  /// In en, this message translates to:
  /// **'Add an activity…'**
  String get reportsSearchHint;

  /// Empty overlay when Reports activity search returns no rows.
  ///
  /// In en, this message translates to:
  /// **'No matching activities'**
  String get reportsSearchEmpty;

  /// Chip for inbound report lines.
  ///
  /// In en, this message translates to:
  /// **'Directed'**
  String get reportsRoleDirected;

  /// Chip for activity the signed-in user did.
  ///
  /// In en, this message translates to:
  /// **'Authored'**
  String get reportsRoleAuthored;

  /// Chip when a line is both inbound and authored.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get reportsRoleBoth;

  /// navAdmin: Admin
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get navAdmin;

  /// explorerModeSingleDay: Day
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get explorerModeSingleDay;

  /// explorerModeRange: Range
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get explorerModeRange;

  /// explorerQuickToday: Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get explorerQuickToday;

  /// explorerQuickWeek: Week
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get explorerQuickWeek;

  /// explorerPickRange: Pick range
  ///
  /// In en, this message translates to:
  /// **'Pick range'**
  String get explorerPickRange;

  /// explorerSectionDirectory: Directory
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get explorerSectionDirectory;

  /// explorerSectionActivities: Activities
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get explorerSectionActivities;

  /// explorerSectionProviders: Providers
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get explorerSectionProviders;

  /// explorerDirectoryUsers: Users
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get explorerDirectoryUsers;

  /// explorerDirectoryGroups: Groups
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get explorerDirectoryGroups;

  /// explorerCreateGroup: Create group
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get explorerCreateGroup;

  /// explorerGroupActions: Group actions
  ///
  /// In en, this message translates to:
  /// **'Group actions'**
  String get explorerGroupActions;

  /// explorerEditGroupMembers: Edit group members
  ///
  /// In en, this message translates to:
  /// **'Edit group members'**
  String get explorerEditGroupMembers;

  /// explorerSelectGroupMembers: Select members
  ///
  /// In en, this message translates to:
  /// **'Select members'**
  String get explorerSelectGroupMembers;

  /// explorerRenameGroup: Rename group
  ///
  /// In en, this message translates to:
  /// **'Rename group'**
  String get explorerRenameGroup;

  /// explorerDeleteGroup: Delete group
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get explorerDeleteGroup;

  /// explorerGroupNamePlaceholder: Group name
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get explorerGroupNamePlaceholder;

  /// explorerCancel: Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get explorerCancel;

  /// explorerSave: Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get explorerSave;

  /// explorerActivityFilterCommit: Commits
  ///
  /// In en, this message translates to:
  /// **'Commits'**
  String get explorerActivityFilterCommit;

  /// explorerActivityFilterRevision: Revisions
  ///
  /// In en, this message translates to:
  /// **'Revisions'**
  String get explorerActivityFilterRevision;

  /// explorerActivityFilterTask: Tasks
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get explorerActivityFilterTask;

  /// explorerActivityFilterMessage: Messages
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get explorerActivityFilterMessage;

  /// explorerActivityFilterGeneric: Generic
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get explorerActivityFilterGeneric;

  /// activityKindComment: Comment
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get activityKindComment;

  /// activityKindTag: Tag
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get activityKindTag;

  /// activityKindStatus: Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get activityKindStatus;

  /// activityKindReview: Review
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get activityKindReview;

  /// activityKindAssignment: Assignment
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get activityKindAssignment;

  /// activityKindCommit: Commit
  ///
  /// In en, this message translates to:
  /// **'Commit'**
  String get activityKindCommit;

  /// activityKindMessage: Message
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get activityKindMessage;

  /// activityKindActivity: Activity
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityKindActivity;

  /// insightsTitle: Insights
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// insightsFiltersTitle: Filters
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get insightsFiltersTitle;

  /// insightsUsersSectionTitle: Users
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get insightsUsersSectionTitle;

  /// insightsProvidersSectionTitle: Providers
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get insightsProvidersSectionTitle;

  /// insightsActivityTypesSectionTitle: Activity types
  ///
  /// In en, this message translates to:
  /// **'Activity types'**
  String get insightsActivityTypesSectionTitle;

  /// insightsPresetToday: Today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get insightsPresetToday;

  /// insightsPresetLast7Days: Last 7d
  ///
  /// In en, this message translates to:
  /// **'Last 7d'**
  String get insightsPresetLast7Days;

  /// insightsPresetLast30Days: Last 30d
  ///
  /// In en, this message translates to:
  /// **'Last 30d'**
  String get insightsPresetLast30Days;

  /// insightsPresetCustom: Custom
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get insightsPresetCustom;

  /// insightsKpiTotalActivities: Total activities
  ///
  /// In en, this message translates to:
  /// **'Total activities'**
  String get insightsKpiTotalActivities;

  /// insightsKpiActiveUsers: Active users
  ///
  /// In en, this message translates to:
  /// **'Active users'**
  String get insightsKpiActiveUsers;

  /// insightsKpiActiveProviders: Active providers
  ///
  /// In en, this message translates to:
  /// **'Active providers'**
  String get insightsKpiActiveProviders;

  /// insightsKpiTopActivityType: Top activity type
  ///
  /// In en, this message translates to:
  /// **'Top activity type'**
  String get insightsKpiTopActivityType;

  /// insightsTrendTitle: Activity trend
  ///
  /// In en, this message translates to:
  /// **'Activity trend'**
  String get insightsTrendTitle;

  /// insightsBreakdownProviders: By provider
  ///
  /// In en, this message translates to:
  /// **'By provider'**
  String get insightsBreakdownProviders;

  /// insightsBreakdownActivityTypes: By activity type
  ///
  /// In en, this message translates to:
  /// **'By activity type'**
  String get insightsBreakdownActivityTypes;

  /// insightsBreakdownTopUsers: Top users
  ///
  /// In en, this message translates to:
  /// **'Top users'**
  String get insightsBreakdownTopUsers;

  /// insightsDetailsTitle: Details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get insightsDetailsTitle;

  /// insightsNoData: No data
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get insightsNoData;

  /// insightsNoDataForFilters: No data for selected filters.
  ///
  /// In en, this message translates to:
  /// **'No data for selected filters.'**
  String get insightsNoDataForFilters;

  /// insightsErrorLoading: Unable to load insights.
  ///
  /// In en, this message translates to:
  /// **'Unable to load insights.'**
  String get insightsErrorLoading;

  /// settingsTitle: Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// logoutTitle: Log out
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logoutTitle;

  /// settingsSectionAppearance: Appearance
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// Settings toggle for local Directed/Following banners while DAB is running.
  ///
  /// In en, this message translates to:
  /// **'Inbox banners'**
  String get settingsInboxNotifications;

  /// Helper text for the inbox banners settings toggle.
  ///
  /// In en, this message translates to:
  /// **'Show a banner for Directed and Following when the window is in the background.'**
  String get settingsInboxNotificationsSubtitle;

  /// Generic remote-wake notification title. Unused until mobile FCM.
  ///
  /// In en, this message translates to:
  /// **'DAB'**
  String get inboxWakeAppName;

  /// Generic remote-wake body for Directed. Unused until mobile FCM.
  ///
  /// In en, this message translates to:
  /// **'New directed activity'**
  String get inboxWakeDirected;

  /// Generic remote-wake body for Following. Unused until mobile FCM.
  ///
  /// In en, this message translates to:
  /// **'Update on something you follow'**
  String get inboxWakeFollowing;

  /// Local banner subtitle for Directed inbox activities.
  ///
  /// In en, this message translates to:
  /// **'Directed'**
  String get inboxNotificationDirected;

  /// Local banner subtitle for Following inbox activities.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get inboxNotificationFollowing;

  /// settingsSectionLanguage: Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// settingsSectionAbout: About
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// settingsSectionExplorerCache: Explorer cache section title
  ///
  /// In en, this message translates to:
  /// **'Explorer cache'**
  String get settingsSectionExplorerCache;

  /// settingsExplorerCacheDescription: Helper text for Explorer cache controls
  ///
  /// In en, this message translates to:
  /// **'Remove cached Explorer activities for selected providers and dates. The next browse refetches from provider APIs.'**
  String get settingsExplorerCacheDescription;

  /// settingsExplorerCacheDateRange: Date range label
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get settingsExplorerCacheDateRange;

  /// settingsExplorerCacheProviders: Provider checklist label
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get settingsExplorerCacheProviders;

  /// settingsExplorerCacheSelectAll: Select all providers action
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get settingsExplorerCacheSelectAll;

  /// settingsExplorerCacheClearSelection: Clear provider selection action
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get settingsExplorerCacheClearSelection;

  /// settingsExplorerCacheClearButton: Clear cache button label
  ///
  /// In en, this message translates to:
  /// **'Clear cache'**
  String get settingsExplorerCacheClearButton;

  /// settingsExplorerCacheConfirmTitle: Confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Clear Explorer cache?'**
  String get settingsExplorerCacheConfirmTitle;

  /// settingsExplorerCacheConfirmMessage: Confirmation dialog body
  ///
  /// In en, this message translates to:
  /// **'Remove cached Explorer data from {startDate} through {endDate} for: {providers}.'**
  String settingsExplorerCacheConfirmMessage(
    String startDate,
    String endDate,
    String providers,
  );

  /// settingsExplorerCacheSuccess: Snackbar after successful clear
  ///
  /// In en, this message translates to:
  /// **'Cleared {count} cached Explorer entries.'**
  String settingsExplorerCacheSuccess(int count);

  /// settingsExplorerCacheFailure: Snackbar when clear fails
  ///
  /// In en, this message translates to:
  /// **'Unable to clear Explorer cache.'**
  String get settingsExplorerCacheFailure;

  /// settingsExplorerCacheNoProviders: Empty state when no providers
  ///
  /// In en, this message translates to:
  /// **'No active providers are configured.'**
  String get settingsExplorerCacheNoProviders;

  /// settingsExplorerCacheSelectProvider: Validation when none selected
  ///
  /// In en, this message translates to:
  /// **'Select at least one provider.'**
  String get settingsExplorerCacheSelectProvider;

  /// settingsThemeLight: Light
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// settingsThemeDab: DAB
  ///
  /// In en, this message translates to:
  /// **'DAB'**
  String get settingsThemeDab;

  /// settingsThemeDark: Dark
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// settingsLanguageSystemDefault: System default
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystemDefault;

  /// settingsLanguageEnglish: English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// settingsLanguageSpanish: Spanish
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settingsLanguageSpanish;

  /// settingsLanguageFrench: French
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFrench;

  /// settingsLanguageGerman: German
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLanguageGerman;

  /// settingsLanguagePortuguese: Portuguese
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get settingsLanguagePortuguese;

  /// settingsLanguageItalian: Italian
  ///
  /// In en, this message translates to:
  /// **'Italian'**
  String get settingsLanguageItalian;

  /// settingsVersionLabel: Version
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionLabel;

  /// settingsSave: Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

  /// settingsClose: Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsClose;

  /// settingsSavedMessage: Settings saved
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSavedMessage;

  /// brandTagline: Dev Activity Board
  ///
  /// In en, this message translates to:
  /// **'Dev Activity Board'**
  String get brandTagline;

  /// brandShortName: DAB
  ///
  /// In en, this message translates to:
  /// **'DAB'**
  String get brandShortName;

  /// navFeed: Feed
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get navFeed;

  /// commonCancel: Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// commonOpen: Open
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// commonDismiss: Dismiss
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get commonDismiss;

  /// commonTry: Try
  ///
  /// In en, this message translates to:
  /// **'Try'**
  String get commonTry;

  /// commonOr: OR
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get commonOr;

  /// commonPasswordMaskHint: ••••••••
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get commonPasswordMaskHint;

  /// authWelcomeBack: Welcome Back
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get authWelcomeBack;

  /// authCreateAccount: Create Account
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// authSignInWithSso: Sign in with Company SSO
  ///
  /// In en, this message translates to:
  /// **'Sign in with Company SSO'**
  String get authSignInWithSso;

  /// authLabelName: Name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get authLabelName;

  /// authHintName: Your full name
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get authHintName;

  /// authLabelEmail: Email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authLabelEmail;

  /// authHintEmail: you@company.com
  ///
  /// In en, this message translates to:
  /// **'you@company.com'**
  String get authHintEmail;

  /// authLabelPassword: Password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authLabelPassword;

  /// authSignIn: Sign In
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// authRegister: Register
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authRegister;

  /// authToggleRegister: Don't have an account? Register
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Register'**
  String get authToggleRegister;

  /// authToggleSignIn: Already have an account? Sign In
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign In'**
  String get authToggleSignIn;

  /// adminNavManagement: MANAGEMENT
  ///
  /// In en, this message translates to:
  /// **'MANAGEMENT'**
  String get adminNavManagement;

  /// adminNavProviders: Providers
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get adminNavProviders;

  /// adminNavIdentities: Identities
  ///
  /// In en, this message translates to:
  /// **'Identities'**
  String get adminNavIdentities;

  /// adminNavSecurity: Security
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get adminNavSecurity;

  /// adminSectionProvidersTitle: Provider Config
  ///
  /// In en, this message translates to:
  /// **'Provider Config'**
  String get adminSectionProvidersTitle;

  /// adminSectionIdentitiesTitle: Identity Management
  ///
  /// In en, this message translates to:
  /// **'Identity Management'**
  String get adminSectionIdentitiesTitle;

  /// adminSectionSecurityTitle: System Security
  ///
  /// In en, this message translates to:
  /// **'System Security'**
  String get adminSectionSecurityTitle;

  /// adminSectionProvidersSubtitle: Define and manage external service connections.
  ///
  /// In en, this message translates to:
  /// **'Define and manage external service connections.'**
  String get adminSectionProvidersSubtitle;

  /// adminSectionIdentitiesSubtitle: Resolve and link platform identities to users.
  ///
  /// In en, this message translates to:
  /// **'Resolve and link platform identities to users.'**
  String get adminSectionIdentitiesSubtitle;

  /// adminSectionSecuritySubtitle: Manage user roles and deployment security.
  ///
  /// In en, this message translates to:
  /// **'Manage user roles and deployment security.'**
  String get adminSectionSecuritySubtitle;

  /// adminIdentitiesSectionTitle: EXTERNAL IDENTITIES
  ///
  /// In en, this message translates to:
  /// **'EXTERNAL IDENTITIES'**
  String get adminIdentitiesSectionTitle;

  /// adminIdentitiesSearchHint: Search identities…
  ///
  /// In en, this message translates to:
  /// **'Search identities…'**
  String get adminIdentitiesSearchHint;

  /// adminIdentitiesCreateLink: Create Link
  ///
  /// In en, this message translates to:
  /// **'Create Link'**
  String get adminIdentitiesCreateLink;

  /// adminIdentitiesEmpty: No identities found
  ///
  /// In en, this message translates to:
  /// **'No identities found'**
  String get adminIdentitiesEmpty;

  /// adminTableFullName: Full Name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get adminTableFullName;

  /// adminTableProvider: Provider
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get adminTableProvider;

  /// adminTableExternalId: External ID
  ///
  /// In en, this message translates to:
  /// **'External ID'**
  String get adminTableExternalId;

  /// adminTableProviderUsername: Provider Username
  ///
  /// In en, this message translates to:
  /// **'Provider Username'**
  String get adminTableProviderUsername;

  /// adminTableStatus: Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminTableStatus;

  /// adminTableActions: Actions
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get adminTableActions;

  /// adminTooltipAddUsername: Add provider username
  ///
  /// In en, this message translates to:
  /// **'Add provider username'**
  String get adminTooltipAddUsername;

  /// adminSecuritySectionTitle: USER MANAGEMENT
  ///
  /// In en, this message translates to:
  /// **'USER MANAGEMENT'**
  String get adminSecuritySectionTitle;

  /// adminSecuritySearchHint: Search by name or email
  ///
  /// In en, this message translates to:
  /// **'Search by name or email'**
  String get adminSecuritySearchHint;

  /// adminDomainValidationTitle: Domain Validation
  ///
  /// In en, this message translates to:
  /// **'Domain Validation'**
  String get adminDomainValidationTitle;

  /// adminDomainValidationSubtitle: Restrict account creation to a specific email domain.
  ///
  /// In en, this message translates to:
  /// **'Restrict account creation to a specific email domain.'**
  String get adminDomainValidationSubtitle;

  /// adminDomainValidationToggle: Enforce allowed email domain
  ///
  /// In en, this message translates to:
  /// **'Enforce allowed email domain'**
  String get adminDomainValidationToggle;

  /// adminAllowedDomainLabel: Allowed Email Domain
  ///
  /// In en, this message translates to:
  /// **'Allowed Email Domain'**
  String get adminAllowedDomainLabel;

  /// adminAllowedDomainHint: e.g. acme.com
  ///
  /// In en, this message translates to:
  /// **'e.g. acme.com'**
  String get adminAllowedDomainHint;

  /// adminSaveDomain: Save Domain
  ///
  /// In en, this message translates to:
  /// **'Save Domain'**
  String get adminSaveDomain;

  /// adminDomainSavedSnack: Allowed domain updated successfully
  ///
  /// In en, this message translates to:
  /// **'Allowed domain updated successfully'**
  String get adminDomainSavedSnack;

  /// Title for organization timezone settings on Admin Security tab
  ///
  /// In en, this message translates to:
  /// **'Organization timezone'**
  String get adminOrgTimezoneTitle;

  /// Subtitle for organization timezone settings
  ///
  /// In en, this message translates to:
  /// **'Calendar days in Explorer, Insights, and the live feed follow this timezone.'**
  String get adminOrgTimezoneSubtitle;

  /// Label for organization timezone dropdown
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get adminOrgTimezoneLabel;

  /// Snack bar after saving organization timezone
  ///
  /// In en, this message translates to:
  /// **'Organization timezone updated. Explorer cache was cleared.'**
  String get adminTimezoneSavedSnack;

  /// Title for the global daily-report edit deadline on Admin Security.
  ///
  /// In en, this message translates to:
  /// **'Report deadline'**
  String get adminReportDeadlineTitle;

  /// Subtitle for the global daily-report deadline panel.
  ///
  /// In en, this message translates to:
  /// **'How long after a report date teammates can still edit that day’s report. Times use the organization timezone.'**
  String get adminReportDeadlineSubtitle;

  /// Label for the day offset of the daily-report deadline.
  ///
  /// In en, this message translates to:
  /// **'Lock on'**
  String get adminReportDeadlineOffsetLabel;

  /// Deadline offset option: cutoff falls on the report’s own date.
  ///
  /// In en, this message translates to:
  /// **'The report day'**
  String get adminReportDeadlineOffsetReportDay;

  /// Deadline offset option: cutoff falls on the following calendar day.
  ///
  /// In en, this message translates to:
  /// **'The next day'**
  String get adminReportDeadlineOffsetNextDay;

  /// Deadline offset option for 2+ days after the report date.
  ///
  /// In en, this message translates to:
  /// **'{count} days after the report date'**
  String adminReportDeadlineOffsetDaysLater(int count);

  /// Label for the wall-clock time of the daily-report deadline.
  ///
  /// In en, this message translates to:
  /// **'At'**
  String get adminReportDeadlineTimeLabel;

  /// Live preview of the configured daily-report deadline.
  ///
  /// In en, this message translates to:
  /// **'A report can be edited until {time} on {when}.'**
  String adminReportDeadlinePreview(String time, String when);

  /// Snack bar after saving the global daily-report deadline.
  ///
  /// In en, this message translates to:
  /// **'Report deadline updated.'**
  String get adminReportDeadlineSavedSnack;

  /// adminNonCompliantAccountsWarning: warning header listing accounts outside the allowed domain
  ///
  /// In en, this message translates to:
  /// **'Accounts outside the allowed domain (existing accounts keep working):'**
  String get adminNonCompliantAccountsWarning;

  /// adminAddUser: Add User
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get adminAddUser;

  /// userDialogCreateTitle: Add User
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get userDialogCreateTitle;

  /// userDialogCreateSubtitle: Create a new account. The user will sign in with this email and password.
  ///
  /// In en, this message translates to:
  /// **'Create a new account. The user will sign in with this email and password.'**
  String get userDialogCreateSubtitle;

  /// userFieldName: Full Name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get userFieldName;

  /// userFieldEmail: Email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get userFieldEmail;

  /// userFieldPassword: Initial Password
  ///
  /// In en, this message translates to:
  /// **'Initial Password'**
  String get userFieldPassword;

  /// userFieldRole: Role
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get userFieldRole;

  /// userDialogCreateSubmit: Create User
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get userDialogCreateSubmit;

  /// userCreatedSnack: User created successfully
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSnack;

  /// adminIslandProvidersTitle: Providers
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get adminIslandProvidersTitle;

  /// adminIslandProvidersTooltip: Active / total providers
  ///
  /// In en, this message translates to:
  /// **'Active / total providers'**
  String get adminIslandProvidersTooltip;

  /// adminIslandUnresolvedTitle: Unresolved
  ///
  /// In en, this message translates to:
  /// **'Unresolved'**
  String get adminIslandUnresolvedTitle;

  /// adminIslandUnresolvedTooltip: Identities not linked
  ///
  /// In en, this message translates to:
  /// **'Identities not linked'**
  String get adminIslandUnresolvedTooltip;

  /// adminIslandUsersTitle: Users
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get adminIslandUsersTitle;

  /// adminIslandUsersTooltip: Registered users
  ///
  /// In en, this message translates to:
  /// **'Registered users'**
  String get adminIslandUsersTooltip;

  /// adminIslandLinksOkTitle: Links OK
  ///
  /// In en, this message translates to:
  /// **'Links OK'**
  String get adminIslandLinksOkTitle;

  /// adminIslandLinksOkTooltip: Active providers with successful connection test
  ///
  /// In en, this message translates to:
  /// **'Active providers with successful connection test'**
  String get adminIslandLinksOkTooltip;

  /// Island OK count in personal mode — OAuth/bot config, not org PAT tests
  ///
  /// In en, this message translates to:
  /// **'Active providers with OAuth app or bot credentials saved'**
  String get adminIslandLinksOkTooltipPersonal;

  /// adminIslandFailedTitle: Failed
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get adminIslandFailedTitle;

  /// adminIslandFailedTooltip: Connection failures
  ///
  /// In en, this message translates to:
  /// **'Connection failures'**
  String get adminIslandFailedTooltip;

  /// Island failed count in personal mode
  ///
  /// In en, this message translates to:
  /// **'Active providers missing OAuth client credentials or bot token'**
  String get adminIslandFailedTooltipPersonal;

  /// adminIslandPendingTitle: Pending
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get adminIslandPendingTitle;

  /// adminIslandPendingTooltip: Untested or in progress
  ///
  /// In en, this message translates to:
  /// **'Untested or in progress'**
  String get adminIslandPendingTooltip;

  /// adminIslandRefreshTooltip: Refresh admin data
  ///
  /// In en, this message translates to:
  /// **'Refresh admin data'**
  String get adminIslandRefreshTooltip;

  /// adminIslandRefreshLabel: REFRESH
  ///
  /// In en, this message translates to:
  /// **'REFRESH'**
  String get adminIslandRefreshLabel;

  /// adminBootstrapLockTitle: Bootstrap Lock: ACTIVE
  ///
  /// In en, this message translates to:
  /// **'Bootstrap Lock: ACTIVE'**
  String get adminBootstrapLockTitle;

  /// adminBootstrapLockSubtitle: System is locked and requires an administrative account.
  ///
  /// In en, this message translates to:
  /// **'System is locked and requires an administrative account.'**
  String get adminBootstrapLockSubtitle;

  /// adminUserRoleAdmin: ADMIN
  ///
  /// In en, this message translates to:
  /// **'ADMIN'**
  String get adminUserRoleAdmin;

  /// adminUserRoleManager: MANAGER
  ///
  /// In en, this message translates to:
  /// **'MANAGER'**
  String get adminUserRoleManager;

  /// adminUserRoleStandard: STANDARD
  ///
  /// In en, this message translates to:
  /// **'STANDARD'**
  String get adminUserRoleStandard;

  /// identityDialogCreateTitle: Create Identity Link
  ///
  /// In en, this message translates to:
  /// **'Create Identity Link'**
  String get identityDialogCreateTitle;

  /// identityDialogUpdateTitle: Update Identity Link
  ///
  /// In en, this message translates to:
  /// **'Update Identity Link'**
  String get identityDialogUpdateTitle;

  /// identityDialogCreateSubtitle: Link a provider external identity to a DAB user.
  ///
  /// In en, this message translates to:
  /// **'Link a provider external identity to a DAB user.'**
  String get identityDialogCreateSubtitle;

  /// identityFieldDabUser: DAB User
  ///
  /// In en, this message translates to:
  /// **'DAB User'**
  String get identityFieldDabUser;

  /// identityFieldProvider: Provider
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get identityFieldProvider;

  /// identityFieldExternalId: External ID (e.g. github login, phorge PHID)
  ///
  /// In en, this message translates to:
  /// **'External ID (e.g. github login, phorge PHID)'**
  String get identityFieldExternalId;

  /// identityFieldProviderUsernameOptional: Provider Username (optional, e.g. dlimier)
  ///
  /// In en, this message translates to:
  /// **'Provider Username (optional, e.g. dlimier)'**
  String get identityFieldProviderUsernameOptional;

  /// identityCreateLink: Create Link
  ///
  /// In en, this message translates to:
  /// **'Create Link'**
  String get identityCreateLink;

  /// identityUpdateLink: Update Link
  ///
  /// In en, this message translates to:
  /// **'Update Link'**
  String get identityUpdateLink;

  /// identityDeleteLink: Delete Link
  ///
  /// In en, this message translates to:
  /// **'Delete Link'**
  String get identityDeleteLink;

  /// identityDeleteLinkConfirmTitle: Delete identity link?
  ///
  /// In en, this message translates to:
  /// **'Delete identity link?'**
  String get identityDeleteLinkConfirmTitle;

  /// identityDeleteLinkConfirmMessage: Remove the link between this DAB user and the provider identity.
  ///
  /// In en, this message translates to:
  /// **'Remove the link between this DAB user and the provider identity.'**
  String get identityDeleteLinkConfirmMessage;

  /// identityLinkAssociateUser: Associate {externalId} with a DAB user account.
  ///
  /// In en, this message translates to:
  /// **'Associate {externalId} with a DAB user account.'**
  String identityLinkAssociateUser(Object externalId);

  /// identityTargetUserId: Target User ID
  ///
  /// In en, this message translates to:
  /// **'Target User ID'**
  String get identityTargetUserId;

  /// identityProviderUsernameOptionalLabel: Provider Username (optional)
  ///
  /// In en, this message translates to:
  /// **'Provider Username (optional)'**
  String get identityProviderUsernameOptionalLabel;

  /// providerCardShowFields: Show fields
  ///
  /// In en, this message translates to:
  /// **'Show fields'**
  String get providerCardShowFields;

  /// providerCardHideFields: Hide fields
  ///
  /// In en, this message translates to:
  /// **'Hide fields'**
  String get providerCardHideFields;

  /// providerCardMultilineHint: Use one value per line (comma-separated also works).
  ///
  /// In en, this message translates to:
  /// **'Use one value per line (comma-separated also works).'**
  String get providerCardMultilineHint;

  /// providerCardSaveCredentials: Save Provider Credentials
  ///
  /// In en, this message translates to:
  /// **'Save Provider Credentials'**
  String get providerCardSaveCredentials;

  /// providerCardEnterField: Enter {fieldLabel}…
  ///
  /// In en, this message translates to:
  /// **'Enter {fieldLabel}…'**
  String providerCardEnterField(Object fieldLabel);

  /// adminFieldApiToken: API Token
  ///
  /// In en, this message translates to:
  /// **'API Token'**
  String get adminFieldApiToken;

  /// adminFieldBaseUrl: Base URL
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get adminFieldBaseUrl;

  /// adminFieldApiKey: API Key
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get adminFieldApiKey;

  /// adminFieldAtlassianEmail: Atlassian Email
  ///
  /// In en, this message translates to:
  /// **'Atlassian Email'**
  String get adminFieldAtlassianEmail;

  /// adminFieldJiraInstanceUrl: Jira Instance URL (e.g. company.atlassian.net)
  ///
  /// In en, this message translates to:
  /// **'Jira Instance URL (e.g. company.atlassian.net)'**
  String get adminFieldJiraInstanceUrl;

  /// adminFieldApplicationClientId: Application (Client) ID
  ///
  /// In en, this message translates to:
  /// **'Application (Client) ID'**
  String get adminFieldApplicationClientId;

  /// adminFieldClientSecret: Client Secret
  ///
  /// In en, this message translates to:
  /// **'Client Secret'**
  String get adminFieldClientSecret;

  /// adminFieldDirectoryTenantId: Directory (Tenant) ID
  ///
  /// In en, this message translates to:
  /// **'Directory (Tenant) ID'**
  String get adminFieldDirectoryTenantId;

  /// adminFieldBotToken: Bot Token
  ///
  /// In en, this message translates to:
  /// **'Bot Token'**
  String get adminFieldBotToken;

  /// adminFieldSigningSecret: Signing Secret
  ///
  /// In en, this message translates to:
  /// **'Signing Secret'**
  String get adminFieldSigningSecret;

  /// adminFieldWorkspaceTeamId: Workspace/Team ID (e.g. T0123456789)
  ///
  /// In en, this message translates to:
  /// **'Workspace/Team ID (e.g. T0123456789)'**
  String get adminFieldWorkspaceTeamId;

  /// adminFieldChannelIdsOnePerLine: Channel IDs (one per line)
  ///
  /// In en, this message translates to:
  /// **'Channel IDs (one per line)'**
  String get adminFieldChannelIdsOnePerLine;

  /// adminFieldSlackApiBaseOptional: API Base URL (optional, defaults to https://slack.com/api)
  ///
  /// In en, this message translates to:
  /// **'API Base URL (optional, defaults to https://slack.com/api)'**
  String get adminFieldSlackApiBaseOptional;

  /// adminFieldGuildServerId: Guild (Server) ID
  ///
  /// In en, this message translates to:
  /// **'Guild (Server) ID'**
  String get adminFieldGuildServerId;

  /// adminFieldPersonalAccessToken: Personal Access Token
  ///
  /// In en, this message translates to:
  /// **'Personal Access Token'**
  String get adminFieldPersonalAccessToken;

  /// adminFieldWebhookSecret: Webhook Secret
  ///
  /// In en, this message translates to:
  /// **'Webhook Secret'**
  String get adminFieldWebhookSecret;

  /// adminFieldWebhookEndpointUrl: Webhook Endpoint URL
  ///
  /// In en, this message translates to:
  /// **'Webhook Endpoint URL'**
  String get adminFieldWebhookEndpointUrl;

  /// adminFieldWebhookEndpointUrlHint: Helper under webhook endpoint field
  ///
  /// In en, this message translates to:
  /// **'Default: {defaultUrl}. Edit to expose a different public URL for this provider.'**
  String adminFieldWebhookEndpointUrlHint(String defaultUrl);

  /// adminFieldRepositoryOwner: Repository Owner
  ///
  /// In en, this message translates to:
  /// **'Repository Owner'**
  String get adminFieldRepositoryOwner;

  /// adminFieldRepositoryName: Repository Name
  ///
  /// In en, this message translates to:
  /// **'Repository Name'**
  String get adminFieldRepositoryName;

  /// adminFieldBranchOptional: Branch (optional, defaults to repository default)
  ///
  /// In en, this message translates to:
  /// **'Branch (optional, defaults to repository default)'**
  String get adminFieldBranchOptional;

  /// adminFieldRepositoriesOnePerLine: Repositories (one owner/repo per line, optional)
  ///
  /// In en, this message translates to:
  /// **'Repositories (one owner/repo per line, optional)'**
  String get adminFieldRepositoriesOnePerLine;

  /// adminFieldGithubApiBaseOptional: API Base URL (optional, defaults to https://api.github.com)
  ///
  /// In en, this message translates to:
  /// **'API Base URL (optional, defaults to https://api.github.com)'**
  String get adminFieldGithubApiBaseOptional;

  /// adminFieldGitLabInstanceUrl: GitLab Instance URL (e.g. gitlab.com)
  ///
  /// In en, this message translates to:
  /// **'GitLab Instance URL (e.g. gitlab.com)'**
  String get adminFieldGitLabInstanceUrl;

  /// Admin Core field for the HTTPS origin of the Phorge site.
  ///
  /// In en, this message translates to:
  /// **'Phorge instance URL'**
  String get adminFieldPhorgeInstanceUrl;

  /// adminFieldApiTokenOrSecret: API Token / Secret
  ///
  /// In en, this message translates to:
  /// **'API Token / Secret'**
  String get adminFieldApiTokenOrSecret;

  /// dashboardLiveNowTitle: Live Now
  ///
  /// In en, this message translates to:
  /// **'Live Now'**
  String get dashboardLiveNowTitle;

  /// Dashboard left/top pane title for mentions, assignments, CCs, and git watches.
  ///
  /// In en, this message translates to:
  /// **'Directed at you'**
  String get dashboardDirectedTitle;

  /// Dashboard right/bottom pane title for Follow-pinned object updates.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get dashboardFollowingTitle;

  /// Clock/meta label on a Following placeholder card before that object has a live Follow-lane update.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get dashboardWatchingPinLabel;

  /// Search field hint at the top of the Following pane.
  ///
  /// In en, this message translates to:
  /// **'Follow a task or branch…'**
  String get dashboardFollowSearchHint;

  /// Empty state when Following search returns no picker rows.
  ///
  /// In en, this message translates to:
  /// **'No matching tasks or branches.'**
  String get dashboardFollowSearchEmpty;

  /// dashboardLiveUpdated: Live · updated {relativeTime}
  ///
  /// In en, this message translates to:
  /// **'Live · updated {relativeTime}'**
  String dashboardLiveUpdated(Object relativeTime);

  /// commonTimeAgoSeconds: {n}s ago
  ///
  /// In en, this message translates to:
  /// **'{n}s ago'**
  String commonTimeAgoSeconds(Object n);

  /// commonTimeAgoMinutes: {n}m ago
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String commonTimeAgoMinutes(Object n);

  /// dashboardReconnectNotice: Reconnected — caught up through {time}
  ///
  /// In en, this message translates to:
  /// **'Reconnected — caught up through {time}'**
  String dashboardReconnectNotice(Object time);

  /// dashboardFailedLoadLive: Failed to load live activities.
  ///
  /// In en, this message translates to:
  /// **'Failed to load live activities.'**
  String get dashboardFailedLoadLive;

  /// dashboardEmptyLiveCaughtUp: All caught up — enable "Show archived" to review prior items.
  ///
  /// In en, this message translates to:
  /// **'All caught up — enable \"Show archived\" to review prior items.'**
  String get dashboardEmptyLiveCaughtUp;

  /// dashboardEmptyLiveNoActivities: No live activities yet.
  ///
  /// In en, this message translates to:
  /// **'No live activities yet.'**
  String get dashboardEmptyLiveNoActivities;

  /// Empty directed pane when remaining items are archived.
  ///
  /// In en, this message translates to:
  /// **'All caught up — enable \"Show archived\" to review directed items.'**
  String get dashboardEmptyDirectedCaughtUp;

  /// Empty directed pane when this lane has no live rows.
  ///
  /// In en, this message translates to:
  /// **'No mentions or assignments yet.'**
  String get dashboardEmptyDirectedNone;

  /// Empty Follow pane when remaining items are archived.
  ///
  /// In en, this message translates to:
  /// **'All caught up on followed items.'**
  String get dashboardEmptyFollowingCaughtUp;

  /// Empty Follow pane until pinned objects move.
  ///
  /// In en, this message translates to:
  /// **'No updates on followed items yet.'**
  String get dashboardEmptyFollowingNone;

  /// dashboardArchiveShow: Show archived
  ///
  /// In en, this message translates to:
  /// **'Show archived'**
  String get dashboardArchiveShow;

  /// dashboardArchiveHide: Hide archived
  ///
  /// In en, this message translates to:
  /// **'Hide archived'**
  String get dashboardArchiveHide;

  /// dashboardArchiveShowCount: Show archived ({count})
  ///
  /// In en, this message translates to:
  /// **'Show archived ({count})'**
  String dashboardArchiveShowCount(Object count);

  /// activityTooltipArchive: Archive
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get activityTooltipArchive;

  /// Dashboard card action to pin later updates on this object.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get activityTooltipFollow;

  /// Dashboard card action while this object is followed; tap to unfollow.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get activityTooltipFollowing;

  /// activityTooltipUnarchive: Unarchive
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get activityTooltipUnarchive;

  /// activitySemanticsActive: Activity: {title}
  ///
  /// In en, this message translates to:
  /// **'Activity: {title}'**
  String activitySemanticsActive(Object title);

  /// activitySemanticsArchived: Archived activity: {title}
  ///
  /// In en, this message translates to:
  /// **'Archived activity: {title}'**
  String activitySemanticsArchived(Object title);

  /// explorerCouldNotLaunchUrl: Could not launch URL
  ///
  /// In en, this message translates to:
  /// **'Could not launch URL'**
  String get explorerCouldNotLaunchUrl;

  /// explorerTooltipCategory: Category: {category}
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String explorerTooltipCategory(Object category);

  /// explorerTooltipSource: Source: {name}
  ///
  /// In en, this message translates to:
  /// **'Source: {name}'**
  String explorerTooltipSource(Object name);

  /// explorerCreateGroupSubmit: Create Group
  ///
  /// In en, this message translates to:
  /// **'Create Group'**
  String get explorerCreateGroupSubmit;

  /// explorerCreateNewGroupTitle: Create New Group
  ///
  /// In en, this message translates to:
  /// **'Create New Group'**
  String get explorerCreateNewGroupTitle;

  /// explorerGroupNameSectionLabel: GROUP NAME
  ///
  /// In en, this message translates to:
  /// **'GROUP NAME'**
  String get explorerGroupNameSectionLabel;

  /// explorerSelectMembersSectionLabel: SELECT MEMBERS
  ///
  /// In en, this message translates to:
  /// **'SELECT MEMBERS'**
  String get explorerSelectMembersSectionLabel;

  /// explorerGroupNameHintExample: e.g. Mobile Team
  ///
  /// In en, this message translates to:
  /// **'e.g. Mobile Team'**
  String get explorerGroupNameHintExample;

  /// settingsVersionPlaceholder: 1.0.0
  ///
  /// In en, this message translates to:
  /// **'1.0.0'**
  String get settingsVersionPlaceholder;

  /// dashboardProviderHealthTitle: Provider Health
  ///
  /// In en, this message translates to:
  /// **'Provider Health'**
  String get dashboardProviderHealthTitle;

  /// dashboardActivityFromAuthor: Sender line on activity cards (author attribution).
  ///
  /// In en, this message translates to:
  /// **'From {authorName}'**
  String dashboardActivityFromAuthor(Object authorName);

  /// dashboardCardArchivedBadge: Compact badge when an activity is archived.
  ///
  /// In en, this message translates to:
  /// **'ARCHIVED'**
  String get dashboardCardArchivedBadge;

  /// dashboardProviderHealthLive: Sidebar chip — provider connection healthy.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get dashboardProviderHealthLive;

  /// dashboardProviderHealthDegraded: Sidebar chip — provider connection degraded.
  ///
  /// In en, this message translates to:
  /// **'Degraded'**
  String get dashboardProviderHealthDegraded;

  /// dashboardProviderHealthOffline: Sidebar chip — provider offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get dashboardProviderHealthOffline;

  /// dashboardNoProviderActivity: No provider activity yet
  ///
  /// In en, this message translates to:
  /// **'No provider activity yet'**
  String get dashboardNoProviderActivity;

  /// dashboardNoSyncYet: No sync yet
  ///
  /// In en, this message translates to:
  /// **'No sync yet'**
  String get dashboardNoSyncYet;

  /// dashboardLastSync: Last sync {time}
  ///
  /// In en, this message translates to:
  /// **'Last sync {time}'**
  String dashboardLastSync(Object time);

  /// authErrorFailed: Auth failed
  ///
  /// In en, this message translates to:
  /// **'Auth failed'**
  String get authErrorFailed;

  /// appBrandShortName: DAB
  ///
  /// In en, this message translates to:
  /// **'DAB'**
  String get appBrandShortName;

  /// appWindowTitle: DAB App
  ///
  /// In en, this message translates to:
  /// **'DAB App'**
  String get appWindowTitle;

  /// dashboardRelativeDaysAgo: {n}d ago
  ///
  /// In en, this message translates to:
  /// **'{n}d ago'**
  String dashboardRelativeDaysAgo(Object n);

  /// dashboardRelativeHoursAgo: {n}h ago
  ///
  /// In en, this message translates to:
  /// **'{n}h ago'**
  String dashboardRelativeHoursAgo(Object n);

  /// dashboardRelativeMinutesAgo: {n}m ago
  ///
  /// In en, this message translates to:
  /// **'{n}m ago'**
  String dashboardRelativeMinutesAgo(Object n);

  /// dashboardRelativeJustNow: just now
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get dashboardRelativeJustNow;

  /// explorerNoActivitiesFound: No activities found.
  ///
  /// In en, this message translates to:
  /// **'No activities found.'**
  String get explorerNoActivitiesFound;

  /// explorerNoActivitiesForDate: No activities found for this date.
  ///
  /// In en, this message translates to:
  /// **'No activities found for this date.'**
  String get explorerNoActivitiesForDate;

  /// explorerViewingArchivedFromRange: Viewing {count} archived activities from this range.
  ///
  /// In en, this message translates to:
  /// **'Viewing {count} archived activities from this range.'**
  String explorerViewingArchivedFromRange(Object count);

  /// explorerViewingArchivedFromDate: Viewing {count} archived activities from this date.
  ///
  /// In en, this message translates to:
  /// **'Viewing {count} archived activities from this date.'**
  String explorerViewingArchivedFromDate(Object count);

  /// explorerJumpToDateTooltip: Jump to date
  ///
  /// In en, this message translates to:
  /// **'Jump to date'**
  String get explorerJumpToDateTooltip;

  /// explorerClearCacheRefreshTooltip: Clears cached Explorer data for the current date or range and refetches all providers
  ///
  /// In en, this message translates to:
  /// **'Clear cache and refresh'**
  String get explorerClearCacheRefreshTooltip;

  /// explorerSectionActivityProviders: ACTIVITY PROVIDERS
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY PROVIDERS'**
  String get explorerSectionActivityProviders;

  /// adminConnectionConnected: Connected
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get adminConnectionConnected;

  /// adminConnectionDisconnected: Disconnected
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get adminConnectionDisconnected;

  /// adminConnectionTimedOut: Connection timed out
  ///
  /// In en, this message translates to:
  /// **'Connection timed out'**
  String get adminConnectionTimedOut;

  /// adminIdentityStatusLinked: LINKED
  ///
  /// In en, this message translates to:
  /// **'LINKED'**
  String get adminIdentityStatusLinked;

  /// adminIdentityStatusPending: PENDING
  ///
  /// In en, this message translates to:
  /// **'PENDING'**
  String get adminIdentityStatusPending;

  /// adminIdentityStatusFailed: FAILED
  ///
  /// In en, this message translates to:
  /// **'FAILED'**
  String get adminIdentityStatusFailed;

  /// activityCategoryAbbrevCommit: COMMIT
  ///
  /// In en, this message translates to:
  /// **'COMMIT'**
  String get activityCategoryAbbrevCommit;

  /// activityCategoryAbbrevRevision: REVISION
  ///
  /// In en, this message translates to:
  /// **'REVISION'**
  String get activityCategoryAbbrevRevision;

  /// activityCategoryAbbrevTask: TASK
  ///
  /// In en, this message translates to:
  /// **'TASK'**
  String get activityCategoryAbbrevTask;

  /// activityCategoryAbbrevMessage: MESSAGE
  ///
  /// In en, this message translates to:
  /// **'MESSAGE'**
  String get activityCategoryAbbrevMessage;

  /// activityCategoryAbbrevGeneric: ACTIVITY
  ///
  /// In en, this message translates to:
  /// **'ACTIVITY'**
  String get activityCategoryAbbrevGeneric;

  /// activityKindCountTooltip: {label}: {count}
  ///
  /// In en, this message translates to:
  /// **'{label}: {count}'**
  String activityKindCountTooltip(Object label, Object count);

  /// No description provided for @settingsConnectedAccountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Connected accounts'**
  String get settingsConnectedAccountsTitle;

  /// No description provided for @settingsConnectedAccountsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connect the providers you use so DAB can deliver a personal inbound inbox. Mentions, assignments, and git watches require a linked identity. DAB never asks for your password — you sign in at the provider.'**
  String get settingsConnectedAccountsSubtitle;

  /// No description provided for @settingsBotTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a bot token (one per workspace), not your user token.'**
  String get settingsBotTokenHint;

  /// No description provided for @settingsCredentialConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get settingsCredentialConnect;

  /// No description provided for @settingsCredentialTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get settingsCredentialTest;

  /// No description provided for @settingsCredentialDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get settingsCredentialDisconnect;

  /// No description provided for @settingsCredentialConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get settingsCredentialConnected;

  /// No description provided for @settingsCredentialTestOk.
  ///
  /// In en, this message translates to:
  /// **'Connection succeeded'**
  String get settingsCredentialTestOk;

  /// No description provided for @settingsCredentialDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get settingsCredentialDisconnected;

  /// No description provided for @settingsTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get settingsTeamTitle;

  /// No description provided for @settingsTeamSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a teammate so they can connect their own tokens.'**
  String get settingsTeamSubtitle;

  /// No description provided for @explorerUserNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Hasn\'t connected {provider}'**
  String explorerUserNotConnected(String provider);

  /// Title for Admin Security deployment-mode card
  ///
  /// In en, this message translates to:
  /// **'Deployment mode'**
  String get adminDeploymentModeTitle;

  /// Explains Managed vs Individual deployment on Admin Security
  ///
  /// In en, this message translates to:
  /// **'Individual mode lets each teammate connect providers from Settings. Managed mode keeps Admin-owned tokens and Identities.'**
  String get adminDeploymentModeSubtitle;

  /// Segmented-button label for Admin-owned credential deployment
  ///
  /// In en, this message translates to:
  /// **'Managed'**
  String get adminDeploymentModeManaged;

  /// Segmented-button label for Settings PAT / small-team deployment
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get adminDeploymentModeIndividual;

  /// Snack bar after saving deployment mode
  ///
  /// In en, this message translates to:
  /// **'Deployment mode saved'**
  String get adminDeploymentModeSavedSnack;

  /// No description provided for @adminFieldOauthClientId.
  ///
  /// In en, this message translates to:
  /// **'OAuth client ID'**
  String get adminFieldOauthClientId;

  /// No description provided for @adminFieldOauthClientIdJiraHint.
  ///
  /// In en, this message translates to:
  /// **'Copy Client ID from Authorization → OAuth 2.0 (3LO), not App ID. Add Jira API scopes read:jira-work and read:jira-user under Permissions first.'**
  String get adminFieldOauthClientIdJiraHint;

  /// No description provided for @adminOauthCallbackMustMatch.
  ///
  /// In en, this message translates to:
  /// **'Callback URL in the provider console must be exactly: {url}'**
  String adminOauthCallbackMustMatch(String url);

  /// No description provided for @adminFieldOauthClientSecret.
  ///
  /// In en, this message translates to:
  /// **'OAuth client secret'**
  String get adminFieldOauthClientSecret;

  /// No description provided for @adminFieldInstanceUrl.
  ///
  /// In en, this message translates to:
  /// **'Instance URL'**
  String get adminFieldInstanceUrl;

  /// No description provided for @adminPersonalProvidersHint.
  ///
  /// In en, this message translates to:
  /// **'Register DAB as an OAuth app once per provider. Teammates connect from Settings. Phorge needs the instance URL here; teammates paste a Conduit token in Settings. Slack and Discord use a workspace bot, not per-user login.'**
  String get adminPersonalProvidersHint;

  /// No description provided for @adminPersonalLiveWebhookHint.
  ///
  /// In en, this message translates to:
  /// **'Instant Dashboard uses this webhook; otherwise the poller runs about every 45s.'**
  String get adminPersonalLiveWebhookHint;

  /// No description provided for @settingsConnectWithProvider.
  ///
  /// In en, this message translates to:
  /// **'Connect with {provider}'**
  String settingsConnectWithProvider(String provider);

  /// No description provided for @settingsOauthOpened.
  ///
  /// In en, this message translates to:
  /// **'Finish signing in in your browser, then return here.'**
  String get settingsOauthOpened;

  /// No description provided for @settingsOauthNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'An admin must save this provider’s OAuth app in Admin → Providers first.'**
  String get settingsOauthNotConfigured;

  /// No description provided for @settingsPhorgeTokenHint.
  ///
  /// In en, this message translates to:
  /// **'Phorge has no user OAuth. Paste a Conduit API token if you use Phorge.'**
  String get settingsPhorgeTokenHint;

  /// No description provided for @settingsJiraProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get settingsJiraProjectsTitle;

  /// No description provided for @settingsJiraProjectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which Jira projects DAB should watch for tasks. This list is shared with your team.'**
  String get settingsJiraProjectsSubtitle;

  /// No description provided for @settingsJiraProjectsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No projects were visible for this account.'**
  String get settingsJiraProjectsEmpty;

  /// No description provided for @settingsJiraProjectsSave.
  ///
  /// In en, this message translates to:
  /// **'Save projects'**
  String get settingsJiraProjectsSave;

  /// No description provided for @settingsLinearTeamsTitle.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get settingsLinearTeamsTitle;

  /// No description provided for @settingsLinearTeamsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which Linear teams DAB should watch for issues. This list is shared with your team.'**
  String get settingsLinearTeamsSubtitle;

  /// No description provided for @settingsLinearTeamsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No teams were visible for this account.'**
  String get settingsLinearTeamsEmpty;

  /// No description provided for @settingsLinearTeamsSave.
  ///
  /// In en, this message translates to:
  /// **'Save teams'**
  String get settingsLinearTeamsSave;

  /// No description provided for @settingsGitWatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Inbox repos'**
  String get settingsGitWatchesTitle;

  /// No description provided for @settingsGitWatchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which repos land in your Dashboard inbox. Saving none means no git inbox. Your own commits are excluded.'**
  String get settingsGitWatchesSubtitle;

  /// No description provided for @settingsGitWatchesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No repos are on the instance allow-list yet. Ask an admin to add them in Admin → Providers.'**
  String get settingsGitWatchesEmpty;

  /// No description provided for @settingsGitWatchesSave.
  ///
  /// In en, this message translates to:
  /// **'Save watches'**
  String get settingsGitWatchesSave;

  /// No description provided for @settingsGitWatchesBranchesHint.
  ///
  /// In en, this message translates to:
  /// **'Optional branches (comma-separated). Leave blank for all branches.'**
  String get settingsGitWatchesBranchesHint;

  /// No description provided for @settingsGitWatchesBranchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Inbox branches'**
  String get settingsGitWatchesBranchesTitle;

  /// No description provided for @settingsGitWatchesBranchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add branches to watch. With none selected, every branch on the chosen repos is included.'**
  String get settingsGitWatchesBranchesSubtitle;

  /// No description provided for @settingsGitWatchesBranchesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search branches'**
  String get settingsGitWatchesBranchesSearch;

  /// No description provided for @settingsGitWatchesBranchesNeedRepos.
  ///
  /// In en, this message translates to:
  /// **'Select at least one repo before choosing branches.'**
  String get settingsGitWatchesBranchesNeedRepos;

  /// No description provided for @settingsGitWatchesBranchesTruncated.
  ///
  /// In en, this message translates to:
  /// **'Not all branches could be loaded ({count} shown). Type to search this list.'**
  String settingsGitWatchesBranchesTruncated(int count);

  /// No description provided for @adminPublicApiUrlTitle.
  ///
  /// In en, this message translates to:
  /// **'Public API URL'**
  String get adminPublicApiUrlTitle;

  /// No description provided for @adminPublicApiUrlSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reachable base URL for OAuth callbacks and webhook defaults (no trailing slash).'**
  String get adminPublicApiUrlSubtitle;

  /// No description provided for @adminPublicApiUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'https://your-dab-api.example'**
  String get adminPublicApiUrlLabel;

  /// No description provided for @adminPublicApiUrlSavedSnack.
  ///
  /// In en, this message translates to:
  /// **'Public API URL saved'**
  String get adminPublicApiUrlSavedSnack;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'pt',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
