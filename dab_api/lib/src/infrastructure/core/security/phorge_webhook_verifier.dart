import 'dart:convert';

import 'package:crypto/crypto.dart';

/// [ARCH: INFRASTRUCTURE_SECURITY]
/// ROLE: Validates inbound Phorge (Phabricator) Herald webhook payloads.
/// CONTRACT: Matches the `X-Phabricator-Webhook-Signature` header — a plain
/// (unprefixed) hex HMAC SHA-256 of the raw request body keyed with the
/// webhook's HMAC key from the Herald webhook configuration page.
/// CONSTRAINTS: Constant-time digest comparison.
class PhorgeWebhookVerifier {
  /// Returns true when [signatureHeader] matches HMAC SHA-256(body, hmacKey).
  bool isValidSignature({
    required String body,
    required String signatureHeader,
    required String hmacKey,
  }) {
    final key = hmacKey.trim();
    final signature = signatureHeader.trim();
    if (key.isEmpty || signature.isEmpty) {
      return false;
    }

    final hmacDigest = Hmac(
      sha256,
      utf8.encode(key),
    ).convert(utf8.encode(body));

    return _constantTimeEquals(
      hmacDigest.toString().toLowerCase(),
      signature.toLowerCase(),
    );
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
