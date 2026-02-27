import 'package:fpdart/fpdart.dart';

import '../core/failures.dart';
import '../entities/system/app_settings.dart';
import 'core/abs_i_repository.dart';

abstract interface class ISystemRepository extends IRepository {
  Future<Either<AppFailure, AppSettings>> getSettings();
  Future<Either<AppFailure, Unit>> saveSettings(AppSettings settings);
}
