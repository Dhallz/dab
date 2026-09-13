import '../usecases/health/check_database_health.dart';

class HealthUseCases {
  final CheckDatabaseHealth checkDatabaseHealth;

  HealthUseCases({
    required this.checkDatabaseHealth,
  });
}
