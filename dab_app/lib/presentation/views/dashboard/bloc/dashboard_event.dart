abstract class DashboardEvent {
  const DashboardEvent();
}

class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

class DashboardActivityReceived extends DashboardEvent {
  final dynamic activity;
  const DashboardActivityReceived(this.activity);
}
