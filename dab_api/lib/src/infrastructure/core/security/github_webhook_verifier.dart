import 'dart:convert';

import 'package:crypto/crypto.dart';

/// [ARCH: INFRASTRUCTURE_SECURITY]
/// ROLE: Validates inbound GitHub repository webhook payloads.
/// CONTRACT: Matches GitHub `X-Hub-Signature-256` HMAC semantics on the raw body.
/// CONSTRAINTS: Constant-time digest comparison.
class GitHubWebhookVerifier {
  /// Returns true when [signature256Header] matches HMAC SHA-256(body, secret)
  /// using prefix `sha256=`.
  bool isValidSha256Signature({
    required String body,
    required String signature256Header,
    required String webhookSecret,
  }) {
    final secret = webhookSecret.trim();
    final signature = signature256Header.trim();
    if (secret.isEmpty || signature.isEmpty) {
      return false;
    }

    if (!signature.toLowerCase().startsWith('sha256=')) {
      return false;
    }

    final providedHex = signature.substring(7).trim();
    if (providedHex.isEmpty) {
      return false;
    }

    final hmacDigest = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(body));
    final expected = 'sha256=${hmacDigest.toString()}';

    return _constantTimeEquals(expected.toLowerCase(), signature.toLowerCase());
  }

  bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) {
      return false;
    }
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
