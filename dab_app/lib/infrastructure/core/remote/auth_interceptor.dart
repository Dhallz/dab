import 'package:dio/dio.dart';

import '../local/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  Future<void> Function()? onRefreshToken;
  Future<void>? _refreshFuture;

  AuthInterceptor(this._tokenStorage, {this.onRefreshToken});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip auth for login, register, and refresh endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final tokens = await _tokenStorage.readTokens();
    if (tokens != null && tokens['accessToken'] != null) {
      options.headers['Authorization'] = 'Bearer ${tokens['accessToken']}';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isRefreshRequest = err.requestOptions.path.contains('/auth/refresh');

    if (err.response?.statusCode == 401 &&
        onRefreshToken != null &&
        !isRefreshRequest) {
      try {
        _refreshFuture ??= onRefreshToken!();
        await _refreshFuture;
        _refreshFuture = null;

        // Retry the request with the new token
        final tokens = await _tokenStorage.readTokens();
        if (tokens != null && tokens['accessToken'] != null) {
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer ${tokens['accessToken']}';

          final dio = Dio(BaseOptions(baseUrl: options.baseUrl));
          final response = await dio.fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        _refreshFuture = null;
        // Refresh failed, clear tokens and continue with error
        await _tokenStorage.clear();
      }
    }
    return handler.next(err);
  }
}
