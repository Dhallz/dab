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
}
