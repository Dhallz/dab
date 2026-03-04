import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/entities/activity.dart';
import '../../../core/abs_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends AbsBloc<DashboardEvent, DashboardState> {
  final ActivityUseCases _activityUseCases;
  StreamSubscription? _activitySubscription;

  DashboardBloc(this._activityUseCases) : super(const DashboardState()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardActivityReceived>(_onActivityReceived);
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    print('DEBUG: DashboardBloc _onStarted');
    emit(state.copyWith(status: DashboardStatus.loading));

    print('DEBUG: Fetching recent activities...');
    final result = await _activityUseCases.repository.getRecentActivities();
    print('DEBUG: Fetch completed. Success: ${result.isRight()}');

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (activities) {
        emit(
          state.copyWith(
            status: DashboardStatus.success,
            activities: activities,
          ),
        );

        // Start watching for live updates
        _activitySubscription?.cancel();
        _activitySubscription = _activityUseCases.watch().listen((activity) {
          add(DashboardActivityReceived(activity));
        });
      },
    );
  }

  void _onActivityReceived(
    DashboardActivityReceived event,
    Emitter<DashboardState> emit,
  ) {
    final activity = event.activity as Activity;
    final updatedList = [activity, ...state.activities];
    if (updatedList.length > 100) updatedList.removeLast();

    emit(state.copyWith(activities: updatedList));
  }

  @override
  Future<void> close() {
    _activitySubscription?.cancel();
    return super.close();
  }
}
