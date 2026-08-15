import 'dart:typed_data';

import 'package:dab_app/infrastructure/core/local/token_storage.dart';
import 'package:dab_app/infrastructure/core/remote/auth_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryTokens extends TokenStorage {
  Map<String, String>? stored;

  @override
  Future<Map<String, String>?> readTokens() async => stored;

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    stored = {'accessToken': accessToken, 'refreshToken': refreshToken};
  }

  @override
  Future<void> clear() async {
    stored = null;
  }
}

class _FixedAdapter implements HttpClientAdapter {
  _FixedAdapter(this.status, this.body);

  final int status;
  final String body;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['text/plain'],
      },
    );
  }
}

void main() {
  test('attaches Bearer when tokens exist', () async {
    final storage = _MemoryTokens()
      ..stored = {'accessToken': 'abc', 'refreshToken': 'r1'};
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9080'));
    dio.interceptors.add(AuthInterceptor(storage));
    dio.httpClientAdapter = _FixedAdapter(200, 'ok');

    final response = await dio.get('/users/me/credentials');
    expect(response.requestOptions.headers['Authorization'], 'Bearer abc');
  });

  test('expires session on 401 when no refresh token is stored', () async {
    final storage = _MemoryTokens();
    var expired = 0;
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9080'));
    dio.interceptors.add(
      AuthInterceptor(
        storage,
        onSessionExpired: () async {
          expired += 1;
        },
      ),
    );
    dio.httpClientAdapter = _FixedAdapter(401, 'Missing or invalid token');

    try {
      await dio.get('/users/me/credentials');
      fail('expected DioException');
    } on DioException catch (e) {
      expect(e.response?.statusCode, 401);
    }
    expect(expired, 1);
    expect(storage.stored, isNull);
  });

  test('does not expire session on public login 401', () async {
    final storage = _MemoryTokens();
    var expired = 0;
    final dio = Dio(BaseOptions(baseUrl: 'http://localhost:9080'));
    dio.interceptors.add(
      AuthInterceptor(
        storage,
        onSessionExpired: () async {
          expired += 1;
        },
      ),
    );
    dio.httpClientAdapter = _FixedAdapter(401, 'Invalid credentials');

    try {
      await dio.post('/auth/login');
      fail('expected DioException');
    } on DioException catch (e) {
      expect(e.response?.statusCode, 401);
    }
    expect(expired, 0);
  });
}
