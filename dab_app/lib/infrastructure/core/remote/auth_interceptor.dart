import 'package:dio/dio.dart';

import '../local/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  Future<void> Function()? onRefreshToken;
  Future<void>? _refreshFuture;

  AuthInterceptor(this._tokenStorage, {this.onRefreshToken});

  /// Dio sometimes leaves [RequestOptions.path] without a leading `/` while
  /// [RequestOptions.uri.path] is correct — and `metadata/configs` does **not**
  /// contain the substring `/metadata/configs`, so we would attach a stale
  /// Bearer token and the API correctly returns 401.
  static String _normalizePath(String raw) {
    var p = raw.trim();
    if (p.isEmpty) return '/';
    if (!p.startsWith('/')) p = '/$p';
    while (p.contains('//')) {
      p = p.replaceAll('//', '/');
    }
    if (p.length > 1 && p.endsWith('/')) {
      p = p.substring(0, p.length - 1);
    }
    return p;
  }

  /// No `Authorization` header (login/register/refresh + public metadata/health).
  static bool _isPublicApiPath(String rawPath) {
    final p = _normalizePath(rawPath);
    if (p == '/health' || p.startsWith('/health/')) return true;
    if (p.endsWith('/metadata/configs') || p.endsWith('/metadata/status')) {
      return true;
    }
    if (p.endsWith('/auth/login') ||
        p.endsWith('/auth/register') ||
        p.endsWith('/auth/refresh')) {
      return true;
    }
    return false;
  }

  static bool _skipBearer(RequestOptions options) {
    return _isPublicApiPath(options.uri.path) ||
        _isPublicApiPath(options.path);
  }

  static bool _isRefreshRequest(RequestOptions options) {
    return _normalizePath(options.uri.path).endsWith('/auth/refresh') ||
        _normalizePath(options.path).endsWith('/auth/refresh');
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_skipBearer(options)) {
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
    final ro = err.requestOptions;

    if (err.response?.statusCode == 401 &&
        onRefreshToken != null &&
        !_isRefreshRequest(ro) &&
        !_skipBearer(ro)) {
      final existing = await _tokenStorage.readTokens();
      if (existing == null || existing['refreshToken'] == null) {
        return handler.next(err);
      }
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
