import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/containers/metadata_usecases.dart';
import '../../../../domain/containers/user_usecases.dart';
import '../../../../domain/entities/activity.dart';
import '../../../../domain/entities/group.dart';
import '../../core/abs_bloc.dart';
import 'explorer_event.dart';
import 'explorer_state.dart';

class ExplorerBloc extends AbsBloc<ExplorerEvent, ExplorerState> {
  final ActivityUseCases _activityUseCases;
  final UserUseCases _userUseCases;
  final MetadataUseCases _metadataUseCases;
  StreamSubscription? _activitySubscription;

  ExplorerBloc(
    this._activityUseCases,
    this._userUseCases,
    this._metadataUseCases,
  ) : super(ExplorerState.initial()) {
    on<ExplorerStarted>(_onStarted);
    on<ExplorerDateChanged>(
      _onDateChanged,
      transformer: (events, mapper) =>
          events.debounce(const Duration(milliseconds: 300)).switchMap(mapper),
    );
    on<ExplorerActivityReceived>(_onActivityReceived);
    on<ExplorerDirectoryTypeChanged>(_onDirectoryTypeChanged);
    on<ExplorerUserToggled>(_onUserToggled);
    on<ExplorerGroupToggled>(_onGroupToggled);
    on<ExplorerProviderToggled>(_onProviderToggled);
    on<ExplorerRefreshRequested>(_onRefreshRequested);
    on<ExplorerGroupSaved>(_onGroupSaved);
  }

  Future<void> _onStarted(
    ExplorerStarted event,
    Emitter<ExplorerState> emit,
  ) async {
    final results = await Future.wait([
      _userUseCases.getUsers(),
      _userUseCases.getGroups(),
      _metadataUseCases.getProviderConfigs.execute(),
    ]);

    final usersResult = results[0] as dynamic;
    final groupsResult = results[1] as dynamic;
    final providerResult = results[2] as dynamic;

    var newState = state;

    usersResult.fold(
      (l) => null,
      (users) => newState = newState.copyWith(users: users),
    );
    groupsResult.fold(
      (l) => null,
      (groups) => newState = newState.copyWith(groups: groups),
    );
    providerResult.fold((failure) => null, (configs) {
      final providerIds = configs
          .map((c) => c.id as String)
          .toList()
          .cast<String>();
      newState = newState.copyWith(
        availableProviders: providerIds,
        selectedProviders: Set<String>.from(providerIds),
      );
    });

    emit(newState);
    await _fetchActivities(emit, newState.selectedDate);
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

    final Set<String> targetIds = {...state.selectedUserIds};

    if (state.selectedGroupIds.isNotEmpty) {
      for (final groupId in state.selectedGroupIds) {
        final group = state.groups.cast<Group?>().firstWhere(
          (g) => g?.id == groupId,
          orElse: () => null,
        );
        if (group != null) {
          targetIds.addAll(group.members.map((m) => m.id));
        }
      }
    }

    final usersToSearch = targetIds.isEmpty ? null : targetIds.toList();

    final result = await _activityUseCases.repository.searchActivities(
      startDate: date,
      endDate: date,
      users: usersToSearch,
      authoredOnly: true,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ExplorerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (activities) {
        final lowerSelected = state.selectedProviders
            .map((e) => e.toLowerCase())
            .toSet();

        final filteredActivities = activities.where((a) {
          return lowerSelected.contains(a.provider.name.toLowerCase());
        }).toList();

        emit(
          state.copyWith(
            status: ExplorerStatus.success,
            activities: filteredActivities,
          ),
        );

        _activitySubscription?.cancel();
        _activitySubscription = _activityUseCases.watch().listen((activity) {
          add(ExplorerActivityReceived(activity));
        });
      },
    );
  }

  void _onDirectoryTypeChanged(
    ExplorerDirectoryTypeChanged event,
    Emitter<ExplorerState> emit,
  ) {
    emit(state.copyWith(directoryType: event.type));
  }

  Future<void> _onUserToggled(
    ExplorerUserToggled event,
    Emitter<ExplorerState> emit,
  ) async {
    final updated = Set<String>.from(state.selectedUserIds);
    if (updated.contains(event.userId)) {
      updated.remove(event.userId);
    } else {
      updated.add(event.userId);
    }
    emit(state.copyWith(selectedUserIds: updated));
    await _fetchActivities(emit, state.selectedDate);
  }

  Future<void> _onGroupToggled(
    ExplorerGroupToggled event,
    Emitter<ExplorerState> emit,
  ) async {
    final updated = Set<String>.from(state.selectedGroupIds);
    if (updated.contains(event.groupId)) {
      updated.remove(event.groupId);
    } else {
      updated.add(event.groupId);
    }
    emit(state.copyWith(selectedGroupIds: updated));
    await _fetchActivities(emit, state.selectedDate);
  }

  FutureOr<void> _onProviderToggled(
    ExplorerProviderToggled event,
    Emitter<ExplorerState> emit,
  ) async {
    final selected = Set<String>.from(state.selectedProviders);
    if (selected.contains(event.provider)) {
      selected.remove(event.provider);
    } else {
      selected.add(event.provider);
    }

    emit(state.copyWith(selectedProviders: selected));
    await _fetchActivities(emit, state.selectedDate);
  }

  Future<void> _onRefreshRequested(
    ExplorerRefreshRequested event,
    Emitter<ExplorerState> emit,
  ) async {
    await _fetchActivities(emit, state.selectedDate);
  }

  void _onActivityReceived(
    ExplorerActivityReceived event,
    Emitter<ExplorerState> emit,
  ) {
    if (event.activity is! Activity) return;
    final activity = event.activity as Activity;

    final lowerSelected = state.selectedProviders
        .map((e) => e.toLowerCase())
        .toSet();
    if (!lowerSelected.contains(activity.provider.name.toLowerCase())) {
      return;
    }

    final updatedList = [activity, ...state.activities];
    if (updatedList.length > 100) updatedList.removeLast();

    emit(state.copyWith(activities: updatedList));
  }

  Future<void> _onGroupSaved(
    ExplorerGroupSaved event,
    Emitter<ExplorerState> emit,
  ) async {
    final result = await _userUseCases.saveGroup(event.group);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ExplorerStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (savedGroup) async {
        final updatedGroups = [...state.groups, savedGroup];
        emit(
          state.copyWith(groups: updatedGroups, status: ExplorerStatus.success),
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
