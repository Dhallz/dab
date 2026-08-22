import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/containers/activity_usecases.dart';
import '../../../domain/containers/user_usecases.dart';
import '../../../domain/core/daily_report_markdown.dart';
import '../../../domain/core/daily_report_merge.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_live_event.dart';
import '../../../domain/entities/activity/activity_search_query.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_notifier.dart';
import 'reports_state.dart';
import 'save_text_file.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Reports screen state — live Directed union authored search, curated lines.
/// CONTRACT: Owns its live WS subscription; does not read [dashboardNotifierProvider].
final reportsNotifierProvider =
    NotifierProvider.autoDispose<ReportsNotifier, ReportsState>(
      () => ReportsNotifier(sl.activityUseCases, sl.userUseCases),
    );

/// [ARCH: PRESENTATION]
/// CONSTRAINTS: Delegates all I/O to use cases; never calls repositories or
/// data sources directly.
class ReportsNotifier extends AutoDisposeNotifier<ReportsState> {
  ReportsNotifier(
    this._activityUseCases,
    this._userUseCases, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final ActivityUseCases _activityUseCases;
  final UserUseCases _userUseCases;
  final DateTime Function() _now;

  StreamSubscription<ActivityLiveEvent>? _activitySubscription;
  Timer? _persistTimer;
  List<Activity> _live = const [];
  List<Activity> _authored = const [];
  String? _userId;
  int _loadGeneration = 0;

  @override
  ReportsState build() {
    ref.onDispose(() {
      _activitySubscription?.cancel();
      _persistTimer?.cancel();
    });
    return const ReportsState();
  }

  /// Hydrates today's pool for [connectedUserId] and starts the live subscription.
  Future<void> started(String? connectedUserId) async {
    final generation = ++_loadGeneration;
    _userId = connectedUserId;
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    final date = orgDayKeyFromUtc(orgTimezoneId, _now().toUtc());
    state = state.copyWith(
      status: ViewStatus.loading,
      errorMessage: null,
      date: date,
    );

    final liveFuture = _activityUseCases.getLiveActivities.execute(limit: 50);
    final authoredFuture = connectedUserId == null
        ? Future.value(null)
        : _activityUseCases.searchActivities.execute(
            ActivitySearchQuery(
              startDate: _reportDay(date),
              endDate: _reportDay(date),
              users: [connectedUserId],
              authoredOnly: true,
              orgTimezoneId: orgTimezoneId,
            ),
          );
    final savedFuture = _userUseCases.getMyDailyReport.execute(date: date);

    final liveResult = await liveFuture;
    final authoredResult = await authoredFuture;
    final savedResult = await savedFuture;
    if (generation != _loadGeneration) return;

    _live = liveResult.getOrElse((_) => const []);
    _authored = authoredResult == null
        ? const []
        : authoredResult.getOrElse((_) => const []);
    final saved = savedResult.getOrElse(
      (_) => DailyReport.empty(date: date, userId: connectedUserId ?? ''),
    );

    final loadFailed =
        liveResult.isLeft() &&
        (authoredResult == null || authoredResult.isLeft()) &&
        savedResult.isLeft();
    if (loadFailed) {
      state = state.copyWith(
        status: ViewStatus.failure,
        errorMessage: liveResult.getLeft().toNullable()?.message ??
            savedResult.getLeft().toNullable()?.message,
        includeFollowing: saved.includeFollowing,
      );
      return;
    }

    state = state.copyWith(
      status: ViewStatus.success,
      errorMessage: null,
      includeFollowing: saved.includeFollowing,
      lines: mergeDailyReportPool(
        live: _live,
        authored: _authored,
        saved: saved,
        orgTimezoneId: orgTimezoneId,
        reportDay: _reportDay(date),
        includeFollowing: saved.includeFollowing,
      ),
    );

    _activitySubscription?.cancel();
    _activitySubscription = _activityUseCases.watchActivities.execute().listen((
      event,
    ) {
      switch (event) {
        case ActivityReceivedEvent(:final activity):
          _onLiveActivity(activity);
        case ActivityArchivedEvent(:final activityId):
          _onArchived(activityId, archived: true);
        case ActivityUnarchivedEvent(:final activityId):
          _onArchived(activityId, archived: false);
      }
    });
  }

  /// Includes Follow-lane live rows in the pool when [enabled] is true.
  void setIncludeFollowing(bool enabled) {
    if (state.includeFollowing == enabled) return;
    state = state.copyWith(includeFollowing: enabled);
    _remerge();
    _schedulePersist();
  }

  /// Toggles whether [subjectKey] is emitted in Markdown.
  void setLineIncluded(String subjectKey, bool included) {
    state = state.copyWith(
      lines: [
        for (final line in state.lines)
          if (line.subjectKey == subjectKey)
            line.copyWith(included: included)
          else
            line,
      ],
    );
    _schedulePersist();
  }

  /// Sets the DAB-only note for [subjectKey].
  void setLineNote(String subjectKey, String note) {
    final trimmed = note.trim();
    state = state.copyWith(
      lines: [
        for (final line in state.lines)
          if (line.subjectKey == subjectKey)
            line.copyWith(note: trimmed.isEmpty ? null : trimmed)
          else
            line,
      ],
    );
    _schedulePersist();
  }

  /// Markdown for included lines (org-local times).
  String markdown() {
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    return dailyReportMarkdown(
      date: state.date,
      lines: state.lines,
      orgTimezoneId: orgTimezoneId,
    );
  }

  /// Copies the Markdown report to the clipboard.
  Future<void> copyMarkdown() async {
    await Clipboard.setData(ClipboardData(text: markdown()));
  }

  /// Writes `{date}.md` to Downloads (or triggers a browser download).
  Future<String> downloadMarkdown() async {
    final filename = 'dab-report-${state.date}.md';
    return saveTextFile(filename: filename, contents: markdown());
  }

  void _onLiveActivity(Activity activity) {
    final updated = [
      activity,
      ..._live.where((item) => item.id != activity.id),
    ];
    if (updated.length > 100) updated.removeLast();
    _live = updated;
    _remerge();
  }

  void _onArchived(String activityId, {required bool archived}) {
    _live = [
      for (final activity in _live)
        if (activity.id == activityId)
          activity.copyWith(archived: archived)
        else
          activity,
    ];
    _remerge();
  }

  void _remerge() {
    if (state.date.isEmpty) return;
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    state = state.copyWith(
      lines: mergeDailyReportPool(
        live: _live,
        authored: _authored,
        saved: DailyReport(
          userId: _userId ?? '',
          date: state.date,
          includeFollowing: state.includeFollowing,
          lines: state.lines,
        ),
        orgTimezoneId: orgTimezoneId,
        reportDay: _reportDay(state.date),
        includeFollowing: state.includeFollowing,
      ),
    );
  }

  void _schedulePersist() {
    _persistTimer?.cancel();
    _persistTimer = Timer(const Duration(milliseconds: 500), _persist);
  }

  Future<void> _persist() async {
    if (state.date.isEmpty) return;
    state = state.copyWith(persistInFlight: true);
    final result = await _userUseCases.saveMyDailyReport.execute(
      date: state.date,
      includeFollowing: state.includeFollowing,
      lines: state.lines,
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          persistInFlight: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(persistInFlight: false, errorMessage: null);
      },
    );
  }

  DateTime _reportDay(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return _now();
    final year = int.tryParse(parts[0]) ?? _now().year;
    final month = int.tryParse(parts[1]) ?? _now().month;
    final day = int.tryParse(parts[2]) ?? _now().day;
    return DateTime(year, month, day);
  }
}
