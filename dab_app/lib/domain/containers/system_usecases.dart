import '../repositories/abs_i_system_repository.dart';
import '../usecases/system/get_app_settings.dart';
import '../usecases/system/save_app_settings.dart';

class SystemUseCases {
  final GetAppSettings getAppSettings;
  final SaveAppSettings saveAppSettings;

  SystemUseCases(ISystemRepository repository)
    : getAppSettings = GetAppSettings(repository),
      saveAppSettings = SaveAppSettings(repository);
}
