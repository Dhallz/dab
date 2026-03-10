import '../core/remote/rest_api_client.dart';

class AuthRemoteDataSource {
  final RestApiClient _client;

  AuthRemoteDataSource(this._client);

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _client.dio.post(
      '/auth/register',
      data: {'email': email, 'password': password, 'name': name},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> refresh({required String refreshToken}) async {
    final response = await _client.dio.post(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
    );
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUser(String id) async {
    final response = await _client.get('/users/$id');
    return response.data as Map<String, dynamic>;
  }
}
