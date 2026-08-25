import 'package:fpdart/fpdart.dart';

import '../../../domain/core/daily_report_lock_policy.dart';
import '../../../domain/core/deployment_mode.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Fetches global system settings from the database.
class GetSystemSettings {
  final AbsISystemSettingsRepository _repo;

  GetSystemSettings(this._repo);

  Future<Either<Failure, Map<String, String>>> execute() async {
    final enabledRes = await _repo.isDomainValidationEnabled();
    if (enabledRes.isLeft()) {
      return Left(enabledRes.getLeft().toNullable()!);
    }
    final domainRes = await _repo.getAllowedDomain();
    if (domainRes.isLeft()) {
      return Left(domainRes.getLeft().toNullable()!);
    }
    final publicApiRes = await _repo.getSetting('public_api_url');
    if (publicApiRes.isLeft()) {
      return Left(publicApiRes.getLeft().toNullable()!);
    }
    final timezoneRes = await _repo.getSetting(kSystemTimezoneSettingKey);
    if (timezoneRes.isLeft()) {
      return Left(timezoneRes.getLeft().toNullable()!);
    }
    final modeRes = await _repo.getSetting(kDeploymentModeSettingKey);
    if (modeRes.isLeft()) {
      return Left(modeRes.getLeft().toNullable()!);
    }
    final offsetRes = await _repo.getSetting(kDailyReportLockOffsetDaysKey);
    if (offsetRes.isLeft()) {
      return Left(offsetRes.getLeft().toNullable()!);
    }
    final timeRes = await _repo.getSetting(kDailyReportLockTimeKey);
    if (timeRes.isLeft()) {
      return Left(timeRes.getLeft().toNullable()!);
    }

    final policy = DailyReportLockPolicy.fromSettings(
      offsetDays: offsetRes.getOrElse((_) => null),
      time: timeRes.getOrElse((_) => null),
    );
    return Right({
      'allowed_domain_enabled': enabledRes.getOrElse((_) => false).toString(),
      'allowed_domain': domainRes.getOrElse((_) => null) ?? '',
      'public_api_url': publicApiRes.getOrElse((_) => null) ?? '',
      kSystemTimezoneSettingKey: resolveOrgTimezoneId(
        timezoneRes.getOrElse((_) => null),
      ),
      kDeploymentModeSettingKey: (modeRes.getOrElse(
        (_) => null,
      )).normalizeDeploymentMode(),
      kDailyReportLockOffsetDaysKey: policy.offsetDays.toString(),
      kDailyReportLockTimeKey: policy.time,
    });
  }
}
