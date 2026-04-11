import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/containers/metadata_usecases.dart';
import '../../../../domain/containers/user_usecases.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/group/group.dart';
import '../../core/models/view_status.dart';
import '../../core/abs_bloc.dart';
import 'explorer_event.dart';
import 'explorer_item.dart';
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
    on<ExplorerStackToggled>(_onStackToggled);
  }

  Future<void> _onStarted(
    ExplorerStarted event,
    Emitter<ExplorerState> emit,
  ) async {
    final results = await Future.wait([
      _userUseCases.getUsers.execute(),
      _userUseCases.getGroups.execute(),
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
      state.copyWith(selectedDate: event.date, status: ViewStatus.loading),
    );
    await _fetchActivities(emit, event.date);
  }

  Future<void> _fetchActivities(
    Emitter<ExplorerState> emit,
    DateTime date,
  ) async {
    emit(state.copyWith(status: ViewStatus.loading));

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

    final result = await _activityUseCases.searchActivities.execute(
      startDate: date,
      endDate: date,
      users: usersToSearch,
      authoredOnly: true,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
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

        final items = groupActivities(filteredActivities);

        emit(state.copyWith(status: ViewStatus.success, items: items));

        _activitySubscription?.cancel();
        _activitySubscription = _activityUseCases.watchActivities
            .execute()
            .listen((activity) {
              add(ExplorerActivityReceived(activity));
            });
      },
    );
  }

  List<ExplorerItem> groupActivities(List<Activity> activities) {
    if (activities.isEmpty) return [];

    // Deduplicate by ID
    final deduplicated = <String, Activity>{};
    for (final a in activities) {
      deduplicated[a.id] = a;
    }
    final cleanActivities = deduplicated.values.toList();

    final List<ExplorerItem> items = [];
    final Map<String, List<Activity>> groups = {};
    final List<String> taskOrder = [];

    for (final activity in cleanActivities) {
      final provider = activity.provider;
      if (provider is PhorgeTaskProvider && provider.taskPhid != null) {
        final key = '${activity.userId}_${provider.taskPhid}';
        if (!groups.containsKey(key)) {
          groups[key] = [];
          taskOrder.add(key);
        }
        groups[key]!.add(activity);
      } else {
        items.add(SingleActivityItem(activity));
      }
    }

    for (final key in taskOrder) {
      final groupActivities = groups[key]!;
      if (groupActivities.length == 1) {
        items.add(SingleActivityItem(groupActivities.first));
      } else {
        final taskPhid =
            (groupActivities.first.provider as PhorgeTaskProvider).taskPhid!;
        items.add(
          TaskActivityItem(
            activities: groupActivities,
            taskId: taskPhid,
            userId: groupActivities.first.userId,
          ),
        );
      }
    }

    items.sort((a, b) {
      final dateA = a is SingleActivityItem
          ? a.activity.createdAt
          : (a as TaskActivityItem).activities.first.createdAt;
      final dateB = b is SingleActivityItem
          ? b.activity.createdAt
          : (b as TaskActivityItem).activities.first.createdAt;
      return dateB.compareTo(dateA);
    });

    return items;
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

    // Optimization: Add to existing groups or insert at correct position
    // instead of fully re-grouping and re-sorting.
    final List<ExplorerItem> updatedItems = List.from(state.items);

    // If it's a Phorge task, check if a group already exists
    if (activity.provider is PhorgeTaskProvider) {
      final provider = activity.provider as PhorgeTaskProvider;
      final existingIndex = updatedItems.indexWhere(
        (item) => item is TaskActivityItem && item.taskId == provider.taskPhid,
      );

      if (existingIndex != -1) {
        final existingItem = updatedItems[existingIndex] as TaskActivityItem;
        updatedItems[existingIndex] = TaskActivityItem(
          activities: [activity, ...existingItem.activities]
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          taskId: existingItem.taskId,
          userId: existingItem.userId,
        );
        emit(state.copyWith(items: updatedItems));
        return;
      }
    }

    // Otherwise, insert at the correct position to maintain sort order
    final newItem = SingleActivityItem(activity);
    int insertIndex = updatedItems.indexWhere((item) {
      final itemDate = item is SingleActivityItem
          ? item.activity.createdAt
          : (item as TaskActivityItem).activities.first.createdAt;
      return activity.createdAt.isAfter(itemDate);
    });

    if (insertIndex == -1) {
      updatedItems.add(newItem);
    } else {
      updatedItems.insert(insertIndex, newItem);
    }

    // Limit to 200 items
    if (updatedItems.length > 200) {
      updatedItems.removeLast();
    }

    emit(state.copyWith(items: updatedItems));
  }

  void _onStackToggled(
    ExplorerStackToggled event,
    Emitter<ExplorerState> emit,
  ) {
    final updatedItems = state.items.map((item) {
      if (item is TaskActivityItem && item.taskId == event.taskId) {
        return item.copyWith(isExpanded: !item.isExpanded);
      }
      return item;
    }).toList();
    emit(state.copyWith(items: updatedItems));
  }

  Future<void> _onGroupSaved(
    ExplorerGroupSaved event,
    Emitter<ExplorerState> emit,
  ) async {
    final result = await _userUseCases.saveGroup.execute(event.group);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (savedGroup) async {
        final updatedGroups = [...state.groups, savedGroup];
        emit(
          state.copyWith(groups: updatedGroups, status: ViewStatus.success),
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
