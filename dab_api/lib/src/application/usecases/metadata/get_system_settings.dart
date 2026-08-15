import 'package:fpdart/fpdart.dart';

import '../../../domain/core/deployment_mode.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Fetches global system settings from the database.
class GetSystemSettings {
  final ISystemSettingsRepository _repo;

  GetSystemSettings(this._repo);

  Future<Either<Failure, Map<String, String>>> execute() async {
    final enabledRes = await _repo.isDomainValidationEnabled();
    final domainRes = await _repo.getAllowedDomain();
    final publicApiRes = await _repo.getSetting('public_api_url');
    final timezoneRes = await _repo.getSetting(kSystemTimezoneSettingKey);
    final modeRes = await _repo.getSetting(kDeploymentModeSettingKey);

    return enabledRes.fold(
      (f) => Left(f),
      (enabled) => domainRes.fold(
        (f) => Left(f),
        (domain) => publicApiRes.fold(
          (f) => Left(f),
          (publicApiUrl) => timezoneRes.fold(
            (f) => Left(f),
            (timezone) => modeRes.fold(
              (f) => Left(f),
              (mode) => Right({
                'allowed_domain_enabled': enabled.toString(),
                'allowed_domain': domain ?? '',
                'public_api_url': publicApiUrl ?? '',
                kSystemTimezoneSettingKey: resolveOrgTimezoneId(timezone),
                kDeploymentModeSettingKey: normalizeDeploymentMode(mode),
              }),
            ),
          ),
        ),
      ),
    );
  }
}
