import 'package:dart_mappable/dart_mappable.dart';

import '../../../domain/entities/activity.dart';

part 'dashboard_state.mapper.dart';

enum DashboardStatus { initial, loading, success, failure }

@MappableClass()
class DashboardState with DashboardStateMappable {
  final DashboardStatus status;
  final List<Activity> activities;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.activities = const [],
    this.errorMessage,
  });
}
