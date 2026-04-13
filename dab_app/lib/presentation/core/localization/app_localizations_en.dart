// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSubtitle => 'Coming soon: Live activity feed.';

  @override
  String get explorerModeSingleDay => 'Day';

  @override
  String get explorerModeRange => 'Range';

  @override
  String get explorerQuickToday => 'Today';

  @override
  String get explorerQuickWeek => 'Week';

  @override
  String get explorerPickRange => 'Pick range';

  @override
  String get activityKindComment => 'Comment';

  @override
  String get activityKindTag => 'Tag';

  @override
  String get activityKindStatus => 'Status';

  @override
  String get activityKindReview => 'Review';

  @override
  String get activityKindAssignment => 'Assignment';

  @override
  String get activityKindCommit => 'Commit';

  @override
  String get activityKindMessage => 'Message';

  @override
  String get activityKindActivity => 'Activity';
}
