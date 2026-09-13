import 'package:dio/dio.dart';
import '../../domain/entities/activity/activity_search_query.dart';
import '../core/remote/rest_api_client.dart';
import '../core/remote/web_socket_client.dart';
import 'activity_search_query_mapper.dart';

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

  Future<Response> getLiveActivities({
    int limit = 50,
    bool global = false,
    bool includeArchived = false,
  }) async {
    return await _restClient.get(
      '/activities/live',
      queryParameters: {
        'limit': limit,
        if (global) 'scope': 'global',
        if (includeArchived) 'includeArchived': 'true',
      },
    );
  }

  Future<Response> archiveLiveActivity(String id) async {
    return await _restClient.post('/activities/live/$id/archive');
  }

  Future<Response> unarchiveLiveActivity(String id) async {
    return await _restClient.post('/activities/live/$id/unarchive');
  }

  Future<Response> searchActivities(ActivitySearchQuery query) async {
    final queryParameters = ActivitySearchQueryMapper.toRemoteQueryParameters(
      query,
    );

    return await _restClient.get(
      '/activities/search',
      queryParameters: queryParameters,
    );
  }

  Stream<dynamic> watchActivities() {
    _wsClient.connect();
    return _wsClient.stream;
  }
}
