import 'package:fpdart/fpdart.dart';

import '../../core/failures.dart';
import '../../entities/system/app_settings.dart';
import '../../repositories/abs_i_system_repository.dart';

class GetAppSettings {
  final ISystemRepository _repository;

  GetAppSettings(this._repository);

  Future<Either<AppFailure, AppSettings>> execute() {
    return _repository.getSettings();
  }
}
