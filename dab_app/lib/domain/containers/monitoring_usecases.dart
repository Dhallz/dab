import '../repositories/abs_i_monitoring_repository.dart';
import '../usecases/monitoring/check_api_health.dart';

class MonitoringUseCases {
  final CheckApiHealth checkApiHealth;

  MonitoringUseCases(IMonitoringRepository repository)
    : checkApiHealth = CheckApiHealth(repository);
}
