import 'dart:convert';

import 'package:crypto/crypto.dart';

/// [ARCH: INFRASTRUCTURE_SECURITY]
/// ROLE: Validates inbound Linear webhook payloads.
/// CONTRACT: Matches Linear `linear-signature` semantics — hex-encoded
/// HMAC-SHA256 of the raw request body with the webhook signing secret
/// (no algorithm prefix).
/// CONSTRAINTS: Constant-time digest comparison.
class LinearWebhookVerifier {
  /// Returns true when [signatureHeader] matches HMAC SHA-256(body, secret).
  bool isValidSignature({
    required String body,
    required String signatureHeader,
    required String signingSecret,
  }) {
    final secret = signingSecret.trim();
    final signature = signatureHeader.trim();
    if (secret.isEmpty || signature.isEmpty) {
      return false;
    }

    final expected = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(body)).toString();

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
