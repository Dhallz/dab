import 'package:fpdart/fpdart.dart';
import '../../../domain/core/daily_report_lock_policy.dart';
import '../../../domain/core/deployment_mode.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Updates global system settings in the database.
class SaveSystemSettings {
  final AbsISystemSettingsRepository _repo;

  SaveSystemSettings(this._repo);

  Future<Either<Failure, void>> execute(Map<String, String> settings) async {
    for (final entry in settings.entries) {
      if (!kAllowedSystemSettingKeys.contains(entry.key)) {
        continue;
      }
      var value = entry.value;
      if (entry.key == kDeploymentModeSettingKey) {
        value = value.normalizeDeploymentMode();
      } else if (entry.key == kDailyReportLockOffsetDaysKey) {
        value = parseDailyReportLockOffsetDays(value).toString();
      } else if (entry.key == kDailyReportLockTimeKey) {
        value = formatDailyReportLockTime(parseDailyReportLockTime(value));
      }
      final res = await _repo.setSetting(entry.key, value);
      if (res.isLeft()) {
        return Left(res.getLeft().toNullable()!);
      }
    }
    return const Right(null);
  }
}
