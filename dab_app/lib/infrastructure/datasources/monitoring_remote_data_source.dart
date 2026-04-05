import 'package:fpdart/fpdart.dart';
import '../core/remote/rest_api_client.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Low-level I/O for system health monitoring from the Remote API.
/// CONTRACT: Provides a health check future.
/// CONSTRAINTS: Purely for system vitals. Uses [RestApiClient].
class MonitoringRemoteDataSource {
  final RestApiClient _client;

  MonitoringRemoteDataSource(this._client);

  /// Returns unit if the health check succeeds.
  Future<Unit> checkHealth() async {
    // Assuming a /health endpoint that returns 200 OK
    await _client.dio.get('/health');
    return unit;
  }
}
