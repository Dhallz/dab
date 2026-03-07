import 'package:dio/dio.dart';

import '../core/remote/rest_api_client.dart';

class ProviderConfigRemoteDataSource {
  final RestApiClient _restClient;

  ProviderConfigRemoteDataSource(this._restClient);

  Future<Response> getProviderConfigs() async {
    return await _restClient.get('/metadata/configs');
  }
}
