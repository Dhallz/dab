library;

import 'package:http/http.dart' as http;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Contract for JSON-over-HTTP REST reads (GitHub-style APIs).
/// CONSTRAINTS: Implementations throw [JsonRestProtocolException] on failure; no raw bodies in exceptions.

abstract interface class JsonRestProtocol {
  /// Default timeout used when per-call [timeout] is omitted.
  Duration get defaultTimeout;

  Future<http.Response> get(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  });

  /// Decodes a JSON array response body; throws if status is not success or body is not a JSON array.
  Future<List<dynamic>> getJsonList(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  });

  /// Decodes a JSON object response body.
  Future<Map<String, dynamic>> getJsonMap(
    Uri uri, {
    Map<String, String>? headers,
    Duration? timeout,
  });
}
