import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/containers/activity_usecases.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_live_event.dart';
import '../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_notifier.dart';
import 'dashboard_state.dart';
import 'models/dashboard_provider_health.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Dashboard screen state — live feed and archive triage.
/// CONTRACT: Subscribes to the activity WS stream; delegates I/O to use cases.
final dashboardNotifierProvider =
    NotifierProvider.autoDispose<DashboardNotifier, DashboardState>(
      () => DashboardNotifier(sl.activityUseCases),
    );

/// [ARCH: PRESENTATION]
/// CONSTRAINTS: Delegates all I/O to use cases; never calls repositories or
/// data sources directly.
class DashboardNotifier extends AutoDisposeNotifier<DashboardState> {
  DashboardNotifier(
    this._activityUseCases, {
    DateTime Function()? now,
    bool Function()? isPersonalDeployment,
  }) : _now = now ?? DateTime.now,
       _isPersonalDeployment = isPersonalDeployment;

  final ActivityUseCases _activityUseCases;
  final DateTime Function() _now;
  final bool Function()? _isPersonalDeployment;

  StreamSubscription<ActivityLiveEvent>? _activitySubscription;
  Timer? _streamHealthTimer;
  Timer? _reconnectNoticeTimer;
  DateTime? _lastLivePulseAt;
  bool _awaitingReconnectNotice = false;

  @override
  DashboardState build() {
    ref.onDispose(() {
      _activitySubscription?.cancel();
      _streamHealthTimer?.cancel();
      _reconnectNoticeTimer?.cancel();
    });
    Future.microtask(start);
    return const DashboardState();
  }

  Future<void> start() async {
    final now = _now();
    _lastLivePulseAt = now;
    _awaitingReconnectNotice = false;
    _streamHealthTimer?.cancel();
    _reconnectNoticeTimer?.cancel();
    state = state.copyWith(status: ViewStatus.loading, errorMessage: null);

    final isPersonal =
        _isPersonalDeployment?.call() ??
        ref.read(appNotifierProvider).isPersonalDeployment;
    final liveResult = await _activityUseCases.getLiveActivities.execute(
      limit: 50,
      includeArchived: true,
      global: isPersonal,
    );

    liveResult.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
          lastSyncedAt: now,
          reconnectNoticeAt: null,
        );
      },
      (activities) {
        state = state.copyWith(
          status: ViewStatus.success,
          errorMessage: null,
          activities: activities,
          providerHealth: _deriveProviderHealth(activities, now),
          lastSyncedAt: now,
          reconnectNoticeAt: null,
        );
      },
    );

    _activitySubscription?.cancel();
    _activitySubscription = _activityUseCases.watchActivities.execute().listen((
      event,
    ) {
      switch (event) {
        case ActivityReceivedEvent(:final activity):
          onActivityReceived(activity);
        case ActivityArchivedEvent(:final activityId):
          onActivityArchivedRemotely(activityId);
        case ActivityUnarchivedEvent(:final activityId):
          onActivityUnarchivedRemotely(activityId);
      }
    });

    _streamHealthTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final lastPulse = _lastLivePulseAt;
      if (lastPulse == null) return;
      if (_now().difference(lastPulse) > const Duration(seconds: 20)) {
        _awaitingReconnectNotice = true;
      }
    });
  }

  void onActivityReceived(Activity activity) {
    final now = _now();
    _lastLivePulseAt = now;
    // ignore: avoid_print
    print(
      '[LIVE_CLIENT] dashboard_notifier activity_id=${activity.id} user_id=${activity.userId}',
    );
    if (state.activities.any((item) => item.id == activity.id)) {
      // ignore: avoid_print
      print('[LIVE_CLIENT] dashboard_dedup activity_id=${activity.id}');
      return;
    }
    final updatedList = [activity, ...state.activities];
    if (updatedList.length > 100) updatedList.removeLast();

    // ignore: avoid_print
    print(
      '[LIVE_CLIENT] dashboard_state_updated total=${updatedList.length} newest=${activity.id}',
    );
    final shouldShowReconnectNotice = _awaitingReconnectNotice;
    _awaitingReconnectNotice = false;
    state = state.copyWith(
      activities: updatedList,
      providerHealth: _deriveProviderHealth(updatedList, now),
      lastSyncedAt: now,
      reconnectNoticeAt: shouldShowReconnectNotice ? now : null,
    );
    if (shouldShowReconnectNotice) {
      _reconnectNoticeTimer?.cancel();
      _reconnectNoticeTimer = Timer(const Duration(seconds: 4), () {
        onReconnectNoticeCleared();
      });
    }
  }

  void onActivityArchivedRemotely(String activityId) {
    _lastLivePulseAt = _now();
    _updateArchiveFlag(activityId, archived: true);
  }

  void onActivityUnarchivedRemotely(String activityId) {
    _lastLivePulseAt = _now();
    _updateArchiveFlag(activityId, archived: false);
  }

  Future<void> requestArchive(String activityId) async {
    final index = state.activities.indexWhere((a) => a.id == activityId);
    if (index < 0) return;
    final previouslyArchived = state.activities[index].archived;

    _updateArchiveFlag(activityId, archived: true);
    final result = await _activityUseCases.archiveLiveActivity.execute(
      activityId,
    );
    result.fold((_) {
      _updateArchiveFlag(activityId, archived: previouslyArchived);
    }, (_) {});
  }

  Future<void> requestUnarchive(String activityId) async {
    final index = state.activities.indexWhere((a) => a.id == activityId);
    if (index < 0) return;
    final previouslyArchived = state.activities[index].archived;

    _updateArchiveFlag(activityId, archived: false);
    final result = await _activityUseCases.unarchiveLiveActivity.execute(
      activityId,
    );
    result.fold((_) {
      _updateArchiveFlag(activityId, archived: previouslyArchived);
    }, (_) {});
  }

  void toggleArchivedVisibility() {
    state = state.copyWith(
      showArchivedActivities: !state.showArchivedActivities,
    );
  }

  void onReconnectNoticeCleared() {
    if (state.reconnectNoticeAt == null) return;
    state = state.copyWith(reconnectNoticeAt: null);
  }

  void _updateArchiveFlag(String activityId, {required bool archived}) {
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
    state = state.copyWith(activities: updated);
  }

  List<DashboardProviderHealth> _deriveProviderHealth(
    List<Activity> activities,
    DateTime now,
  ) {
    if (activities.isEmpty) return const [];

    final byProvider = <String, DateTime>{};
    for (final activity in activities) {
      final current = byProvider[activity.provider.name];
      if (current == null || activity.createdAt.isAfter(current)) {
        byProvider[activity.provider.name] = activity.createdAt;
      }
    }

    final health = byProvider.entries.map((entry) {
      final elapsed = now.difference(entry.value);
      final status = elapsed <= const Duration(minutes: 5)
          ? DashboardProviderHealthStatus.live
          : elapsed <= const Duration(minutes: 30)
          ? DashboardProviderHealthStatus.degraded
          : DashboardProviderHealthStatus.offline;
      return DashboardProviderHealth(
        providerName: entry.key,
        status: status,
        lastEventAt: entry.value,
      );
    }).toList();

    health.sort((a, b) => a.providerName.compareTo(b.providerName));
    return health;
  }
}
