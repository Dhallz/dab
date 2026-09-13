import 'package:fpdart/fpdart.dart';
import '../../core/failures.dart';
import '../../entities/system/system_status.dart';
import '../../repositories/abs_i_provider_config_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Fetches the current initialization status of the DAB platform.
/// CONTRACT: Returns true if the system has at least one Admin and one active Provider.
class GetSystemStatus {
  final IProviderConfigRepository _repository;

  GetSystemStatus(this._repository);

  Future<Either<AppFailure, SystemStatus>> execute() async {
    return _repository.getSystemStatus();
  }
}
