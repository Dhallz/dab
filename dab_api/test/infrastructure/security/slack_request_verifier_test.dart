import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dab_api/src/infrastructure/core/security/slack_request_verifier.dart';
import 'package:test/test.dart';

void main() {
  group('SlackRequestVerifier', () {
    final verifier = SlackRequestVerifier();

    test('returns true for valid signature', () {
      const body = '{"type":"event_callback"}';
      const secret = 'signing_secret';
      final timestamp = (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000)
          .toString();
      final base = 'v0:$timestamp:$body';
      final digest = Hmac(
        sha256,
        utf8.encode(secret),
      ).convert(utf8.encode(base));
      final signature = 'v0=$digest';

      final valid = verifier.isValid(
        body: body,
        signatureHeader: signature,
        timestampHeader: timestamp,
        signingSecret: secret,
      );

      expect(valid, isTrue);
    });

    test('returns false for stale timestamp', () {
      const body = '{"type":"event_callback"}';
      const secret = 'signing_secret';
      const timestamp = '1';
      const signature = 'v0=abc';

      final valid = verifier.isValid(
        body: body,
        signatureHeader: signature,
        timestampHeader: timestamp,
        signingSecret: secret,
      );

      expect(valid, isFalse);
    });
  });
}
