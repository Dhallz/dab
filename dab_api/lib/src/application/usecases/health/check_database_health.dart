import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_health_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Verifies the operational status of the primary data store.
/// CONTRACT: Returns [true] if the database is reachable, or [DatabaseFailure] otherwise.
/// CONSTRAINTS: Light-weight check suitable for frequent health probes.
class CheckDatabaseHealth {
  final AbsIHealthRepository _healthRepo;

  CheckDatabaseHealth(this._healthRepo);

  /// Executes the connectivity check.
  Future<Either<DatabaseFailure, bool>> execute() async {
    return await _healthRepo.checkConnection();
  }
}
