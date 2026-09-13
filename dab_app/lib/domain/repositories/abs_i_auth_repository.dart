import 'package:fpdart/fpdart.dart';

import '../core/failures.dart';
import '../entities/auth_response.dart';
import '../entities/user/user.dart';
import 'core/abs_i_repository.dart';

abstract interface class IAuthRepository extends IRepository {
  Future<Either<AppFailure, AuthResponse>> login({
    required String email,
    required String password,
  });

  Future<Either<AppFailure, AuthResponse>> register({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<AppFailure, Unit>> logout();

  Future<Either<AppFailure, User>> checkAuthStatus();

  Future<Either<AppFailure, Unit>> refreshToken();

  Future<Either<AppFailure, String>> getAccessToken();
  Future<Either<AppFailure, Unit>> saveTokens(AuthResponse response);
  Future<Either<AppFailure, Unit>> clearTokens();

  Future<Either<AppFailure, Unit>> saveCredentials(
    String email,
    String password,
  );
  Future<Either<AppFailure, Map<String, String>?>> getSavedCredentials();
  Future<Either<AppFailure, Unit>> clearCredentials();
}
