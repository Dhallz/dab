import 'package:dab_app/domain/core/failures.dart';
import 'package:dab_app/infrastructure/core/local/api_origin_storage.dart';
import 'package:dab_app/infrastructure/core/local/token_storage.dart';
import 'package:dab_app/infrastructure/core/remote/rest_api_client.dart';
import 'package:dab_app/infrastructure/core/remote/web_socket_client.dart';
import 'package:dab_app/infrastructure/repositories/api_origin_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _MemoryOrigin extends ApiOriginStorage {
  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String origin) async {
    value = origin;
  }
}

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

void main() {
  late _MemoryOrigin storage;
  late _MemoryTokens tokens;
  late RestApiClient rest;
  late WebSocketClient ws;
  late ApiOriginRepository repository;

  setUp(() {
    storage = _MemoryOrigin();
    tokens = _MemoryTokens()
      ..stored = {'accessToken': 'a', 'refreshToken': 'r'};
    rest = RestApiClient(
      baseUrl: 'http://localhost:9080',
      dio: Dio(BaseOptions(baseUrl: 'http://localhost:9080')),
    );
    ws = WebSocketClient('ws://localhost:9080/ws');
    repository = ApiOriginRepository(storage, rest, ws, tokens);
  });

  test('getOrigin falls back to the compile-time default', () async {
    final result = await repository.getOrigin();
    expect(result.getOrElse((_) => ''), 'http://localhost:9080');
  });

  test('setOrigin retargets REST and WebSocket and persists', () async {
    final result = await repository.setOrigin('https://dab.example.com/');
    expect(result.getOrElse((_) => ''), 'https://dab.example.com');
    expect(rest.baseUrl, 'https://dab.example.com');
    expect(ws.url, 'wss://dab.example.com/ws');
    expect(storage.value, 'https://dab.example.com');
    expect(tokens.stored, isNull);
  });

  test('setOrigin keeps tokens when the origin is unchanged', () async {
    storage.value = 'http://localhost:9080';
    await repository.setOrigin('http://localhost:9080');
    expect(tokens.stored, isNotNull);
  });

  test('setOrigin rejects an invalid URL', () async {
    final result = await repository.setOrigin('ftp://example.com');
    expect(result.fold((l) => l, (_) => null), isA<ValidationFailure>());
    expect(rest.baseUrl, 'http://localhost:9080');
    expect(tokens.stored, isNotNull);
  });
}
