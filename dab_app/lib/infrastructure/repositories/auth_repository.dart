import 'package:dab_app/domain/entities/user.dart';
import 'package:dab_app/infrastructure/core/local/records/user_record.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/abs_i_auth_repository.dart';
import '../core/local/token_storage.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import 'core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Orchestrator for Authentication, session management, and identity persistence.
/// CONTRACT: Implements [IAuthRepository].
/// CONSTRAINTS: Coordinates between [AuthRemoteDataSource] (API) and [AuthLocalDataSource]/[TokenStorage] (Persistence).
/// 
/// This repository is the source of truth for the current user's session state 
/// and provides the necessary credentials for authenticated requests.
class AuthRepository extends Repository implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final TokenStorage _tokenStorage;

  AuthRepository(
    this._remoteDataSource,
    this._localDataSource,
    this._tokenStorage,
  );

  @override
  Future<Either<AppFailure, AuthResponse>> login({
    required String email,
    required String password,
  }) {
    return guardedCall(() async {
      final json = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      final response = AuthResponseMapper.fromMap(json);

      final tokenResult = await saveTokens(response);
      tokenResult.getOrElse((f) => throw f);

      _localDataSource.saveUser(
        UserRecord(
          remoteId: response.userId,
          email: response.email,
          name: response.name,
          role: response.role,
        ),
      );

      return response;
    });
  }

  @override
  Future<Either<AppFailure, AuthResponse>> register({
    required String email,
    required String password,
    required String name,
  }) {
    return guardedCall(() async {
      final json = await _remoteDataSource.register(
        email: email,
        password: password,
        name: name,
      );
      final response = AuthResponseMapper.fromMap(json);
      final tokenResult = await saveTokens(response);
      tokenResult.getOrElse((f) => throw f);

      _localDataSource.saveUser(
        UserRecord(
          remoteId: response.userId,
          email: email,
          name: name,
          role: response.role,
        ),
      );
      return response;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> logout() {
    return guardedCall(() async {
      await clearTokens();
      _localDataSource.clear();
      return unit;
    });
  }

  @override
  Future<Either<AppFailure, Unit>> refreshToken() async {
    final tokens = await _tokenStorage.readTokens();
    if (tokens == null || tokens['refreshToken'] == null) {
      return const Left(AuthFailure('No refresh token available'));
    }
    final refreshToken = tokens['refreshToken']!;
    return guardedCall(() async {
      final json = await _remoteDataSource.refresh(
        refreshToken: refreshToken,
      );

      final response = AuthResponseMapper.fromMap(json);
      await saveTokens(response);

      return unit;
    });
  }

  @override
  Future<Either<AppFailure, User>> checkAuthStatus() {
    return guardedCall(() async {
      final userRecord = _localDataSource.getUser();
      if (userRecord == null) {
        throw const AuthFailure();
      }
      return userRecord.toDomain;
    });
  }

  @override
  Future<Either<AppFailure, String>> getAccessToken() async {
    final tokens = await _tokenStorage.readTokens();
    if (tokens == null) return const Left(AuthFailure('No access token found'));
    return Right(tokens['accessToken']!);
  }

  Future<Either<AppFailure, String>> getRefreshToken() async {
    final tokens = await _tokenStorage.readTokens();
    if (tokens == null) {
      return const Left(AuthFailure('No refresh token found'));
    }
    return Right(tokens['refreshToken']!);
  }

  @override
  Future<Either<AppFailure, Unit>> saveTokens(AuthResponse response) async {
    try {
      await _tokenStorage.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> clearTokens() async {
    try {
      await _tokenStorage.clear();
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> saveCredentials(
    String email,
    String password,
  ) async {
    return guardedCall(() async {
      _localDataSource.saveCredentials(email, password);
      return unit;
    });
  }

  @override
  Future<Either<AppFailure, Map<String, String>?>> getSavedCredentials() async {
    return guardedCall(() async {
      final record = _localDataSource.getSavedCredentials();
      if (record == null) return null;
      return {'email': record.email, 'password': record.password};
    });
  }

  @override
  Future<Either<AppFailure, Unit>> clearCredentials() async {
    return guardedCall(() async {
      _localDataSource.clearCredentials();
      return unit;
    });
  }
}
