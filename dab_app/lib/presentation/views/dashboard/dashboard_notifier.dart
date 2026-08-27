import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/containers/activity_usecases.dart';
import '../../../domain/containers/user_usecases.dart';
import '../../../domain/core/activity_follow_key.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../../domain/entities/activity/activity_live_event.dart';
import '../../../domain/entities/system/app_settings.dart';
import '../../../domain/entities/user/activity_follow.dart';
import '../../../domain/entities/user/follow_candidate.dart';
import '../../../services/service_locator.dart';
import '../../core/extensions/activity_extensions.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/models/view_status.dart';
import '../../features/app/app_lifecycle.dart';
import '../../features/app/app_notifier.dart';
import 'dashboard_state.dart';
import 'models/dashboard_feed_mode.dart';
import 'models/dashboard_provider_health.dart';

/// [ARCH: PRESENTATION]
/// ROLE: Dashboard screen state — live feed and archive triage.
/// CONTRACT: Subscribes to the activity WS stream; delegates I/O to use cases.
final dashboardNotifierProvider =
    NotifierProvider.autoDispose<DashboardNotifier, DashboardState>(
      () => DashboardNotifier(sl.activityUseCases, sl.userUseCases),
    );

/// [ARCH: PRESENTATION]
/// CONSTRAINTS: Delegates all I/O to use cases; never calls repositories or
/// data sources directly.
class DashboardNotifier extends AutoDisposeNotifier<DashboardState> {
  DashboardNotifier(
    this._activityUseCases,
    this._userUseCases, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final ActivityUseCases _activityUseCases;
  final UserUseCases _userUseCases;
  final DateTime Function() _now;

  StreamSubscription<ActivityLiveEvent>? _activitySubscription;
  Timer? _streamHealthTimer;
  Timer? _reconnectNoticeTimer;
  Timer? _followSearchTimer;
  DateTime? _lastLivePulseAt;
  bool _awaitingReconnectNotice = false;

  @override
  DashboardState build() {
    ref.onDispose(() {
      _activitySubscription?.cancel();
      _streamHealthTimer?.cancel();
      _reconnectNoticeTimer?.cancel();
      _followSearchTimer?.cancel();
    });
    ref.listen(
      appNotifierProvider.select(
        (s) => (configs: s.configs, statuses: s.providerConnectionStatuses),
      ),
      (previous, next) {
        state = state.copyWith(
          providerHealth: deriveDashboardProviderHealth(
            configs: next.configs,
            connectionStatuses: next.statuses,
            activities: state.activities,
          ),
        );
      },
    );
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

    final liveFuture = _activityUseCases.getLiveActivities.execute(
      limit: 150,
      includeArchived: true,
    );
    final followsFuture = _userUseCases.listMyActivityFollows.execute();
    final liveResult = await liveFuture;
    final followsResult = await followsFuture;
    final follows = followsResult.getOrElse((_) => const <ActivityFollow>[]);

    liveResult.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
          follows: follows,
          lastSyncedAt: now,
          reconnectNoticeAt: null,
          providerHealth: _providerHealthFor(state.activities),
        );
      },
      (activities) {
        state = state.copyWith(
          status: ViewStatus.success,
          errorMessage: null,
          activities: activities,
          follows: follows,
          providerHealth: _providerHealthFor(activities),
          lastSyncedAt: now,
          reconnectNoticeAt: null,
        );
      },
    );

    unawaited(_refreshFollowCandidates());

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
      print('[LIVE_CLIENT] dashboard_replace activity_id=${activity.id}');
      final updatedList = [
        activity,
        ...state.activities.where((item) => item.id != activity.id),
      ];
      if (updatedList.length > 100) updatedList.removeLast();
      state = state.copyWith(
        activities: updatedList,
        providerHealth: _providerHealthFor(updatedList),
        lastSyncedAt: now,
      );
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
      providerHealth: _providerHealthFor(updatedList),
      lastSyncedAt: now,
      reconnectNoticeAt: shouldShowReconnectNotice ? now : null,
    );
    unawaited(_notifyInbox(activity));
    if (shouldShowReconnectNotice) {
      _reconnectNoticeTimer?.cancel();
      _reconnectNoticeTimer = Timer(const Duration(seconds: 4), () {
        onReconnectNoticeCleared();
      });
    }
  }

  Future<void> _notifyInbox(Activity activity) async {
    final settings = ref.read(appNotifierProvider).settings;
    final focused = ref.read(appLifecycleProvider) == AppLifecycleState.resumed;
    final locale = settings.resolvedLocale ?? const Locale('en');
    final l10n = lookupAppLocalizations(locale);
    await _activityUseCases.notifyInboxActivity.execute(
      enabled: settings.inboxNotificationsEnabled,
      windowFocused: focused,
      notificationId: '${activity.id}:${activity.inboxLane.name}',
      title: activity.dashboardHeadline,
      body: activity.isFollowLane
          ? l10n.inboxNotificationFollowing
          : l10n.inboxNotificationDirected,
    );
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

  Future<void> follow(Activity activity) async {
    final providerId = activity.provider.followProviderId;
    final objectKey = activity.provider.followObjectKey;
    if (providerId == null || objectKey == null) return;
    final ref = followObjectRef(providerId, objectKey);
    if (state.followedObjectRefs.contains(ref)) return;
    final pin = ActivityFollow(
      providerId: providerId,
      objectKey: objectKey,
      title: activity.title,
      url: activity.url,
    );
    state = state.copyWith(follows: [...state.follows, pin]);
    final result = await _userUseCases.saveMyActivityFollow.execute(
      providerId: providerId,
      objectKey: objectKey,
      title: activity.title,
      url: activity.url,
    );
    result.fold(
      (_) {
        state = state.copyWith(
          follows: [
            for (final item in state.follows)
              if (item.objectRef != ref) item,
          ],
        );
      },
      (saved) {
        state = state.copyWith(
          follows: [
            for (final item in state.follows)
              if (item.objectRef == ref) saved else item,
          ],
        );
      },
    );
  }

  Future<void> followCandidate(FollowCandidate candidate) async {
    await follow(
      Activity(
        id: 'follow-candidate',
        userId: '',
        provider: _providerForCandidate(candidate),
        title: candidate.title,
        content: '',
        url: candidate.url,
        authorName: '',
        commentCount: 0,
        createdAt: _now().toUtc(),
      ),
    );
  }

  ActivityProvider _providerForCandidate(FollowCandidate candidate) {
    return activityProviderForFollow(
      providerId: candidate.providerId,
      objectKey: candidate.objectKey,
    );
  }

  void setFollowSearchQuery(String query) {
    if (state.followSearchQuery != query) {
      state = state.copyWith(followSearchQuery: query);
    }
    _followSearchTimer?.cancel();
    _followSearchTimer = Timer(const Duration(milliseconds: 350), () {
      unawaited(_refreshFollowCandidates());
    });
  }

  Future<void> _refreshFollowCandidates() async {
    final query = state.followSearchQuery;
    state = state.copyWith(followSearchStatus: ViewStatus.loading);
    final result = await _userUseCases.listMyFollowCandidates.execute(
      query: query,
    );
    if (state.followSearchQuery != query) return;
    result.fold(
      (_) {
        state = state.copyWith(
          followSearchStatus: ViewStatus.failure,
          followCandidates: const [],
        );
      },
      (rows) {
        state = state.copyWith(
          followSearchStatus: ViewStatus.success,
          followCandidates: rows,
        );
      },
    );
  }

  Future<void> unfollow(Activity activity) async {
    final providerId = activity.provider.followProviderId;
    final objectKey = activity.provider.followObjectKey;
    if (providerId == null || objectKey == null) return;
    await unfollowPin(
      ActivityFollow(providerId: providerId, objectKey: objectKey),
    );
  }

  Future<void> unfollowPin(ActivityFollow follow) async {
    final ref = follow.objectRef;
    if (!state.followedObjectRefs.contains(ref)) return;
    final previous = state.follows;
    state = state.copyWith(
      follows: [
        for (final item in state.follows)
          if (item.objectRef != ref) item,
      ],
    );
    final result = await _userUseCases.deleteMyActivityFollow.execute(
      providerId: follow.providerId,
      objectKey: follow.objectKey,
    );
    result.fold((_) {
      state = state.copyWith(follows: previous);
    }, (_) {});
  }

  void toggleArchivedVisibility() {
    state = state.copyWith(
      showArchivedActivities: !state.showArchivedActivities,
    );
  }

  /// Switches Live Now layout. Does not refetch.
  void setFeedMode(DashboardFeedMode mode) {
    if (state.feedMode == mode) return;
    state = state.copyWith(feedMode: mode);
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

  List<DashboardProviderHealth> _providerHealthFor(List<Activity> activities) {
    final app = ref.read(appNotifierProvider);
    return deriveDashboardProviderHealth(
      configs: app.configs,
      connectionStatuses: app.providerConnectionStatuses,
      activities: activities,
    );
  }
}
