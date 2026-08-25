import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/core/report_subject_key.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/user/daily_report_line.dart';
import '../../../domain/entities/user/user.dart';
import '../../core/models/view_status.dart';

part 'reports_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Reports authoring / team-read surface.
/// CONTRACT: Immutable; exclusively emitted by [ReportsNotifier].
@MappableClass()
class ReportsState with ReportsStateMappable {
  final ViewStatus status;
  final String? errorMessage;
  final String date;
  final String ownerUserId;
  final String viewedUserId;
  final bool canBrowseTeam;
  final List<User> directoryUsers;
  final List<String> availableDates;
  final String todayDate;
  final bool includeFollowing;
  final List<DailyReportLine> lines;
  final bool persistInFlight;
  final bool isDirty;
  final bool isPastDeadline;
  final String searchQuery;
  final List<Activity> searchResults;
  final ViewStatus searchStatus;

  const ReportsState({
    this.status = ViewStatus.initial,
    this.errorMessage,
    this.date = '',
    this.ownerUserId = '',
    this.viewedUserId = '',
    this.canBrowseTeam = false,
    this.directoryUsers = const [],
    this.availableDates = const [],
    this.todayDate = '',
    this.includeFollowing = false,
    this.lines = const [],
    this.persistInFlight = false,
    this.isDirty = false,
    this.isPastDeadline = false,
    this.searchQuery = '',
    this.searchResults = const [],
    this.searchStatus = ViewStatus.initial,
  });

  factory ReportsState.initial() => const ReportsState();

  /// True when the signed-in user is looking at their own report.
  bool get isOwnReport =>
      viewedUserId.isEmpty || viewedUserId == ownerUserId;

  /// Teammate reports and own reports after the Admin deadline are display-only.
  bool get isReadOnly => !isOwnReport || isPastDeadline;

  /// Save is enabled after an unsaved edit on the caller's report.
  bool get canSave =>
      !isReadOnly && isDirty && !persistInFlight && date.isNotEmpty;

  /// Picker rows that are not already on the report.
  List<Activity> get searchPickerVisible {
    final onReport = {for (final line in lines) line.subjectKey};
    return [
      for (final activity in searchResults)
        if (!onReport.contains(activity.reportSubjectKey)) activity,
    ];
  }
}
