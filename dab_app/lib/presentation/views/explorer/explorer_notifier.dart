import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/containers/metadata_usecases.dart';
import '../../../../domain/containers/user_usecases.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../domain/entities/activity/activity_search_query.dart';
import '../../../../domain/entities/group/group.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import 'explorer_state.dart';
import 'models/directory_type.dart';
import 'models/explorer_date_mode.dart';
import 'models/explorer_item.dart';

/// **Former `ExplorerEvent` types → methods:** `ExplorerStarted` → [started];
/// date changes → [scheduleDateChanged], [changeDateMode], [changeDateRange];
/// directory/filters → [setDirectoryType], [toggleUser], [toggleGroup],
/// [toggleProvider], [toggleActivityCategory]; groups → [renameGroup], [deleteGroup],
/// [saveGroup]; `ExplorerRefreshRequested` → [refresh]; `ExplorerStackToggled`
/// → [toggleStackExpanded].
///
/// **`ExplorerActivityReceived`:** not ported — Explorer is search-driven only;
/// live WS handling belongs on [DashboardNotifier].
final explorerNotifierProvider =
    NotifierProvider.autoDispose<ExplorerNotifier, ExplorerState>(
      () => ExplorerNotifier(
        sl.activityUseCases,
        sl.userUseCases,
        sl.metadataUseCases,
      ),
    );

class ExplorerNotifier extends AutoDisposeNotifier<ExplorerState> {
  final ActivityUseCases _activityUseCases;
  final UserUseCases _userUseCases;
  final MetadataUseCases _metadataUseCases;

  Timer? _dateDebounceTimer;

  ExplorerNotifier(
    this._activityUseCases,
    this._userUseCases,
    this._metadataUseCases,
  );

  @override
  ExplorerState build() {
    ref.onDispose(() {
      _dateDebounceTimer?.cancel();
    });
    return ExplorerState.initial();
  }

  Future<void> started(String? connectedUserId) async {
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
      (users) => newState = newState.copyWith(
        users: users,
        selectedUserIds: {for (final u in users) u.id},
      ),
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

    if (connectedUserId != null &&
        newState.users.any((user) => user.id == connectedUserId)) {
      newState = newState.copyWith(selectedUserIds: {connectedUserId});
    }

    state = newState;
    await _fetchActivities();
  }

  void scheduleDateChanged(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      rangeStartDate: date,
      rangeEndDate: date,
      status: ViewStatus.loading,
    );
    _dateDebounceTimer?.cancel();
    _dateDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _fetchActivities();
    });
  }

  Future<void> changeDateMode(ExplorerDateMode mode) async {
    if (mode == state.dateMode) return;

    final nextState = state.copyWith(
      dateMode: mode,
      rangeStartDate: state.rangeStartDate ?? state.selectedDate,
      rangeEndDate: state.rangeEndDate ?? state.selectedDate,
    );
    state = nextState.copyWith(status: ViewStatus.loading);
    await _fetchActivities();
  }

  Future<void> changeDateRange(DateTime startDate, DateTime endDate) async {
    final start = startDate.isBefore(endDate) ? startDate : endDate;
    final end = startDate.isBefore(endDate) ? endDate : startDate;
    state = state.copyWith(
      rangeStartDate: start,
      rangeEndDate: end,
      selectedDate: start,
      status: ViewStatus.loading,
    );
    await _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    state = state.copyWith(status: ViewStatus.loading);

    final targetIds = _resolveTargetUserIds();
    if (targetIds.isEmpty) {
      state = state.copyWith(status: ViewStatus.success, items: const []);
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
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (activities) {
        final items = groupActivities(activities);

        state = state.copyWith(status: ViewStatus.success, items: items);
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
      } else if (provider is JiraIssueProvider && provider.issueKey != null) {
        final key = '${activity.userId}_${provider.issueKey}';
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
      } else if (provider is TeamsMessageProvider &&
          provider.channelId != null &&
          provider.replyToId != null &&
          provider.replyToId!.isNotEmpty) {
        final key = '${provider.channelId}:${provider.replyToId}';
        if (!slackConversationGroups.containsKey(key)) {
          slackConversationGroups[key] = [];
          slackConversationOrder.add(key);
        }
        slackConversationGroups[key]!.add(activity);
      } else if (provider is TeamsMessageProvider &&
          provider.channelId != null) {
        final key = _buildTeamsBurstKey(activity, provider);
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
        final provider = groupedActivities.first.provider;
        final taskId = switch (provider) {
          PhorgeTaskProvider(:final taskPhid?) => taskPhid,
          JiraIssueProvider(:final issueKey?) => issueKey,
          _ => groupedActivities.first.id,
        };
        items.add(
          TaskActivityItem(
            activities: groupedActivities,
            taskId: taskId,
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

  String _buildTeamsBurstKey(Activity activity, TeamsMessageProvider provider) {
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
      case 'teams':
        return {ActivityCategory.message};
      case 'phorge':
        return {ActivityCategory.task, ActivityCategory.revision};
      case 'jira':
        return {ActivityCategory.task};
      default:
        return {ActivityCategory.generic};
    }
  }

  Future<void> setDirectoryType(DirectoryType type) async {
    state = state.copyWith(directoryType: type, status: ViewStatus.loading);
    await _fetchActivities();
  }

  Future<void> toggleUser(String userId) async {
    final updated = Set<String>.from(state.selectedUserIds);
    if (updated.contains(userId)) {
      updated.remove(userId);
    } else {
      updated.add(userId);
    }
    state = state.copyWith(selectedUserIds: updated);
    await _fetchActivities();
  }

  Future<void> toggleGroup(String groupId) async {
    final updated = Set<String>.from(state.selectedGroupIds);
    if (updated.contains(groupId)) {
      updated.remove(groupId);
    } else {
      updated.add(groupId);
    }
    state = state.copyWith(selectedGroupIds: updated);
    await _fetchActivities();
  }

  Future<void> renameGroup(String groupId, String name) async {
    final group = state.groups.cast<Group?>().firstWhere(
      (g) => g?.id == groupId,
      orElse: () => null,
    );
    if (group == null) return;

    final result = await _userUseCases.saveGroup.execute(
      group.copyWith(name: name),
    );
    result.fold(
      (failure) {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (savedGroup) {
        final updatedGroups = state.groups
            .map((g) => g.id == savedGroup.id ? savedGroup : g)
            .toList();
        state = state.copyWith(
          groups: updatedGroups,
          status: ViewStatus.success,
        );
      },
    );
  }

  Future<void> deleteGroup(String groupId) async {
    final result = await _userUseCases.deleteGroup.execute(groupId);
    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (_) async {
        final updatedGroups = state.groups
            .where((g) => g.id != groupId)
            .toList();
        final updatedSelectedGroups = Set<String>.from(state.selectedGroupIds)
          ..remove(groupId);
        state = state.copyWith(
          groups: updatedGroups,
          selectedGroupIds: updatedSelectedGroups,
          status: ViewStatus.success,
        );
        await _fetchActivities();
      },
    );
  }

  Future<void> toggleActivityCategory(ActivityCategory category) async {
    final selected = Set<ActivityCategory>.from(
      state.selectedActivityCategories,
    );
    if (selected.contains(category)) {
      selected.remove(category);
    } else {
      selected.add(category);
    }

    state = state.copyWith(selectedActivityCategories: selected);
    await _fetchActivities();
  }

  Future<void> toggleProvider(String provider) async {
    final selected = Set<String>.from(state.selectedProviders);
    if (selected.contains(provider)) {
      selected.remove(provider);
    } else {
      selected.add(provider);
    }

    state = state.copyWith(selectedProviders: selected);
    await _fetchActivities();
  }

  Future<void> refresh() async {
    await _fetchActivities();
  }

  void toggleStackExpanded(String taskId) {
    final updatedItems = state.items.map((item) {
      if (item is TaskActivityItem && item.taskId == taskId) {
        return item.copyWith(isExpanded: !item.isExpanded);
      }
      if (item is SlackConversationItem && item.conversationKey == taskId) {
        return item.copyWith(isExpanded: !item.isExpanded);
      }
      return item;
    }).toList();
    state = state.copyWith(items: updatedItems);
  }

  Future<void> saveGroup(Group group) async {
    final result = await _userUseCases.saveGroup.execute(group);
    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: ViewStatus.failure,
          errorMessage: failure.message,
        );
      },
      (savedGroup) async {
        final hasExisting = state.groups.any((g) => g.id == savedGroup.id);
        final updatedGroups = hasExisting
            ? state.groups
                  .map((g) => g.id == savedGroup.id ? savedGroup : g)
                  .toList()
            : [...state.groups, savedGroup];
        state = state.copyWith(
          groups: updatedGroups,
          status: ViewStatus.success,
        );
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
