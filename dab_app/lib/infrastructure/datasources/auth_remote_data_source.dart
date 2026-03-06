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
    print('DEBUG: AuthRemoteDataSource.login calling /auth/login');
    final response = await _client.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    print(
      'DEBUG: AuthRemoteDataSource.login response status: ${response.statusCode}',
    );
    return response.data as Map<String, dynamic>;
  }
}
