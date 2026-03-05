import 'package:dio/dio.dart';

import '../core/remote/rest_api_client.dart';
import '../core/remote/web_socket_client.dart';

class ActivityRemoteDataSource {
  final RestApiClient _restClient;
  final WebSocketClient _wsClient;

  ActivityRemoteDataSource(this._restClient, this._wsClient);

  Future<Response> getRecentActivities() async {
    return await _restClient.get('/activities');
  }

  Stream<dynamic> watchActivities() {
    return _wsClient.stream;
  }
}
