import '../usecases/auth/count_unresolved_identities.dart';
import '../usecases/auth/create_user_by_admin.dart';
import '../usecases/auth/delete_user_identity.dart';
import '../usecases/auth/get_all_identities.dart';
import '../usecases/auth/authenticate_user.dart';
import '../usecases/auth/find_all_users.dart';
import '../usecases/auth/link_user_identity.dart';
import '../usecases/auth/login_user.dart';
import '../usecases/auth/logout_user.dart';
import '../usecases/auth/refresh_token.dart';
import '../usecases/auth/register_new_user.dart';
import '../usecases/auth/register_user.dart';
import '../usecases/auth/update_user_role.dart';
import '../usecases/auth/resolve_user_identity.dart';

class AuthUseCases {
  final AuthenticateUser authenticateUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final RefreshToken refreshToken;
  final RegisterNewUser registerNewUser;
  final RegisterUser registerUser;
  final CreateUserByAdmin createUserByAdmin;
  final LinkUserIdentity linkUserIdentity;
  final GetAllIdentities getAllIdentities;
  final CountUnresolvedIdentities countUnresolvedIdentities;
  final FindAllUsers findAllUsers;
  final UpdateUserRole updateUserRole;
  final ResolveUserIdentity resolveUserIdentity;
  final DeleteUserIdentity deleteUserIdentity;

  AuthUseCases({
    required this.authenticateUser,
    required this.loginUser,
    required this.logoutUser,
    required this.refreshToken,
    required this.registerNewUser,
    required this.registerUser,
    required this.createUserByAdmin,
    required this.linkUserIdentity,
    required this.getAllIdentities,
    required this.countUnresolvedIdentities,
    required this.findAllUsers,
    required this.updateUserRole,
    required this.resolveUserIdentity,
    required this.deleteUserIdentity,
  });
}
