import 'package:dab_app/domain/entities/user.dart';
import 'package:dab_app/infrastructure/core/local/records/user_record.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/core/failures.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/abs_i_auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import 'core/repository.dart';

class AuthRepository extends Repository implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final FlutterSecureStorage _secureStorage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  AuthRepository(
    this._remoteDataSource,
    this._localDataSource,
    this._secureStorage,
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
      await saveTokens(response);
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
      await saveTokens(response);
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
    final token = await _secureStorage.read(key: _accessTokenKey);
    if (token == null) return const Left(AuthFailure('No access token found'));
    return Right(token);
  }

  Future<Either<AppFailure, String>> getRefreshToken() async {
    final token = await _secureStorage.read(key: _refreshTokenKey);
    if (token == null) return const Left(AuthFailure('No refresh token found'));
    return Right(token);
  }

  @override
  Future<Either<AppFailure, Unit>> saveTokens(AuthResponse response) async {
    try {
      await _secureStorage.write(
        key: _accessTokenKey,
        value: response.accessToken,
      );
      await _secureStorage.write(
        key: _refreshTokenKey,
        value: response.refreshToken,
      );
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(originalError: e));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> clearTokens() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
      await _secureStorage.delete(key: _refreshTokenKey);
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(originalError: e));
    }
  }
}
