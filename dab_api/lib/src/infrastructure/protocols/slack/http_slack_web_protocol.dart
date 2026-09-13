import 'dart:convert';

import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/slack_web_protocol.dart';
import 'package:http/http.dart' as http;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: [SlackWebProtocol] over [http.Client].
class HttpSlackWebProtocol implements SlackWebProtocol {
  final http.Client _client;

  @override
  final Duration defaultTimeout;

  HttpSlackWebProtocol({
    http.Client? client,
    this.defaultTimeout = const Duration(seconds: 12),
  }) : _client = client ?? http.Client();

  static Map<String, String> _bearerHeaders(String token) => {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json; charset=utf-8',
  };

  @override
  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    required String bearerToken,
    Duration? timeout,
  }) async {
    final t = timeout ?? defaultTimeout;
    http.Response response;
    try {
      response = await _client
          .get(uri, headers: _bearerHeaders(bearerToken))
          .timeout(t);
    } catch (e) {
      throw SlackWebProtocolException(
        message: 'Slack GET failed: $e',
      );
    }
    return _parseSlackEnvelope(response, uri);
  }

  @override
  Future<Map<String, dynamic>> postJson(
    Uri uri, {
    required String bearerToken,
    Duration? timeout,
  }) async {
    final t = timeout ?? defaultTimeout;
    http.Response response;
    try {
      response = await _client
          .post(uri, headers: _bearerHeaders(bearerToken))
          .timeout(t);
    } catch (e) {
      throw SlackWebProtocolException(
        message: 'Slack POST failed: $e',
      );
    }
    return _parseSlackEnvelope(response, uri);
  }

  Map<String, dynamic> _parseSlackEnvelope(http.Response response, Uri uri) {
    if (response.statusCode != 200) {
      throw SlackWebProtocolException(
        message: 'HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      throw SlackWebProtocolException(
        message: 'Invalid JSON: $e',
        statusCode: response.statusCode,
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw SlackWebProtocolException(
        message: 'Slack response is not a JSON object',
        statusCode: response.statusCode,
      );
    }
    if (decoded['ok'] != true) {
      throw SlackWebProtocolException(
        message: decoded['error']?.toString() ?? 'Slack API error',
        slackError: decoded['error']?.toString(),
        slackWarning: decoded['warning']?.toString(),
        statusCode: response.statusCode,
      );
    }
    return decoded;
  }
}
