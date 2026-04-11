import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../domain/core/failures.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../datasources/provider_config_remote_data_source.dart';
import '../repositories/core/repository.dart';

/// [ARCH: INFRASTRUCTURE_REPOSITORY]
/// ROLE: Implementation of Platform Configuration retrieval in the Client.
/// CONTRACT: Implements [IProviderConfigRepository].
/// CONSTRAINTS: Bridges [ProviderConfigRemoteDataSource] (API) to Domain Entities.
class ProviderConfigRepository extends Repository
    implements IProviderConfigRepository {
  final ProviderConfigRemoteDataSource _remoteDataSource;

  ProviderConfigRepository(this._remoteDataSource);

  @override
  Future<Either<AppFailure, List<ProviderConfig>>> getProviderConfigs() {
    return guardedCall(() async {
      final response = await _remoteDataSource.getProviderConfigs();
      final List<dynamic> jsonList = _getEnvelopeData(response);
      return jsonList
          .map((json) => ProviderConfigMapper.fromMap(json))
          .toList();
    });
  }

  @override
  Future<Either<AppFailure, bool>> getSystemStatus() {
    return guardedCall(() async {
      final response = await _remoteDataSource.getSystemStatus();
      final data = response.data;
      final Map<String, dynamic> map;

      if (data is Map<String, dynamic>) {
        map = data;
      } else {
        map = jsonDecode(data.toString());
      }

      return map['data']['isSystemConfigured'] ?? false;
    });
  }

  @override
  Future<Either<AppFailure, void>> saveProviderConfig(ProviderConfig config) {
    return guardedCall(() async {
      await _remoteDataSource.saveProviderConfig(config.toMap());
    });
  }

  @override
  Future<Either<AppFailure, String>> testProviderConfig(ProviderConfig config) {
    return guardedCall(() async {
      final response = await _remoteDataSource.testProviderConfig(config.toMap());
      final dynamic data = response.data;
      final Map<String, dynamic> map;

      if (data is Map<String, dynamic>) {
        map = data;
      } else {
        map = jsonDecode(data.toString());
      }

      return map['data']?['message'] ?? 'Connected';
    });
  }

  List<dynamic> _getEnvelopeData(Response response) {
    if (response.data == null) return [];

    final dynamic data = response.data;
    final Map<String, dynamic> map;

    if (data is Map<String, dynamic>) {
      map = data;
    } else {
      map = jsonDecode(data.toString());
    }

    return map['data'] ?? [];
  }
}
