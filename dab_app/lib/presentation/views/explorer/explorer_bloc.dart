import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/containers/metadata_usecases.dart';
import '../../../../domain/containers/user_usecases.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../domain/entities/activity/activity_search_query.dart';
import '../../../../domain/entities/group/group.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../core/models/view_status.dart';
import '../../core/abs_bloc.dart';
import 'explorer_event.dart';
import 'explorer_item.dart';
import 'explorer_state.dart';
import 'models/directory_type.dart';
import 'models/explorer_date_mode.dart';

class ExplorerBloc extends AbsBloc<ExplorerEvent, ExplorerState> {
  final ActivityUseCases _activityUseCases;
  final UserUseCases _userUseCases;
  final MetadataUseCases _metadataUseCases;
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
    on<ExplorerDateModeChanged>(_onDateModeChanged);
    on<ExplorerDateRangeChanged>(_onDateRangeChanged);
    on<ExplorerDirectoryTypeChanged>(_onDirectoryTypeChanged);
    on<ExplorerUserToggled>(_onUserToggled);
    on<ExplorerGroupToggled>(_onGroupToggled);
    on<ExplorerGroupRenamed>(_onGroupRenamed);
    on<ExplorerGroupDeleted>(_onGroupDeleted);
    on<ExplorerActivityCategoryToggled>(_onActivityCategoryToggled);
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
      final activeConfigs = (configs as List)
          .whereType<ProviderConfig>()
          .where((c) => c.isActive)
          .toList();
      final providerIds = activeConfigs.map((c) => c.id).toList();
      final availableCategories = activeConfigs
          .expand((config) => _categoriesForProvider(config.id))
          .toSet();
      newState = newState.copyWith(
        availableProviders: providerIds,
        selectedProviders: Set<String>.from(providerIds),
        availableActivityCategories: availableCategories,
        selectedActivityCategories: Set<ActivityCategory>.from(
          availableCategories,
        ),
      );
    });

    final connectedUserId = event.connectedUserId;
    if (connectedUserId != null &&
        newState.users.any((user) => user.id == connectedUserId)) {
      newState = newState.copyWith(selectedUserIds: {connectedUserId});
    }

    emit(newState);
    await _fetchActivities(emit);
  }

  Future<void> _onDateChanged(
    ExplorerDateChanged event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedDate: event.date,
        rangeStartDate: event.date,
        rangeEndDate: event.date,
        status: ViewStatus.loading,
      ),
    );
    await _fetchActivities(emit);
  }

  Future<void> _onDateModeChanged(
    ExplorerDateModeChanged event,
    Emitter<ExplorerState> emit,
  ) async {
    if (event.mode == state.dateMode) return;

    final nextState = state.copyWith(
      dateMode: event.mode,
      rangeStartDate: state.rangeStartDate ?? state.selectedDate,
      rangeEndDate: state.rangeEndDate ?? state.selectedDate,
    );
    emit(nextState.copyWith(status: ViewStatus.loading));
    await _fetchActivities(emit);
  }

  Future<void> _onDateRangeChanged(
    ExplorerDateRangeChanged event,
    Emitter<ExplorerState> emit,
  ) async {
    final start = event.startDate.isBefore(event.endDate)
        ? event.startDate
        : event.endDate;
    final end = event.startDate.isBefore(event.endDate)
        ? event.endDate
        : event.startDate;
    emit(
      state.copyWith(
        rangeStartDate: start,
        rangeEndDate: end,
        selectedDate: start,
        status: ViewStatus.loading,
      ),
    );
    await _fetchActivities(emit);
  }

  Future<void> _fetchActivities(Emitter<ExplorerState> emit) async {
    emit(state.copyWith(status: ViewStatus.loading));

    final targetIds = _resolveTargetUserIds();
    if (targetIds.isEmpty) {
      emit(state.copyWith(status: ViewStatus.success, items: const []));
      return;
    }

    final usersToSearch = targetIds.toList();
    final (startDate, endDate) = _resolveDateWindow();

    final result = await _activityUseCases.searchActivities.execute(
      ActivitySearchQuery(
        startDate: startDate,
        endDate: endDate,
        users: usersToSearch,
        providers: state.selectedProviders,
        coverageProviders: Set<String>.from(state.availableProviders),
        categories: state.selectedActivityCategories,
        authoredOnly: true,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (activities) {
        final items = groupActivities(activities);

        emit(state.copyWith(status: ViewStatus.success, items: items));
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
    final Map<String, List<Activity>> taskGroups = {};
    final Map<String, List<Activity>> slackConversationGroups = {};
    final Map<String, List<Activity>> slackBurstGroups = {};
    final List<String> taskOrder = [];
    final List<String> slackConversationOrder = [];
    final List<String> slackBurstOrder = [];

    for (final activity in cleanActivities) {
      final provider = activity.provider;
      if (provider is PhorgeTaskProvider && provider.taskPhid != null) {
        final key = '${activity.userId}_${provider.taskPhid}';
        if (!taskGroups.containsKey(key)) {
          taskGroups[key] = [];
          taskOrder.add(key);
        }
        taskGroups[key]!.add(activity);
      } else if (provider is SlackMessageProvider &&
          provider.channelId != null &&
          provider.threadTs != null) {
        final key = '${provider.channelId}:${provider.threadTs}';
        if (!slackConversationGroups.containsKey(key)) {
          slackConversationGroups[key] = [];
          slackConversationOrder.add(key);
        }
        slackConversationGroups[key]!.add(activity);
      } else if (provider is SlackMessageProvider &&
          provider.channelId != null &&
          provider.threadTs == null) {
        final key = _buildSlackBurstKey(activity, provider);
        if (!slackBurstGroups.containsKey(key)) {
          slackBurstGroups[key] = [];
          slackBurstOrder.add(key);
        }
        slackBurstGroups[key]!.add(activity);
      } else {
        items.add(SingleActivityItem(activity));
      }
    }

    for (final key in taskOrder) {
      final groupedActivities = taskGroups[key]!;
      if (groupedActivities.length == 1) {
        items.add(SingleActivityItem(groupedActivities.first));
      } else {
        final taskPhid =
            (groupedActivities.first.provider as PhorgeTaskProvider).taskPhid!;
        items.add(
          TaskActivityItem(
            activities: groupedActivities,
            taskId: taskPhid,
            userId: groupedActivities.first.userId,
          ),
        );
      }
    }

    for (final key in slackConversationOrder) {
      final groupedActivities = slackConversationGroups[key]!;
      if (groupedActivities.length == 1) {
        items.add(SingleActivityItem(groupedActivities.first));
      } else {
        final provider =
            groupedActivities.first.provider as SlackMessageProvider;
        items.add(
          SlackConversationItem(
            activities: groupedActivities,
            conversationKey: key,
            channelId: provider.channelId!,
            threadTs: provider.threadTs!,
          ),
        );
      }
    }

    for (final key in slackBurstOrder) {
      final groupedActivities = slackBurstGroups[key]!;
      if (groupedActivities.length == 1) {
        items.add(SingleActivityItem(groupedActivities.first));
      } else {
        final provider =
            groupedActivities.first.provider as SlackMessageProvider;
        final bucketId = _extractBucketIdFromSlackBurstKey(key);
        items.add(
          SlackConversationItem(
            activities: groupedActivities,
            conversationKey: key,
            channelId: provider.channelId!,
            threadTs: 'burst:$bucketId',
          ),
        );
      }
    }

    items.sort((a, b) {
      final dateA = _itemCreatedAt(a);
      final dateB = _itemCreatedAt(b);
      return dateB.compareTo(dateA);
    });

    return items;
  }

  DateTime _itemCreatedAt(ExplorerItem item) => switch (item) {
    SingleActivityItem(:final activity) => activity.createdAt,
    TaskActivityItem(:final activities) => activities.first.createdAt,
    SlackConversationItem(:final activities) => activities.first.createdAt,
  };

  String _buildSlackBurstKey(Activity activity, SlackMessageProvider provider) {
    final bucketEpoch =
        activity.createdAt.toUtc().millisecondsSinceEpoch ~/
        const Duration(minutes: 15).inMilliseconds;
    return '${provider.channelId}:${activity.userId}:$bucketEpoch';
  }

  String _extractBucketIdFromSlackBurstKey(String key) {
    final parts = key.split(':');
    return parts.isNotEmpty ? parts.last : key;
  }

  Set<ActivityCategory> _categoriesForProvider(String providerId) {
    final normalized = providerId.toLowerCase();
    switch (normalized) {
      case 'github':
        return {ActivityCategory.commit};
      case 'slack':
        return {ActivityCategory.message};
      case 'phorge':
        return {ActivityCategory.task, ActivityCategory.revision};
      default:
        return {ActivityCategory.generic};
    }
  }

  void _onDirectoryTypeChanged(
    ExplorerDirectoryTypeChanged event,
    Emitter<ExplorerState> emit,
  ) async {
    emit(state.copyWith(directoryType: event.type, status: ViewStatus.loading));
    await _fetchActivities(emit);
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
    await _fetchActivities(emit);
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
    await _fetchActivities(emit);
  }

  Future<void> _onGroupRenamed(
    ExplorerGroupRenamed event,
    Emitter<ExplorerState> emit,
  ) async {
    final group = state.groups.cast<Group?>().firstWhere(
      (g) => g?.id == event.groupId,
      orElse: () => null,
    );
    if (group == null) return;

    final result = await _userUseCases.saveGroup.execute(
      group.copyWith(name: event.name),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (savedGroup) {
        final updatedGroups = state.groups
            .map((g) => g.id == savedGroup.id ? savedGroup : g)
            .toList();
        emit(state.copyWith(groups: updatedGroups, status: ViewStatus.success));
      },
    );
  }

  Future<void> _onGroupDeleted(
    ExplorerGroupDeleted event,
    Emitter<ExplorerState> emit,
  ) async {
    final result = await _userUseCases.deleteGroup.execute(event.groupId);
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) async {
        final updatedGroups = state.groups
            .where((g) => g.id != event.groupId)
            .toList();
        final updatedSelectedGroups = Set<String>.from(state.selectedGroupIds)
          ..remove(event.groupId);
        emit(
          state.copyWith(
            groups: updatedGroups,
            selectedGroupIds: updatedSelectedGroups,
            status: ViewStatus.success,
          ),
        );
        await _fetchActivities(emit);
      },
    );
  }

  Future<void> _onActivityCategoryToggled(
    ExplorerActivityCategoryToggled event,
    Emitter<ExplorerState> emit,
  ) async {
    final selected = Set<ActivityCategory>.from(
      state.selectedActivityCategories,
    );
    if (selected.contains(event.category)) {
      selected.remove(event.category);
    } else {
      selected.add(event.category);
    }

    emit(state.copyWith(selectedActivityCategories: selected));
    await _fetchActivities(emit);
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
    await _fetchActivities(emit);
  }

  Future<void> _onRefreshRequested(
    ExplorerRefreshRequested event,
    Emitter<ExplorerState> emit,
  ) async {
    await _fetchActivities(emit);
  }

  void _onStackToggled(
    ExplorerStackToggled event,
    Emitter<ExplorerState> emit,
  ) {
    final updatedItems = state.items.map((item) {
      if (item is TaskActivityItem && item.taskId == event.taskId) {
        return item.copyWith(isExpanded: !item.isExpanded);
      }
      if (item is SlackConversationItem &&
          item.conversationKey == event.taskId) {
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
        final hasExisting = state.groups.any(
          (group) => group.id == savedGroup.id,
        );
        final updatedGroups = hasExisting
            ? state.groups
                  .map(
                    (group) => group.id == savedGroup.id ? savedGroup : group,
                  )
                  .toList()
            : [...state.groups, savedGroup];
        emit(state.copyWith(groups: updatedGroups, status: ViewStatus.success));
      },
    );
  }

  (DateTime, DateTime) _resolveDateWindow() {
    if (state.dateMode == ExplorerDateMode.range) {
      final startDate = state.rangeStartDate ?? state.selectedDate;
      final endDate = state.rangeEndDate ?? state.selectedDate;
      return (startDate, endDate);
    }
    return (state.selectedDate, state.selectedDate);
  }

  Set<String> _resolveTargetUserIds() {
    if (state.directoryType == DirectoryType.users) {
      return Set<String>.from(state.selectedUserIds);
    }

    final ids = <String>{};
    for (final groupId in state.selectedGroupIds) {
      final group = state.groups.cast<Group?>().firstWhere(
        (g) => g?.id == groupId,
        orElse: () => null,
      );
      if (group != null) {
        ids.addAll(group.members.map((m) => m.id));
      }
    }
    return ids;
  }
}
