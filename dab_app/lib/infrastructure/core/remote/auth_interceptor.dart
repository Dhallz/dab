import 'package:dio/dio.dart';

import '../local/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login and register endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register')) {
      return handler.next(options);
    }

    final tokens = await _tokenStorage.readTokens();
    if (tokens != null && tokens['accessToken'] != null) {
      options.headers['Authorization'] = 'Bearer ${tokens['accessToken']}';
    }

    return handler.next(options);
  }
}
