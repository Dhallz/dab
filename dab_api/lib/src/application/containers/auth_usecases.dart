import '../usecases/auth/authenticate_user.dart';
import '../usecases/auth/login_user.dart';
import '../usecases/auth/logout_user.dart';
import '../usecases/auth/refresh_token.dart';
import '../usecases/auth/register_new_user.dart';
import '../usecases/auth/register_user.dart';

class AuthUseCases {
  final AuthenticateUser authenticateUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final RefreshToken refreshToken;
  final RegisterNewUser registerNewUser;
  final RegisterUser registerUser;

  AuthUseCases({
    required this.authenticateUser,
    required this.loginUser,
    required this.logoutUser,
    required this.refreshToken,
    required this.registerNewUser,
    required this.registerUser,
  });
}
