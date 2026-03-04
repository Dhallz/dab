import '../../../../domain/entities/activity.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState {
  final DashboardStatus status;
  final List<Activity> activities;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.activities = const [],
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    List<Activity>? activities,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      activities: activities ?? this.activities,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
