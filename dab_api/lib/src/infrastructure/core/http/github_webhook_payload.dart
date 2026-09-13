import 'dart:convert';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Normalizes GitHub webhook HTTP bodies into a JSON object map.
/// CONTRACT: Supports `application/json` (raw JSON) and GitHub’s
/// `application/x-www-form-urlencoded` shape (`payload=<url-encoded-json>`).
/// CONSTRAINTS: No I/O; returns null when the payload cannot be decoded.
extension OnString on String {
  /// Decodes a GitHub webhook HTTP body into a JSON object map.
  Map<String, dynamic>? decodeGitHubWebhookPayload() {
    final trimmed = trim();
    if (trimmed.isEmpty) {
      return null;
    }

    Object? decoded;
    try {
      decoded = jsonDecode(trimmed);
    } on FormatException {
      decoded = null;
    }

    if (decoded == null) {
      try {
        final query = Uri.splitQueryString(
          trimmed,
          encoding: utf8,
        );
        final payloadRaw = query['payload'];
        if (payloadRaw != null && payloadRaw.isNotEmpty) {
          decoded = jsonDecode(payloadRaw);
        }
      } on FormatException {
        return null;
      }
    }

    return decoded is Map<String, dynamic> ? decoded : null;
  }
}
