import 'package:dart_mappable/dart_mappable.dart';

import '../../../../domain/entities/activity/activity_category.dart';
import 'models/insights_date_preset.dart';

part 'insights_event.mapper.dart';

@MappableClass()
sealed class InsightsEvent with InsightsEventMappable {
  const InsightsEvent();
}

@MappableClass()
class InsightsStarted extends InsightsEvent with InsightsStartedMappable {
  final String? connectedUserId;
  const InsightsStarted({this.connectedUserId});
}

@MappableClass()
class InsightsDatePresetChanged extends InsightsEvent
    with InsightsDatePresetChangedMappable {
  final InsightsDatePreset preset;
  const InsightsDatePresetChanged(this.preset);
}

@MappableClass()
class InsightsDateRangeChanged extends InsightsEvent
    with InsightsDateRangeChangedMappable {
  final DateTime startDate;
  final DateTime endDate;

  const InsightsDateRangeChanged({
    required this.startDate,
    required this.endDate,
  });
}

@MappableClass()
class InsightsProviderToggled extends InsightsEvent
    with InsightsProviderToggledMappable {
  final String providerId;
  const InsightsProviderToggled(this.providerId);
}

@MappableClass()
class InsightsActivityCategoryToggled extends InsightsEvent
    with InsightsActivityCategoryToggledMappable {
  final ActivityCategory category;
  const InsightsActivityCategoryToggled(this.category);
}

@MappableClass()
class InsightsUserToggled extends InsightsEvent
    with InsightsUserToggledMappable {
  final String userId;
  const InsightsUserToggled(this.userId);
}

@MappableClass()
class InsightsRefreshRequested extends InsightsEvent
    with InsightsRefreshRequestedMappable {
  const InsightsRefreshRequested();
}
