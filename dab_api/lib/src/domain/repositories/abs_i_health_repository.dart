import 'package:fpdart/fpdart.dart';
import '../core/failure.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Abstract contract for System Health Monitoring.
/// CONTRACT: Provides methods to verify the operational state of infrastructure components.
abstract class AbsIHealthRepository {
  /// Verifies the connection state of the primary database.
  Future<Either<DatabaseFailure, bool>> checkConnection();
}
