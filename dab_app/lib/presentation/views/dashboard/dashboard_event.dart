import 'package:dart_mappable/dart_mappable.dart';

part 'dashboard_event.mapper.dart';

@MappableClass()
sealed class DashboardEvent with DashboardEventMappable {
  const DashboardEvent();
}

@MappableClass()
class DashboardStarted extends DashboardEvent with DashboardStartedMappable {
  const DashboardStarted();
}

@MappableClass()
class DashboardActivityReceived extends DashboardEvent
    with DashboardActivityReceivedMappable {
  final dynamic activity;
  const DashboardActivityReceived(this.activity);
}
