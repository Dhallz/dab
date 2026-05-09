import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
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
    Locale('pt'),
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get dashboardOverview;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: Live activity feed.'**
  String get dashboardSubtitle;

  /// No description provided for @navExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get navExplorer;

  /// No description provided for @navAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get navAdmin;

  /// No description provided for @explorerModeSingleDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get explorerModeSingleDay;

  /// No description provided for @explorerModeRange.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get explorerModeRange;

  /// No description provided for @explorerQuickToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get explorerQuickToday;

  /// No description provided for @explorerQuickWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get explorerQuickWeek;

  /// No description provided for @explorerPickRange.
  ///
  /// In en, this message translates to:
  /// **'Pick range'**
  String get explorerPickRange;

  /// No description provided for @explorerSectionDirectory.
  ///
  /// In en, this message translates to:
  /// **'Directory'**
  String get explorerSectionDirectory;

  /// No description provided for @explorerSectionActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get explorerSectionActivities;

  /// No description provided for @explorerSectionProviders.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get explorerSectionProviders;

  /// No description provided for @explorerDirectoryUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get explorerDirectoryUsers;

  /// No description provided for @explorerDirectoryGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get explorerDirectoryGroups;

  /// No description provided for @explorerCreateGroup.
  ///
  /// In en, this message translates to:
  /// **'Create group'**
  String get explorerCreateGroup;

  /// No description provided for @explorerGroupActions.
  ///
  /// In en, this message translates to:
  /// **'Group actions'**
  String get explorerGroupActions;

  /// No description provided for @explorerEditGroupMembers.
  ///
  /// In en, this message translates to:
  /// **'Edit group members'**
  String get explorerEditGroupMembers;

  /// No description provided for @explorerSelectGroupMembers.
  ///
  /// In en, this message translates to:
  /// **'Select members'**
  String get explorerSelectGroupMembers;

  /// No description provided for @explorerRenameGroup.
  ///
  /// In en, this message translates to:
  /// **'Rename group'**
  String get explorerRenameGroup;

  /// No description provided for @explorerDeleteGroup.
  ///
  /// In en, this message translates to:
  /// **'Delete group'**
  String get explorerDeleteGroup;

  /// No description provided for @explorerGroupNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get explorerGroupNamePlaceholder;

  /// No description provided for @explorerCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get explorerCancel;

  /// No description provided for @explorerSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get explorerSave;

  /// No description provided for @explorerActivityFilterCommit.
  ///
  /// In en, this message translates to:
  /// **'Commits'**
  String get explorerActivityFilterCommit;

  /// No description provided for @explorerActivityFilterRevision.
  ///
  /// In en, this message translates to:
  /// **'Revisions'**
  String get explorerActivityFilterRevision;

  /// No description provided for @explorerActivityFilterTask.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get explorerActivityFilterTask;

  /// No description provided for @explorerActivityFilterMessage.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get explorerActivityFilterMessage;

  /// No description provided for @explorerActivityFilterGeneric.
  ///
  /// In en, this message translates to:
  /// **'Generic'**
  String get explorerActivityFilterGeneric;

  /// No description provided for @activityKindComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get activityKindComment;

  /// No description provided for @activityKindTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get activityKindTag;

  /// No description provided for @activityKindStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get activityKindStatus;

  /// No description provided for @activityKindReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get activityKindReview;

  /// No description provided for @activityKindAssignment.
  ///
  /// In en, this message translates to:
  /// **'Assignment'**
  String get activityKindAssignment;

  /// No description provided for @activityKindCommit.
  ///
  /// In en, this message translates to:
  /// **'Commit'**
  String get activityKindCommit;

  /// No description provided for @activityKindMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get activityKindMessage;

  /// No description provided for @activityKindActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityKindActivity;

  /// No description provided for @insightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insightsTitle;

  /// No description provided for @insightsFiltersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get insightsFiltersTitle;

  /// No description provided for @insightsUsersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get insightsUsersSectionTitle;

  /// No description provided for @insightsProvidersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get insightsProvidersSectionTitle;

  /// No description provided for @insightsActivityTypesSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity types'**
  String get insightsActivityTypesSectionTitle;

  /// No description provided for @insightsPresetToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get insightsPresetToday;

  /// No description provided for @insightsPresetLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7d'**
  String get insightsPresetLast7Days;

  /// No description provided for @insightsPresetLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30d'**
  String get insightsPresetLast30Days;

  /// No description provided for @insightsPresetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get insightsPresetCustom;

  /// No description provided for @insightsKpiTotalActivities.
  ///
  /// In en, this message translates to:
  /// **'Total activities'**
  String get insightsKpiTotalActivities;

  /// No description provided for @insightsKpiActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active users'**
  String get insightsKpiActiveUsers;

  /// No description provided for @insightsKpiActiveProviders.
  ///
  /// In en, this message translates to:
  /// **'Active providers'**
  String get insightsKpiActiveProviders;

  /// No description provided for @insightsKpiTopActivityType.
  ///
  /// In en, this message translates to:
  /// **'Top activity type'**
  String get insightsKpiTopActivityType;

  /// No description provided for @insightsTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity trend'**
  String get insightsTrendTitle;

  /// No description provided for @insightsBreakdownProviders.
  ///
  /// In en, this message translates to:
  /// **'By provider'**
  String get insightsBreakdownProviders;

  /// No description provided for @insightsBreakdownActivityTypes.
  ///
  /// In en, this message translates to:
  /// **'By activity type'**
  String get insightsBreakdownActivityTypes;

  /// No description provided for @insightsBreakdownTopUsers.
  ///
  /// In en, this message translates to:
  /// **'Top users'**
  String get insightsBreakdownTopUsers;

  /// No description provided for @insightsDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get insightsDetailsTitle;

  /// No description provided for @insightsNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get insightsNoData;

  /// No description provided for @insightsNoDataForFilters.
  ///
  /// In en, this message translates to:
  /// **'No data for selected filters.'**
  String get insightsNoDataForFilters;

  /// No description provided for @insightsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Unable to load insights.'**
  String get insightsErrorLoading;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsSectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsSectionLanguage;

  /// No description provided for @settingsSectionIslandBar.
  ///
  /// In en, this message translates to:
  /// **'Island Bar'**
  String get settingsSectionIslandBar;

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDab.
  ///
  /// In en, this message translates to:
  /// **'DAB'**
  String get settingsThemeDab;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageSystemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystemDefault;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get settingsLanguageSpanish;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsLanguageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get settingsLanguageGerman;

  /// No description provided for @settingsLanguagePortuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get settingsLanguagePortuguese;

  /// No description provided for @settingsVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionLabel;

  /// No description provided for @settingsIslandBarDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get settingsIslandBarDashboard;

  /// No description provided for @settingsIslandBarExplorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get settingsIslandBarExplorer;

  /// No description provided for @settingsIslandBarInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get settingsIslandBarInsights;

  /// No description provided for @settingsIslandBarItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get settingsIslandBarItemTitle;

  /// No description provided for @settingsIslandBarItemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get settingsIslandBarItemSubtitle;

  /// No description provided for @settingsIslandBarItemDateControls.
  ///
  /// In en, this message translates to:
  /// **'Date controls'**
  String get settingsIslandBarItemDateControls;

  /// No description provided for @settingsIslandBarItemQuickPreset.
  ///
  /// In en, this message translates to:
  /// **'Quick preset'**
  String get settingsIslandBarItemQuickPreset;

  /// No description provided for @settingsIslandBarItemDateModeToggle.
  ///
  /// In en, this message translates to:
  /// **'Date mode toggle'**
  String get settingsIslandBarItemDateModeToggle;

  /// No description provided for @settingsIslandBarItemActivitySummary.
  ///
  /// In en, this message translates to:
  /// **'Activity summary'**
  String get settingsIslandBarItemActivitySummary;

  /// No description provided for @settingsIslandBarItemHeatBar.
  ///
  /// In en, this message translates to:
  /// **'Heat bar'**
  String get settingsIslandBarItemHeatBar;

  /// No description provided for @settingsIslandBarItemDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get settingsIslandBarItemDateRange;

  /// No description provided for @settingsIslandBarItemPresets.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get settingsIslandBarItemPresets;

  /// No description provided for @settingsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get settingsSave;

  /// No description provided for @settingsClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsClose;

  /// No description provided for @settingsSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSavedMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'pt'].contains(locale.languageCode);

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
