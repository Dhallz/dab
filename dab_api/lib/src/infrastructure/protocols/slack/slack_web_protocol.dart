library;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Contract for Slack Web API (HTTPS + JSON `ok` envelope).
/// CONSTRAINTS: Read-only; throws [SlackWebProtocolException] on transport or `ok: false`.

abstract interface class SlackWebProtocol {
  Duration get defaultTimeout;

  /// GET request with Bearer token; parses JSON and requires `ok: true`.
  Future<Map<String, dynamic>> getJson(
    Uri uri, {
    required String bearerToken,
    Duration? timeout,
  });

  /// POST request with Bearer token and empty body; parses JSON and requires `ok: true`.
  Future<Map<String, dynamic>> postJson(
    Uri uri, {
    required String bearerToken,
    Duration? timeout,
  });
}
