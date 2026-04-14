import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/containers/activity_usecases.dart';
import '../../../../domain/containers/metadata_usecases.dart';
import '../../../../domain/containers/user_usecases.dart';
import '../../../../domain/entities/activity/activity.dart';
import '../../../../domain/entities/activity/activity_category.dart';
import '../../../../domain/entities/activity/activity_search_query.dart';
import '../../../../domain/entities/provider/provider_config.dart';
import '../../core/abs_bloc.dart';
import '../../core/models/view_status.dart';
import 'insights_event.dart';
import 'insights_state.dart';
import 'models/insights_date_preset.dart';

class InsightsBloc extends AbsBloc<InsightsEvent, InsightsState> {
  final ActivityUseCases _activityUseCases;
  final UserUseCases _userUseCases;
  final MetadataUseCases _metadataUseCases;

  InsightsBloc(
    this._activityUseCases,
    this._userUseCases,
    this._metadataUseCases,
  ) : super(InsightsState.initial()) {
    on<InsightsStarted>(_onStarted);
    on<InsightsDatePresetChanged>(_onDatePresetChanged);
    on<InsightsDateRangeChanged>(_onDateRangeChanged);
    on<InsightsProviderToggled>(_onProviderToggled);
    on<InsightsActivityCategoryToggled>(_onActivityCategoryToggled);
    on<InsightsUserToggled>(_onUserToggled);
    on<InsightsRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onStarted(
    InsightsStarted event,
    Emitter<InsightsState> emit,
  ) async {
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

    if (event.connectedUserId != null &&
        nextState.users.any((user) => user.id == event.connectedUserId)) {
      nextState = nextState.copyWith(selectedUserIds: {event.connectedUserId!});
    }

    emit(nextState);
    await _fetchInsights(emit);
  }

  Future<void> _onDatePresetChanged(
    InsightsDatePresetChanged event,
    Emitter<InsightsState> emit,
  ) async {
    final now = DateTime.now();
    final dayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    final (startDate, endDate) = switch (event.preset) {
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

    emit(
      state.copyWith(
        datePreset: event.preset,
        startDate: startDate,
        endDate: endDate,
      ),
    );
    await _fetchInsights(emit);
  }

  Future<void> _onDateRangeChanged(
    InsightsDateRangeChanged event,
    Emitter<InsightsState> emit,
  ) async {
    final startDate = event.startDate.isBefore(event.endDate)
        ? event.startDate
        : event.endDate;
    final endDate = event.startDate.isBefore(event.endDate)
        ? event.endDate
        : event.startDate;
    emit(
      state.copyWith(
        datePreset: InsightsDatePreset.custom,
        startDate: DateTime(startDate.year, startDate.month, startDate.day),
        endDate: DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
          999,
        ),
      ),
    );
    await _fetchInsights(emit);
  }

  Future<void> _onProviderToggled(
    InsightsProviderToggled event,
    Emitter<InsightsState> emit,
  ) async {
    final selected = Set<String>.from(state.selectedProviders);
    if (selected.contains(event.providerId)) {
      selected.remove(event.providerId);
    } else {
      selected.add(event.providerId);
    }
    emit(state.copyWith(selectedProviders: selected));
    await _fetchInsights(emit);
  }

  Future<void> _onActivityCategoryToggled(
    InsightsActivityCategoryToggled event,
    Emitter<InsightsState> emit,
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
    await _fetchInsights(emit);
  }

  Future<void> _onUserToggled(
    InsightsUserToggled event,
    Emitter<InsightsState> emit,
  ) async {
    final selected = Set<String>.from(state.selectedUserIds);
    if (selected.contains(event.userId)) {
      selected.remove(event.userId);
    } else {
      selected.add(event.userId);
    }
    emit(state.copyWith(selectedUserIds: selected));
    await _fetchInsights(emit);
  }

  Future<void> _onRefreshRequested(
    InsightsRefreshRequested event,
    Emitter<InsightsState> emit,
  ) async {
    await _fetchInsights(emit);
  }

  Future<void> _fetchInsights(Emitter<InsightsState> emit) async {
    if (state.selectedUserIds.isEmpty ||
        state.selectedProviders.isEmpty ||
        state.selectedActivityCategories.isEmpty) {
      emit(state.copyWith(status: ViewStatus.success, activities: const []));
      return;
    }
    emit(state.copyWith(status: ViewStatus.loading));

    final result = await _activityUseCases.searchActivities.execute(
      ActivitySearchQuery(
        startDate: state.startDate,
        endDate: state.endDate,
        users: state.selectedUserIds.toList(),
        providers: state.selectedProviders,
        coverageProviders: state.availableProviders.toSet(),
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
        final deduplicated = <String, Activity>{};
        for (final activity in activities) {
          deduplicated[activity.id] = activity;
        }
        emit(
          state.copyWith(
            status: ViewStatus.success,
            activities: deduplicated.values.toList(),
            errorMessage: null,
          ),
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
      default:
        return {ActivityCategory.generic};
    }
  }
}
