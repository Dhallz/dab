import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../repositories/abs_i_monitoring_repository.dart';

class CheckApiHealth {
  final IMonitoringRepository _repository;

  CheckApiHealth(this._repository);

  Future<Either<AppFailure, Unit>> execute() {
    return _repository.checkApiHealth();
  }
}
