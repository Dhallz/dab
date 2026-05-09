library;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Typed failures for protocol HTTP adapters — infrastructure-only.
/// CONSTRAINTS: No raw HTTP bodies in exceptions; not domain [Failure].

/// Base type for protocol-layer errors (Conduit, JSON REST, GraphQL, Slack Web API).
sealed class ProtocolException implements Exception {
  /// Human-readable summary safe for logs (no secrets).
  final String message;

  ProtocolException(this.message);

  @override
  String toString() => message;
}

/// Conduit (`api.error_code` / transport).
final class ConduitException extends ProtocolException {
  final String code;
  final String info;

  ConduitException({required this.code, required this.info})
    : super('ConduitException: [$code] $info');
}

/// JSON-over-HTTP REST helper failures (no response body stored).
final class JsonRestProtocolException extends ProtocolException {
  final int? statusCode;
  final Uri? uri;

  JsonRestProtocolException({
    required String message,
    this.statusCode,
    this.uri,
  }) : super(message);
}

/// GraphQL HTTP or `errors` array.
final class GraphqlProtocolException extends ProtocolException {
  final List<Object?> errors;
  final int? statusCode;

  GraphqlProtocolException({
    required String message,
    this.errors = const [],
    this.statusCode,
  }) : super(message);
}

/// Slack Web API (`ok: false` or HTTP failure).
final class SlackWebProtocolException extends ProtocolException {
  final String? slackError;
  final String? slackWarning;
  final int? statusCode;

  SlackWebProtocolException({
    required String message,
    this.slackError,
    this.slackWarning,
    this.statusCode,
  }) : super(message);
}
