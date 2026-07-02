import 'package:dio/dio.dart';
import '../core/remote/rest_api_client.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Low-level I/O for Platform Configurations from the Remote API.
/// CONTRACT: Provides raw HTTP Responses (Futures) to the Repositories.
/// CONSTRAINTS: Must not contain mapping logic. Uses [RestApiClient].
class ProviderConfigRemoteDataSource {
  final RestApiClient _restClient;

  ProviderConfigRemoteDataSource(this._restClient);

  Future<Response> getProviderConfigs() async {
    return await _restClient.get('/metadata/configs');
  }

  Future<Response> getSystemStatus() async {
    return await _restClient.get('/metadata/status');
  }

  Future<Response> saveProviderConfig(Map<String, dynamic> config) async {
    return await _restClient.post('/admin/configs', data: config);
  }

  Future<Response> testProviderConfig(Map<String, dynamic> config) async {
    return await _restClient.post('/admin/configs/test', data: config);
  }

  Future<Response> getSystemSettings() async {
    return await _restClient.get('/admin/system-settings');
  }

  Future<Response> saveSystemSettings(Map<String, String> settings) async {
    return await _restClient.put('/admin/system-settings', data: settings);
  }
}
