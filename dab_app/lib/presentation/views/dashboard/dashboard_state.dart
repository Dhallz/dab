import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/activity/activity.dart';

part 'dashboard_state.mapper.dart';

/// [ARCH: PRESENTATION_STATE]
/// ROLE: Snapshot of the Dashboard screen state.
@MappableClass()
class DashboardState with DashboardStateMappable {
  final ViewStatus status;
  final List<Activity> activities;
  final String? errorMessage;

  const DashboardState({
    this.status = ViewStatus.initial,
    this.activities = const [],
    this.errorMessage,
  });

  factory DashboardState.initial() => const DashboardState();
}
