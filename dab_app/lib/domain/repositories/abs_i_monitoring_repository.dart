import 'package:fpdart/fpdart.dart';

import '../core/failures.dart';
import 'core/abs_i_repository.dart';

abstract interface class IMonitoringRepository extends IRepository {
  Future<Either<AppFailure, Unit>> checkApiHealth();
}
