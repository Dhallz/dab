import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/repositories/abs_i_monitoring_repository.dart';
import '../datasources/monitoring_remote_data_source.dart';
import 'core/repository.dart';

class MonitoringRepository extends Repository implements IMonitoringRepository {
  final MonitoringRemoteDataSource _remoteDataSource;

  MonitoringRepository(this._remoteDataSource);

  @override
  Future<Either<AppFailure, Unit>> checkApiHealth() {
    return guardedCall(() => _remoteDataSource.checkHealth());
  }
}
