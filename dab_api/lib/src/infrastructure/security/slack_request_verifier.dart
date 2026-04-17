import 'dart:convert';

import 'package:crypto/crypto.dart';

/// [ARCH: INFRASTRUCTURE_SECURITY]
/// ROLE: Validates inbound Slack webhook signatures.
/// CONTRACT: Implements Slack's signing-secret verification protocol.
/// CONSTRAINTS: Rejects stale timestamps and non-matching HMAC signatures.
class SlackRequestVerifier {
  bool isValid({
    required String body,
    required String signatureHeader,
    required String timestampHeader,
    required String signingSecret,
    Duration maxSkew = const Duration(minutes: 5),
  }) {
    if (signingSecret.isEmpty ||
        signatureHeader.isEmpty ||
        timestampHeader.isEmpty) {
      return false;
    }

    final timestampSeconds = int.tryParse(timestampHeader);
    if (timestampSeconds == null) {
      return false;
    }

    final requestTime = DateTime.fromMillisecondsSinceEpoch(
      timestampSeconds * 1000,
      isUtc: true,
    );
    final now = DateTime.now().toUtc();
    if (now.difference(requestTime).abs() > maxSkew) {
      return false;
    }

    final baseString = 'v0:$timestampHeader:$body';
    final hmacDigest = Hmac(
      sha256,
      utf8.encode(signingSecret),
    ).convert(utf8.encode(baseString));
    final expected = 'v0=${hmacDigest.toString()}';

    return _constantTimeEquals(expected, signatureHeader);
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
