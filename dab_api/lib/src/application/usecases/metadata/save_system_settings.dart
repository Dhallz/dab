import 'package:fpdart/fpdart.dart';
import '../../../domain/core/deployment_mode.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Updates global system settings in the database.
class SaveSystemSettings {
  final ISystemSettingsRepository _repo;

  SaveSystemSettings(this._repo);

  Future<Either<Failure, void>> execute(Map<String, String> settings) async {
    for (final entry in settings.entries) {
      if (!kAllowedSystemSettingKeys.contains(entry.key)) {
        continue;
      }
      var value = entry.value;
      if (entry.key == kDeploymentModeSettingKey) {
        value = normalizeDeploymentMode(value);
      }
      final res = await _repo.setSetting(entry.key, value);
      if (res.isLeft()) {
        return Left(res.getLeft().toNullable()!);
      }
    }
    return const Right(null);
  }
}
