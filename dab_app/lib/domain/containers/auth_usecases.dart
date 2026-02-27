import 'package:dab_app/domain/usecases/monitoring/check_api_health.dart';

import '../repositories/abs_i_auth_repository.dart';
import '../repositories/abs_i_monitoring_repository.dart';
import '../usecases/auth/check_auth_status.dart';
import '../usecases/auth/login.dart';
import '../usecases/auth/logout.dart';
import '../usecases/auth/register.dart';

class AuthUseCases {
  final Login login;
  final Register register;
  final Logout logout;
  final CheckAuthStatus checkAuthStatus;
  final CheckApiHealth checkApiHealth;

  AuthUseCases(
    IAuthRepository authRepository,
    IMonitoringRepository monitoringRepository,
  ) : login = Login(authRepository),
      register = Register(authRepository),
      logout = Logout(authRepository),
      checkAuthStatus = CheckAuthStatus(authRepository),
      checkApiHealth = CheckApiHealth(monitoringRepository);
}
