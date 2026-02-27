import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/system/app_settings.dart';
import '../../repositories/abs_i_system_repository.dart';

class SaveAppSettings {
  final ISystemRepository _repository;

  SaveAppSettings(this._repository);

  Future<Either<AppFailure, Unit>> execute(AppSettings settings) {
    return _repository.saveSettings(settings);
  }
}
