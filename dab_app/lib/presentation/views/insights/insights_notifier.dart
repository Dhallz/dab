import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/containers/metadata_usecases.dart';
import '../../../../domain/containers/user_usecases.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../domain/entities/activity/activity_search_query.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../../../services/service_locator.dart';
import '../../core/models/view_status.dart';
import 'insights_state.dart';
import 'models/insights_date_preset.dart';

/// **Former `InsightsEvent` types → methods:** `InsightsStarted` → [started];
/// `InsightsDatePresetChanged` → [setDatePreset]; `InsightsDateRangeChanged`
/// → [setDateRange]; `InsightsProviderToggled` → [toggleProvider];
/// `InsightsActivityCategoryToggled` → [toggleActivityCategory];
/// `InsightsUserToggled` → [toggleUser]; `InsightsRefreshRequested` → [refresh].
final insightsNotifierProvider =
    NotifierProvider.autoDispose<InsightsNotifier, InsightsState>(
      () => InsightsNotifier(
        sl.activityUseCases,
        sl.userUseCases,
        sl.metadataUseCases,
      ),
    );

class InsightsNotifier extends AutoDisposeNotifier<InsightsState> {
  InsightsNotifier(
    this._activityUseCases,
    this._userUseCases,
    this._metadataUseCases,
  );

  final ActivityUseCases _activityUseCases;
  final UserUseCases _userUseCases;
  final MetadataUseCases _metadataUseCases;

  @override
  InsightsState build() {
    return InsightsState.initial();
  }

  Future<void> started(String? connectedUserId) async {
    state = state.copyWith(status: ViewStatus.loading, errorMessage: null);
    final usersResult = await _userUseCases.getUsers.execute();
    final providerResult = await _metadataUseCases.getProviderConfigs.execute();

    var nextState = state;

    usersResult.fold((_) => null, (users) {
      final selectedUserIds = users.map((item) => item.id).toSet();
      nextState = nextState.copyWith(
        users: users,
        selectedUserIds: selectedUserIds,
      );
    });

    providerResult.fold((_) => null, (configs) {
      final activeConfigs = (configs as List)
          .whereType<ProviderConfig>()
          .where((config) => config.isActive)
          .toList();
      final providerIds = activeConfigs.map((item) => item.id).toList();
      final categories = activeConfigs
          .expand((config) => _categoriesForProvider(config.id))
          .toSet();
      nextState = nextState.copyWith(
        availableProviders: providerIds,
        selectedProviders: providerIds.toSet(),
        availableActivityCategories: categories,
        selectedActivityCategories: categories,
      );
    });

    if (connectedUserId != null &&
        nextState.users.any((user) => user.id == connectedUserId)) {
      nextState = nextState.copyWith(selectedUserIds: {connectedUserId});
    }

    state = nextState;
    await _fetchInsights();
  }

  Future<void> setDatePreset(InsightsDatePreset preset) async {
    final now = DateTime.now();
    final dayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final (startDate, endDate) = switch (preset) {
      InsightsDatePreset.today => (
        DateTime(now.year, now.month, now.day),
        dayEnd,
      ),
      InsightsDatePreset.last7Days => (
        dayEnd.subtract(const Duration(days: 6)),
        dayEnd,
      ),
      InsightsDatePreset.last30Days => (
        dayEnd.subtract(const Duration(days: 29)),
        dayEnd,
      ),
      InsightsDatePreset.custom => (state.startDate, state.endDate),
    };

    state = state.copyWith(
      datePreset: preset,
      startDate: startDate,
      endDate: endDate,
    );
    await _fetchInsights();
  }

  Future<void> setDateRange(DateTime startDate, DateTime endDate) async {
    final sd = startDate.isBefore(endDate) ? startDate : endDate;
    final ed = startDate.isBefore(endDate) ? endDate : startDate;
    state = state.copyWith(
      datePreset: InsightsDatePreset.custom,
      startDate: DateTime(sd.year, sd.month, sd.day),
      endDate: DateTime(ed.year, ed.month, ed.day, 23, 59, 59, 999),
    );
    await _fetchInsights();
  }

  Future<void> toggleProvider(String providerId) async {
    final selected = Set<String>.from(state.selectedProviders);
    if (selected.contains(providerId)) {
      selected.remove(providerId);
    } else {
      selected.add(providerId);
    }
    state = state.copyWith(selectedProviders: selected);
    await _fetchInsights();
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
    await _fetchInsights();
  }

  Future<void> toggleUser(String userId) async {
    final selected = Set<String>.from(state.selectedUserIds);
    if (selected.contains(userId)) {
      selected.remove(userId);
    } else {
      selected.add(userId);
    }
    state = state.copyWith(selectedUserIds: selected);
    await _fetchInsights();
  }

  Future<void> refresh() async {
    await _fetchInsights();
  }

  Future<void> _fetchInsights() async {
    if (state.selectedUserIds.isEmpty ||
        state.selectedProviders.isEmpty ||
        state.selectedActivityCategories.isEmpty) {
      state = state.copyWith(status: ViewStatus.success, activities: const []);
      return;
    }
    state = state.copyWith(status: ViewStatus.loading);

    // Team analytics: omit authored-only narrowing so connectors can use broad
    // windows (e.g. Phorge sprint search). authoredOnly: true needs per-user
    // external ids and often yields an empty remote response for Insights.
    final result = await _activityUseCases.searchActivities.execute(
      ActivitySearchQuery(
        startDate: state.startDate,
        endDate: state.endDate,
        users: state.selectedUserIds.toList(),
        providers: state.selectedProviders,
        coverageProviders: state.availableProviders.toSet(),
        categories: state.selectedActivityCategories,
        authoredOnly: false,
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
        final deduplicated = <String, Activity>{};
        for (final activity in activities) {
          deduplicated[activity.id] = activity;
        }
        state = state.copyWith(
          status: ViewStatus.success,
          activities: deduplicated.values.toList(),
          errorMessage: null,
        );
      },
    );
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
      case 'jira':
        return {ActivityCategory.task};
      default:
        return {ActivityCategory.generic};
    }
  }
}
