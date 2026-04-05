import 'package:fpdart/fpdart.dart';
import '../../domain/core/failures.dart';
import '../../domain/repositories/abs_i_monitoring_repository.dart';
import '../datasources/monitoring_remote_data_source.dart';
import 'core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of System Monitoring and Vitals in the Client.
/// CONTRACT: Implements [IMonitoringRepository].
/// CONSTRAINTS: Purely for system health checks. Delegates to [MonitoringRemoteDataSource].
class MonitoringRepository extends Repository implements IMonitoringRepository {
  final MonitoringRemoteDataSource _remoteDataSource;

  MonitoringRepository(this._remoteDataSource);

  @override
  Future<Either<AppFailure, Unit>> checkApiHealth() {
    return guardedCall(() => _remoteDataSource.checkHealth());
  }
}
