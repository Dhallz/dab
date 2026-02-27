import 'package:fpdart/fpdart.dart';

import '../core/remote/rest_api_client.dart';

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
