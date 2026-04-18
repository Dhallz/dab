import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/containers/activity_usecases.dart';
import '../../../domain/containers/upcoming_event_usecases.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_live_event.dart';
import '../../core/abs_bloc.dart';
import '../../core/models/view_status.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import 'services/banner_evaluator.dart';

/// [ARCH: PRESENTATION_BLOC]
/// ROLE: Owns the Dashboard screen state — live feed, upcoming events,
/// banner, and triage preferences.
/// CONTRACT: Subscribes to the activity WS stream, maintains an
/// archive/unarchive model by rewriting cached entries in place, and runs a
/// periodic banner evaluation tick.
/// CONSTRAINTS: Delegates all I/O to use cases; never calls repositories or
/// data sources directly.
class DashboardBloc extends AbsBloc<DashboardEvent, DashboardState> {
  final ActivityUseCases _activityUseCases;
  final UpcomingEventUseCases _upcomingEventUseCases;
  final BannerEvaluator _bannerEvaluator;
  final DateTime Function() _now;
  final Duration _bannerTickInterval;

  StreamSubscription<ActivityLiveEvent>? _activitySubscription;
  Timer? _bannerTimer;

  DashboardBloc(
    this._activityUseCases,
    this._upcomingEventUseCases, {
    BannerEvaluator? bannerEvaluator,
    DateTime Function()? now,
    Duration bannerTickInterval = const Duration(seconds: 30),
  })  : _bannerEvaluator = bannerEvaluator ?? const BannerEvaluator(),
        _now = now ?? DateTime.now,
        _bannerTickInterval = bannerTickInterval,
        super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardActivityReceived>(_onActivityReceived);
    on<DashboardActivityArchivedRemotely>(_onActivityArchivedRemotely);
    on<DashboardActivityUnarchivedRemotely>(_onActivityUnarchivedRemotely);
    on<DashboardArchiveActivityRequested>(_onArchiveRequested);
    on<DashboardUnarchiveActivityRequested>(_onUnarchiveRequested);
    on<DashboardArchivedVisibilityToggled>(_onArchivedVisibilityToggled);
    on<DashboardBannerTick>(_onBannerTick);
    on<DashboardBannerDismissed>(_onBannerDismissed);
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, errorMessage: null));

    // Always request archived entries on hydration so the client has a
    // complete picture of the Redis live feed. The archive visibility toggle
    // is applied purely client-side via `DashboardState.visibleActivities`,
    // which means a user's archive state survives an app restart even when
    // the feed opens with archived items hidden by default.
    final liveResult = await _activityUseCases.getLiveActivities.execute(
      limit: 50,
      includeArchived: true,
    );
    final upcomingResult = await _upcomingEventUseCases.getUpcomingEvents
        .execute();

    final upcomingEvents = upcomingResult.getOrElse((_) => const []);

    liveResult.fold(
      (failure) {
        if (emit.isDone) return;
        emit(
          state.copyWith(
            status: ViewStatus.failure,
            errorMessage: failure.message,
            upcomingEvents: upcomingEvents,
          ),
        );
      },
      (activities) {
        if (emit.isDone) return;
        emit(
          state.copyWith(
            status: ViewStatus.success,
            errorMessage: null,
            activities: activities,
            upcomingEvents: upcomingEvents,
          ),
        );
      },
    );

    _activitySubscription?.cancel();
    _activitySubscription = _activityUseCases.watchActivities.execute().listen((
      event,
    ) {
      switch (event) {
        case ActivityReceivedEvent(:final activity):
          add(DashboardActivityReceived(activity));
        case ActivityArchivedEvent(:final activityId):
          add(DashboardActivityArchivedRemotely(activityId));
        case ActivityUnarchivedEvent(:final activityId):
          add(DashboardActivityUnarchivedRemotely(activityId));
      }
    });

    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(_bannerTickInterval, (_) {
      add(const DashboardBannerTick());
    });
    add(const DashboardBannerTick());
  }

  void _onActivityReceived(
    DashboardActivityReceived event,
    Emitter<DashboardState> emit,
  ) {
    final activity = event.activity as Activity;
    print(
      '[LIVE_CLIENT] dashboard_event activity_id=${activity.id} user_id=${activity.userId}',
    );
    if (state.activities.any((item) => item.id == activity.id)) {
      print('[LIVE_CLIENT] dashboard_dedup activity_id=${activity.id}');
      return;
    }
    final updatedList = [activity, ...state.activities];
    if (updatedList.length > 100) updatedList.removeLast();

    print(
      '[LIVE_CLIENT] dashboard_state_updated total=${updatedList.length} newest=${activity.id}',
    );
    emit(state.copyWith(activities: updatedList));
  }

  void _onActivityArchivedRemotely(
    DashboardActivityArchivedRemotely event,
    Emitter<DashboardState> emit,
  ) {
    _updateArchiveFlag(event.activityId, archived: true, emit: emit);
  }

  void _onActivityUnarchivedRemotely(
    DashboardActivityUnarchivedRemotely event,
    Emitter<DashboardState> emit,
  ) {
    _updateArchiveFlag(event.activityId, archived: false, emit: emit);
  }

  Future<void> _onArchiveRequested(
    DashboardArchiveActivityRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final index = state.activities.indexWhere((a) => a.id == event.activityId);
    if (index < 0) return;
    final previouslyArchived = state.activities[index].archived;

    // Optimistic: flip the flag immediately so the UI responds.
    _updateArchiveFlag(event.activityId, archived: true, emit: emit);
    final result = await _activityUseCases.archiveLiveActivity.execute(
      event.activityId,
    );
    result.fold(
      (_) {
        if (emit.isDone) return;
        _updateArchiveFlag(
          event.activityId,
          archived: previouslyArchived,
          emit: emit,
        );
      },
      (_) {},
    );
  }

  Future<void> _onUnarchiveRequested(
    DashboardUnarchiveActivityRequested event,
    Emitter<DashboardState> emit,
  ) async {
    final index = state.activities.indexWhere((a) => a.id == event.activityId);
    if (index < 0) return;
    final previouslyArchived = state.activities[index].archived;

    _updateArchiveFlag(event.activityId, archived: false, emit: emit);
    final result = await _activityUseCases.unarchiveLiveActivity.execute(
      event.activityId,
    );
    result.fold(
      (_) {
        if (emit.isDone) return;
        _updateArchiveFlag(
          event.activityId,
          archived: previouslyArchived,
          emit: emit,
        );
      },
      (_) {},
    );
  }

  void _onArchivedVisibilityToggled(
    DashboardArchivedVisibilityToggled event,
    Emitter<DashboardState> emit,
  ) {
    emit(
      state.copyWith(
        showArchivedActivities: !state.showArchivedActivities,
      ),
    );
  }

  void _onBannerTick(
    DashboardBannerTick event,
    Emitter<DashboardState> emit,
  ) {
    if (state.upcomingEvents.isEmpty) return;
    final banner = _bannerEvaluator.evaluate(
      events: state.upcomingEvents,
      now: _now(),
      alreadyNotified: state.lastNotifiedEventIds.toSet(),
    );
    if (banner == null) return;
    if (state.activeBanner?.dedupeKey == banner.dedupeKey) return;

    emit(
      state.copyWith(
        activeBanner: banner,
        lastNotifiedEventIds: [
          ...state.lastNotifiedEventIds,
          banner.dedupeKey,
        ],
      ),
    );
  }

  void _onBannerDismissed(
    DashboardBannerDismissed event,
    Emitter<DashboardState> emit,
  ) {
    if (state.activeBanner == null) return;
    emit(state.copyWith(activeBanner: null));
  }

  void _updateArchiveFlag(
    String activityId, {
    required bool archived,
    required Emitter<DashboardState> emit,
  }) {
    var changed = false;
    final updated = [
      for (final activity in state.activities)
        if (activity.id == activityId && activity.archived != archived)
          (() {
            changed = true;
            return activity.copyWith(archived: archived);
          })()
        else
          activity,
    ];
    if (!changed) return;
    if (emit.isDone) return;
    emit(state.copyWith(activities: updated));
  }

  @override
  Future<void> close() {
    _activitySubscription?.cancel();
    _bannerTimer?.cancel();
    return super.close();
  }
}
