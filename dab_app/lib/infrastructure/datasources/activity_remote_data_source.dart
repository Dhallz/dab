import 'package:dio/dio.dart';
import '../core/remote/rest_api_client.dart';
import '../core/remote/web_socket_client.dart';

/// [ARCH: INFRASTRUCTURE_SOURCE]
/// ROLE: Low-level I/O for Activities from the Remote API.
/// CONTRACT: Provides raw Streams (WebSockets) and Futures (REST) to the Repositories.
/// CONSTRAINTS: Must not contain mapping logic. Strictly focuses on protocol and parameter formatting.
class ActivityRemoteDataSource {
  final RestApiClient _restClient;
  final WebSocketClient _wsClient;

  ActivityRemoteDataSource(this._restClient, this._wsClient);

  Future<Response> getRecentActivities() async {
    return await _restClient.get('/activities');
  }

  Future<Response> searchActivities({
    DateTime? startDate,
    DateTime? endDate,
    List<String>? users,
    bool authoredOnly = true,
  }) async {
    final queryParameters = <String, dynamic>{
      'authoredOnly': authoredOnly.toString(),
    };

    if (startDate != null) {
      queryParameters['startDate'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParameters['endDate'] = endDate.toIso8601String().split('T')[0];
    }
    if (users != null && users.isNotEmpty) {
      queryParameters['users'] = users.join(',');
    }

    return await _restClient.get(
      '/activities/search',
      queryParameters: queryParameters,
    );
  }

  Stream<dynamic> watchActivities() {
    return _wsClient.stream;
  }
}
