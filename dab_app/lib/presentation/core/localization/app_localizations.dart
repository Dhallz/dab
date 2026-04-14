import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

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

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Coming soon: Live activity feed.'**
  String get dashboardSubtitle;

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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
