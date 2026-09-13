import 'package:dio/dio.dart';

import '../local/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  Future<void> Function()? onRefreshToken;

  /// Called after tokens are cleared because refresh failed or none exist.
  /// Presentation should sign the user out so the router leaves protected views.
  Future<void> Function()? onSessionExpired;

  Future<void>? _refreshFuture;
  Future<void>? _expireFuture;

  AuthInterceptor(
    this._tokenStorage, {
    this.onRefreshToken,
    this.onSessionExpired,
  });

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
    return _isPublicApiPath(options.uri.path) || _isPublicApiPath(options.path);
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
      _expireFuture = null;
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
        !_isRefreshRequest(ro) &&
        !_skipBearer(ro)) {
      final existing = await _tokenStorage.readTokens();
      final refreshToken = existing?['refreshToken'];
      if (refreshToken != null &&
          refreshToken.isNotEmpty &&
          onRefreshToken != null) {
        try {
          _refreshFuture ??= onRefreshToken!();
          await _refreshFuture;
          _refreshFuture = null;

          final tokens = await _tokenStorage.readTokens();
          if (tokens != null && tokens['accessToken'] != null) {
            final options = err.requestOptions;
            options.headers['Authorization'] =
                'Bearer ${tokens['accessToken']}';

            final dio = Dio(BaseOptions(baseUrl: options.baseUrl));
            final response = await dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (_) {
          _refreshFuture = null;
          await _expireSession();
          return handler.next(err);
        }
      }

      await _expireSession();
    }
    return handler.next(err);
  }

  Future<void> _expireSession() {
    _expireFuture ??= () async {
      await _tokenStorage.clear();
      final callback = onSessionExpired;
      if (callback != null) await callback();
    }();
    return _expireFuture!;
  }
}
