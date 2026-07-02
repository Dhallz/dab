import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Fetches global system settings from the database.
class GetSystemSettings {
  final ISystemSettingsRepository _repo;

  GetSystemSettings(this._repo);

  Future<Either<Failure, Map<String, String>>> execute() async {
    final enabledRes = await _repo.isDomainValidationEnabled();
    final domainRes = await _repo.getAllowedDomain();

    return enabledRes.fold(
      (f) => Left(f),
      (enabled) => domainRes.fold(
        (f) => Left(f),
        (domain) => Right({
          'allowed_domain_enabled': enabled.toString(),
          'allowed_domain': domain ?? '',
        }),
      ),
    );
  }
}
