import 'package:dab_app/domain/usecases/monitoring/check_api_health.dart';

import '../repositories/abs_i_api_origin_repository.dart';
import '../repositories/abs_i_auth_repository.dart';
import '../repositories/abs_i_monitoring_repository.dart';
import '../usecases/auth/check_auth_status.dart';
import '../usecases/auth/get_api_origin.dart';
import '../usecases/auth/get_saved_credentials.dart';
import '../usecases/auth/login.dart';
import '../usecases/auth/logout.dart';
import '../usecases/auth/register.dart';
import '../usecases/auth/save_credentials.dart';
import '../usecases/auth/set_api_origin.dart';

class AuthUseCases {
  final Login login;
  final Register register;
  final Logout logout;
  final CheckAuthStatus checkAuthStatus;
  final CheckApiHealth checkApiHealth;
  final SaveCredentials saveCredentials;
  final GetSavedCredentials getSavedCredentials;
  final GetApiOrigin getApiOrigin;
  final SetApiOrigin setApiOrigin;

  AuthUseCases(
    IAuthRepository authRepository,
    IMonitoringRepository monitoringRepository,
    IApiOriginRepository apiOriginRepository,
  ) : login = Login(authRepository),
      register = Register(authRepository),
      logout = Logout(authRepository),
      checkAuthStatus = CheckAuthStatus(authRepository),
      checkApiHealth = CheckApiHealth(monitoringRepository),
      saveCredentials = SaveCredentials(authRepository),
      getSavedCredentials = GetSavedCredentials(authRepository),
      getApiOrigin = GetApiOrigin(apiOriginRepository),
      setApiOrigin = SetApiOrigin(apiOriginRepository);
}
