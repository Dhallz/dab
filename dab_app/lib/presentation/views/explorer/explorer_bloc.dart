import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/entities/activity.dart';
import '../../core/abs_bloc.dart';
import 'explorer_event.dart';
import 'explorer_state.dart';

class ExplorerBloc extends AbsBloc<ExplorerEvent, ExplorerState> {
  final ActivityUseCases _activityUseCases;
  StreamSubscription? _activitySubscription;

  ExplorerBloc(this._activityUseCases) : super(ExplorerState.initial()) {
    on<ExplorerStarted>(_onStarted);
    on<ExplorerDateChanged>(_onDateChanged);
    on<ExplorerActivityReceived>(_onActivityReceived);
  }

  Future<void> _onStarted(
    ExplorerStarted event,
    Emitter<ExplorerState> emit,
  ) async {
    await _fetchActivities(emit, state.selectedDate);
  }

  Future<void> _onDateChanged(
    ExplorerDateChanged event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(
      state.copyWith(selectedDate: event.date, status: ExplorerStatus.loading),
    );
    await _fetchActivities(emit, event.date);
  }

  Future<void> _fetchActivities(
    Emitter<ExplorerState> emit,
    DateTime date,
  ) async {
    emit(state.copyWith(status: ExplorerStatus.loading));

    print(
      'DEBUG: ExplorerBloc._fetchActivities calling repository.searchActivities for date $date',
    );
    final result = await _activityUseCases.repository.searchActivities(
      startDate: date,
      endDate: date,
      authoredOnly: true,
    );

    print('DEBUG: ExplorerBloc._fetchActivities result received: $result');
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExplorerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (activities) {
        emit(
          state.copyWith(
            status: ExplorerStatus.success,
            activities: activities,
          ),
        );

        _activitySubscription?.cancel();
        _activitySubscription = _activityUseCases.watch().listen((activity) {
          add(ExplorerActivityReceived(activity));
        });
      },
    );
  }

  void _onActivityReceived(
    ExplorerActivityReceived event,
    Emitter<ExplorerState> emit,
  ) {
    if (event.activity is! Activity) return;
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
