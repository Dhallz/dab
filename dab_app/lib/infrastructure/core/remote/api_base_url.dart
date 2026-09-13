/// [ARCH: INFRASTRUCTURE]
/// ROLE: REST origin for the DAB API, overridable with `--dart-define=DAB_API_BASE`.
/// CONTRACT: Default is local Docker (`http://localhost:9080`). HTTPS bases
/// map to `wss://…/ws`.
class ApiBaseUrl {
  /// Compile-time origin. Omit the define when talking to local Compose.
  static const fromEnvironment = String.fromEnvironment(
    'DAB_API_BASE',
    defaultValue: 'http://localhost:9080',
  );

  /// WebSocket URL for [apiBase] (trailing slash stripped).
  static String webSocket([String apiBase = fromEnvironment]) {
    var base = apiBase.trim();
    while (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    final String ws;
    if (base.startsWith('https://')) {
      ws = 'wss://${base.substring('https://'.length)}';
    } else if (base.startsWith('http://')) {
      ws = 'ws://${base.substring('http://'.length)}';
    } else {
      throw FormatException(
        'DAB_API_BASE must be an http(s) URL, got $apiBase',
      );
    }
    return '$ws/ws';
  }
}
