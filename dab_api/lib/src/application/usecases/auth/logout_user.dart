import '../../../domain/contracts/repositories/abs_i_auth_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Invalidates a user's session.
/// CONTRACT: Permanently deletes a [refreshToken] from the database.
/// CONSTRAINTS: Only affects the specific session associated with the token.
class LogoutUser {
  final AbsIAuthRepository _repo;

  LogoutUser(this._repo);

  /// Executes the logout operation.
  /// 
  /// By deleting the refresh token, the client will no longer be able to 
  /// request new access tokens, effectively logging them out of that device.
  Future<void> execute(String refreshToken) async {
    await _repo.deleteSession(refreshToken);
  }
}
