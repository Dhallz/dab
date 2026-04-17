import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/containers/activity_usecases.dart';
import '../../../domain/entities/activity/activity.dart';
import '../../core/models/view_status.dart';
import '../../core/abs_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends AbsBloc<DashboardEvent, DashboardState> {
  final ActivityUseCases _activityUseCases;
  StreamSubscription<Activity>? _activitySubscription;

  DashboardBloc(this._activityUseCases) : super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardActivityReceived>(_onActivityReceived);
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading, errorMessage: null));

    await _refreshLiveActivities(emit: emit, isInitialLoad: true);

    _activitySubscription?.cancel();
    _activitySubscription = _activityUseCases.watchActivities.execute().listen((
      activity,
    ) {
      add(DashboardActivityReceived(activity));
    });
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

  Future<void> _refreshLiveActivities({
    required Emitter<DashboardState> emit,
    required bool isInitialLoad,
  }) async {
    final result = await _activityUseCases.getLiveActivities.execute(limit: 50);
    result.fold(
      (failure) {
        if (isInitialLoad) {
          emit(
            state.copyWith(
              status: ViewStatus.failure,
              errorMessage: failure.message,
            ),
          );
        }
      },
      (activities) {
        if (emit.isDone) {
          return;
        }
        if (activities.isEmpty &&
            !isInitialLoad &&
            state.activities.isNotEmpty) {
          return;
        }

        emit(
          state.copyWith(
            status: ViewStatus.success,
            errorMessage: null,
            activities: activities,
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _activitySubscription?.cancel();
    return super.close();
  }
}
