import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/core/org_calendar.dart';
import '../../../domain/entities/provider/provider_config.dart';
import '../../../domain/entities/provider/provider_connectivity_report.dart';
import '../../../domain/entities/system/system_status.dart';
import '../../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../../presentation/core/models/view_status.dart';
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
  Future<Either<AppFailure, SystemStatus>> getSystemStatus() {
    return guardedCall(() async {
      final response = await _remoteDataSource.getSystemStatus();
      final data = response.data;
      final Map<String, dynamic> map;

      if (data is Map<String, dynamic>) {
        map = data;
      } else {
        map = jsonDecode(data.toString());
      }

      final payload = map['data'] as Map<String, dynamic>? ?? {};
      return SystemStatus(
        isSystemConfigured: payload['isSystemConfigured'] ?? false,
        orgTimezoneId: resolveOrgTimezoneId(
          payload['systemTimezone']?.toString(),
        ),
      );
    });
  }

  @override
  Future<Either<AppFailure, void>> saveProviderConfig(ProviderConfig config) {
    return guardedCall(() async {
      await _remoteDataSource.saveProviderConfig(config.toMap());
    });
  }

  @override
  Future<Either<AppFailure, ProviderConnectivityReport>> testProviderConfig(
    ProviderConfig config,
  ) {
    return guardedCall(() async {
      final response = await _remoteDataSource.testProviderConfig(
        config.toMap(),
      );
      final dynamic data = response.data;
      final Map<String, dynamic> map;

      if (data is Map<String, dynamic>) {
        map = data;
      } else {
        map = jsonDecode(data.toString());
      }

      final payload = map['data'] as Map<String, dynamic>? ?? {};
      final sections = payload['sections'] as Map<String, dynamic>? ?? {};

      return ProviderConnectivityReport(
        aggregate: _parseStatus(payload['aggregate']?.toString()),
        summaryMessage:
            payload['summaryMessage']?.toString() ?? 'Connectivity test complete',
        core: _parseSection(sections['core']),
        live: _parseSection(sections['live']),
        polling: _parseSection(sections['polling']),
      );
    });
  }

  ProviderSectionResult _parseSection(dynamic raw) {
    if (raw is! Map<String, dynamic>) {
      return const ProviderSectionResult(
        status: ViewStatus.failure,
        message: 'Section result missing',
      );
    }
    return ProviderSectionResult(
      status: _parseStatus(raw['status']?.toString()),
      message: raw['message']?.toString() ?? '',
    );
  }

  ViewStatus _parseStatus(String? raw) {
    return switch (raw?.toLowerCase()) {
      'success' => ViewStatus.success,
      'warning' => ViewStatus.warning,
      'failure' => ViewStatus.failure,
      'loading' => ViewStatus.loading,
      _ => ViewStatus.failure,
    };
  }

  @override
  Future<Either<AppFailure, Map<String, String>>> getSystemSettings() {
    return guardedCall(() async {
      final response = await _remoteDataSource.getSystemSettings();
      final data = response.data;
      final Map<String, dynamic> map;

      if (data is Map<String, dynamic>) {
        map = data;
      } else {
        map = jsonDecode(data.toString());
      }

      final Map<String, dynamic> settingsData = map['data'] ?? {};
      return settingsData.map((key, value) => MapEntry(key, value.toString()));
    });
  }

  @override
  Future<Either<AppFailure, void>> saveSystemSettings(
    Map<String, String> settings,
  ) {
    return guardedCall(() async {
      await _remoteDataSource.saveSystemSettings(settings);
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
