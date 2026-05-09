import 'dart:convert';

import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/json_rest_protocol.dart';
import 'package:http/http.dart' as http;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Default [JsonRestProtocol] using [http.Client].
/// CONTRACT: [defaultTimeout] applies when [timeout] is null on calls.
class HttpJsonRestProtocol implements JsonRestProtocol {
  final http.Client _client;

  @override
  final Duration defaultTimeout;

  HttpJsonRestProtocol({
    http.Client? client,
    this.defaultTimeout = const Duration(seconds: 12),
  }) : _client = client ?? http.Client();

  @override
  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final t = timeout ?? defaultTimeout;
    try {
      return await _client.get(uri, headers: headers).timeout(t);
    } catch (e) {
      throw JsonRestProtocolException(
        message: 'GET failed: $e',
        uri: uri,
      );
    }
  }

  @override
  Future<List<dynamic>> getJsonList(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final response = await get(uri, headers: headers, timeout: timeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw JsonRestProtocolException(
        message: 'HTTP ${response.statusCode}',
        statusCode: response.statusCode,
        uri: uri,
      );
    }
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw JsonRestProtocolException(
          message: 'Expected JSON array response',
          statusCode: response.statusCode,
          uri: uri,
        );
      }
      return decoded;
    } on JsonRestProtocolException {
      rethrow;
    } catch (e) {
      throw JsonRestProtocolException(
        message: 'Invalid JSON: $e',
        statusCode: response.statusCode,
        uri: uri,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getJsonMap(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    final response = await get(uri, headers: headers, timeout: timeout);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw JsonRestProtocolException(
        message: 'HTTP ${response.statusCode}',
        statusCode: response.statusCode,
        uri: uri,
      );
    }
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        throw JsonRestProtocolException(
          message: 'Expected JSON object response',
          statusCode: response.statusCode,
          uri: uri,
        );
      }
      return decoded;
    } on JsonRestProtocolException {
      rethrow;
    } catch (e) {
      throw JsonRestProtocolException(
        message: 'Invalid JSON: $e',
        statusCode: response.statusCode,
        uri: uri,
      );
    }
  }
}
