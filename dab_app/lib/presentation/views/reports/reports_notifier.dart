import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/containers/activity_usecases.dart';
import '../../../domain/containers/user_usecases.dart';
import '../../../domain/core/daily_report_lock_policy.dart';
import '../../../domain/core/daily_report_markdown.dart';
import '../../../domain/core/daily_report_merge.dart';
import '../../../domain/core/failures.dart';
import '../../../domain/core/follow_candidate_activity.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/core/report_subject_key.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_live_event.dart';
import '../../../domain/entities/activity/activity_search_query.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/entities/user/daily_report_line.dart';
import '../../../domain/entities/user/daily_report_line_role.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../domain/entities/user/user.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_notifier.dart';
import '../../features/app/app_state.dart';
import 'reports_state.dart';
import 'save_text_file.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Reports screen state — own editor plus manager/admin team read.
/// CONTRACT: Owns its live WS subscription; does not read [dashboardNotifierProvider].
final reportsNotifierProvider =
    NotifierProvider.autoDispose<ReportsNotifier, ReportsState>(
      () => ReportsNotifier(sl.activityUseCases, sl.userUseCases),
    );

/// [ARCH: PRESENTATION]
/// CONSTRAINTS: Delegates all I/O to use cases; never calls repositories or
/// data sources directly. PUT only for the signed-in user's report.
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
  Timer? _searchTimer;
  Timer? _lockTimer;
  List<Activity> _live = const [];
  List<Activity> _authored = const [];
  String? _userId;
  int _loadGeneration = 0;
  int _searchGeneration = 0;
  bool _watchingLive = false;

  static const _searchLookbackDays = 30;
  static const _searchMinChars = 2;
  static const _searchLimit = 20;

  @override
  ReportsState build() {
    ref.onDispose(() {
      _activitySubscription?.cancel();
      _searchTimer?.cancel();
      _lockTimer?.cancel();
    });
    ref.listen(
      appNotifierProvider.select(
        (s) => (
          s.orgTimezoneId,
          s.dailyReportLockOffsetDays,
          s.dailyReportLockTime,
        ),
      ),
      (_, __) => _applyDeadlineLock(),
    );
    return const ReportsState();
  }

  /// Hydrates the report list and today's (or latest teammate) report, then starts live WS.
  Future<void> started({
    required String? connectedUserId,
    UserRole role = UserRole.standard,
  }) async {
    _userId = connectedUserId;
    final canBrowseTeam =
        role == UserRole.admin || role == UserRole.manager;
    var directory = const <User>[];
    if (canBrowseTeam) {
      final usersResult = await _userUseCases.getUsers.execute();
      directory = usersResult.getOrElse((_) => const []);
    }
    state = state.copyWith(
      ownerUserId: connectedUserId ?? '',
      viewedUserId: connectedUserId ?? '',
      canBrowseTeam: canBrowseTeam,
      directoryUsers: directory,
    );
    await _openUser(connectedUserId ?? '');
    _ensureLiveWatch();
  }

  /// Opens [userId]'s latest (or today, when self) report.
  Future<void> selectUser(String userId) async {
    if (userId.isEmpty || userId == state.viewedUserId) return;
    await _openUser(userId);
  }

  /// Opens the selected person's report for [date].
  Future<void> selectDate(String date) async {
    if (date.isEmpty || date == state.date) return;
    await _hydrate(date: date, viewedUserId: state.viewedUserId);
  }

  /// Toggles whether [subjectKey] is emitted in Markdown.
  void setLineIncluded(String subjectKey, bool included) {
    if (state.isReadOnly) return;
    state = state.copyWith(
      lines: [
        for (final line in state.lines)
          if (line.subjectKey == subjectKey)
            line.copyWith(included: included)
          else
            line,
      ],
      isDirty: true,
    );
  }

  /// Debounced picker: issue catalog (title contains) plus authored activities.
  void setSearchQuery(String query) {
    if (state.isReadOnly) return;
    if (state.searchQuery != query) {
      state = state.copyWith(searchQuery: query);
    }
    _searchTimer?.cancel();
    final trimmed = query.trim();
    if (trimmed.length < _searchMinChars || _userId == null) {
      _searchGeneration++;
      state = state.copyWith(
        searchResults: const [],
        searchStatus: ViewStatus.initial,
      );
      return;
    }
    _searchTimer = Timer(const Duration(milliseconds: 350), () {
      unawaited(_runSearch(trimmed));
    });
  }

  /// Appends [activity] onto the open own report.
  void addFromSearch(Activity activity) {
    if (state.isReadOnly) return;
    final key = activity.reportSubjectKey;
    if (key.trim().isEmpty) return;
    final already = state.lines.any((line) => line.subjectKey == key);
    if (already) {
      setLineIncluded(key, true);
      return;
    }
    final line = DailyReportLine(
      subjectKey: key,
      included: true,
      role: DailyReportLineRole.authored,
      title: activity.title,
      url: activity.url,
      occurredAt: activity.createdAt.toUtc(),
      providerId: activity.reportProviderId,
    );
    state = state.copyWith(
      lines: [line, ...state.lines],
      searchQuery: '',
      searchResults: const [],
      searchStatus: ViewStatus.initial,
      isDirty: true,
    );
  }

  /// Sets the DAB-only note for [subjectKey].
  void setLineNote(String subjectKey, String note) {
    if (state.isReadOnly) return;
    final trimmed = note.trim();
    state = state.copyWith(
      lines: [
        for (final line in state.lines)
          if (line.subjectKey == subjectKey)
            line.copyWith(note: trimmed.isEmpty ? null : trimmed)
          else
            line,
      ],
      isDirty: true,
    );
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

  /// Persists the open own report. No-op when clean or read-only.
  Future<void> save() async {
    if (!state.canSave) return;
    state = state.copyWith(persistInFlight: true);
    final result = await _userUseCases.saveMyDailyReport.execute(
      date: state.date,
      includeFollowing: false,
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
        state = state.copyWith(
          persistInFlight: false,
          errorMessage: null,
          isDirty: false,
          availableDates: _insertDate(state.availableDates, state.date),
        );
      },
    );
  }

  Future<void> _hydrate({
    required String date,
    required String viewedUserId,
  }) async {
    final generation = ++_loadGeneration;
    _searchTimer?.cancel();
    if (date.isEmpty) {
      state = state.copyWith(
        status: ViewStatus.success,
        errorMessage: null,
        date: '',
        viewedUserId: viewedUserId,
        lines: const [],
        isDirty: false,
        persistInFlight: false,
        searchQuery: '',
        searchResults: const [],
        searchStatus: ViewStatus.initial,
      );
      _applyDeadlineLock();
      return;
    }
    state = state.copyWith(
      status: ViewStatus.loading,
      errorMessage: null,
      date: date,
      viewedUserId: viewedUserId,
      isDirty: false,
      persistInFlight: false,
      searchQuery: '',
      searchResults: const [],
      searchStatus: ViewStatus.initial,
    );
    _applyDeadlineLock();

    final isOwn = viewedUserId.isNotEmpty && viewedUserId == _userId;
    final isToday = date == _todayKey();

    if (!isOwn) {
      _live = const [];
      _authored = const [];
      final savedResult = viewedUserId.isEmpty
          ? null
          : await _userUseCases.getUserDailyReport.execute(
              userId: viewedUserId,
              date: date,
            );
      if (generation != _loadGeneration) return;
      if (savedResult == null || savedResult.isLeft()) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: savedResult?.fold((f) => f.message, (_) => null),
          lines: const [],
        );
        return;
      }
      final saved = savedResult.getOrElse(
        (_) => DailyReport.empty(date: date, userId: viewedUserId),
      );
      state = state.copyWith(
        status: ViewStatus.success,
        errorMessage: null,
        includeFollowing: false,
        lines: saved.lines,
        isDirty: false,
      );
      _applyDeadlineLock();
      return;
    }

    final Either<AppFailure, List<Activity>>? liveResult = isToday
        ? await _activityUseCases.getLiveActivities.execute(limit: 50)
        : null;
    final Either<AppFailure, List<Activity>>? authoredResult =
        isToday && _userId != null
        ? await _activityUseCases.searchActivities.execute(
            ActivitySearchQuery(
              startDate: _reportDay(date),
              endDate: _reportDay(date),
              users: [_userId!],
              authoredOnly: true,
              orgTimezoneId: ref.read(appNotifierProvider).orgTimezoneId,
            ),
          )
        : null;
    final savedResult = await _userUseCases.getMyDailyReport.execute(date: date);
    if (generation != _loadGeneration) return;

    _live = liveResult == null
        ? const []
        : liveResult.getOrElse((_) => const []);
    _authored = authoredResult == null
        ? const []
        : authoredResult.getOrElse((_) => const []);
    final saved = savedResult.getOrElse(
      (_) => DailyReport.empty(date: date, userId: _userId ?? ''),
    );

    final loadFailed =
        savedResult.isLeft() &&
        (liveResult == null || liveResult.isLeft()) &&
        (authoredResult == null || authoredResult.isLeft());
    if (loadFailed) {
      state = state.copyWith(
        status: ViewStatus.failure,
        errorMessage: savedResult.fold((f) => f.message, (_) => null),
        includeFollowing: false,
      );
      return;
    }

    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    state = state.copyWith(
      status: ViewStatus.success,
      errorMessage: null,
      includeFollowing: false,
      isDirty: false,
      lines: isToday
          ? mergeDailyReportPool(
              live: _live,
              authored: _authored,
              saved: saved,
              orgTimezoneId: orgTimezoneId,
              reportDay: _reportDay(date),
            )
          : saved.lines,
    );
    _applyDeadlineLock();
  }

  void _applyDeadlineLock() {
    _lockTimer?.cancel();
    if (state.date.isEmpty) {
      if (state.isPastDeadline) {
        state = state.copyWith(isPastDeadline: false);
      }
      return;
    }
    final app = ref.read(appNotifierProvider);
    final locked = isDailyReportLocked(
      reportDate: state.date,
      orgTimezoneId: app.orgTimezoneId,
      policy: app.dailyReportLockPolicy,
      now: _now(),
    );
    if (state.isPastDeadline != locked) {
      state = state.copyWith(isPastDeadline: locked);
    }
    if (locked) return;
    final lockAt = dailyReportLockUtc(
      reportDate: state.date,
      orgTimezoneId: app.orgTimezoneId,
      policy: app.dailyReportLockPolicy,
    );
    if (lockAt == null) return;
    final delay = lockAt.difference(_now().toUtc());
    if (delay <= Duration.zero) {
      state = state.copyWith(isPastDeadline: true);
      return;
    }
    _lockTimer = Timer(delay, () {
      state = state.copyWith(isPastDeadline: true);
    });
  }

  void _ensureLiveWatch() {
    if (_watchingLive) return;
    _watchingLive = true;
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

  void _onLiveActivity(Activity activity) {
    if (!_shouldMergeLive) return;
    final updated = [
      activity,
      ..._live.where((item) => item.id != activity.id),
    ];
    if (updated.length > 100) updated.removeLast();
    _live = updated;
    _remerge();
  }

  void _onArchived(String activityId, {required bool archived}) {
    if (!_shouldMergeLive) return;
    _live = [
      for (final activity in _live)
        if (activity.id == activityId)
          activity.copyWith(archived: archived)
        else
          activity,
    ];
    _remerge();
  }

  bool get _shouldMergeLive =>
      state.isOwnReport && state.date == _todayKey();

  void _remerge() {
    if (state.date.isEmpty || !_shouldMergeLive) return;
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    state = state.copyWith(
      lines: mergeDailyReportPool(
        live: _live,
        authored: _authored,
        saved: DailyReport(
          userId: _userId ?? '',
          date: state.date,
          lines: state.lines,
        ),
        orgTimezoneId: orgTimezoneId,
        reportDay: _reportDay(state.date),
      ),
    );
  }

  String _todayKey() {
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    return orgDayKeyFromUtc(orgTimezoneId, _now().toUtc());
  }

  Future<void> _openUser(String userId) async {
    final today = _todayKey();
    final isOwn = userId.isNotEmpty && userId == _userId;
    final datesResult = await _fetchDates(userId);
    final listed = datesResult.fold(
      (_) => isOwn ? [today] : const <String>[],
      (saved) => _mergeDates(saved, today: today, includeToday: isOwn),
    );
    final nextDate = isOwn
        ? today
        : (listed.isEmpty ? '' : listed.first);
    state = state.copyWith(
      todayDate: today,
      availableDates: listed,
      viewedUserId: userId,
    );
    await _hydrate(date: nextDate, viewedUserId: userId);
  }

  Future<Either<AppFailure, List<String>>> _fetchDates(String userId) {
    if (userId.isEmpty) {
      return Future<Either<AppFailure, List<String>>>.value(const Right([]));
    }
    if (userId == _userId) {
      return _userUseCases.listMyDailyReports.execute();
    }
    return _userUseCases.listUserDailyReports.execute(userId: userId);
  }

  List<String> _mergeDates(
    List<String> saved, {
    required String today,
    required bool includeToday,
  }) {
    if (!includeToday || saved.contains(today)) return saved;
    return [today, ...saved];
  }

  List<String> _insertDate(List<String> dates, String date) {
    if (date.isEmpty || dates.contains(date)) return dates;
    return [date, ...dates]..sort((a, b) => b.compareTo(a));
  }

  DateTime _reportDay(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return _now();
    final year = int.tryParse(parts[0]) ?? _now().year;
    final month = int.tryParse(parts[1]) ?? _now().month;
    final day = int.tryParse(parts[2]) ?? _now().day;
    return DateTime(year, month, day);
  }

  Future<void> _runSearch(String query) async {
    final userId = _userId;
    if (userId == null || state.date.isEmpty || state.isReadOnly) return;
    final generation = ++_searchGeneration;
    state = state.copyWith(searchStatus: ViewStatus.loading);
    final orgTimezoneId = ref.read(appNotifierProvider).orgTimezoneId;
    final reportDay = _reportDay(state.date);
    final activitiesFuture = _activityUseCases.searchActivities.execute(
      ActivitySearchQuery(
        startDate: reportDay.subtract(
          const Duration(days: _searchLookbackDays - 1),
        ),
        endDate: reportDay,
        users: [userId],
        authoredOnly: true,
        text: query,
        orgTimezoneId: orgTimezoneId,
      ),
    );
    final candidatesFuture = _userUseCases.listMyFollowCandidates.execute(
      query: query,
    );
    final activityResult = await activitiesFuture;
    final candidateResult = await candidatesFuture;
    if (generation != _searchGeneration) return;
    if (activityResult.isLeft() && candidateResult.isLeft()) {
      state = state.copyWith(
        searchStatus: ViewStatus.failure,
        searchResults: const [],
      );
      return;
    }
    final fromCatalog = [
      for (final row in candidateResult.getOrElse(
        (_) => const <FollowCandidate>[],
      ))
        if (row.kind == 'issue')
          activityFromFollowCandidate(
            candidate: row,
            userId: userId,
            occurredAt: reportDay,
          ),
    ];
    final fromFeed = activityResult.getOrElse((_) => const <Activity>[]);
    state = state.copyWith(
      searchStatus: ViewStatus.success,
      searchResults: _mergeSearchHits(fromCatalog, fromFeed),
    );
  }

  List<Activity> _mergeSearchHits(
    List<Activity> catalog,
    List<Activity> feed,
  ) {
    final seen = <String>{};
    final out = <Activity>[];
    for (final activity in [...catalog, ...feed]) {
      final key = activity.reportSubjectKey;
      if (key.trim().isEmpty || !seen.add(key)) continue;
      out.add(activity);
      if (out.length >= _searchLimit) break;
    }
    return out;
  }
}
