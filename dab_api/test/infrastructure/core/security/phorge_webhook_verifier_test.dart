import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dab_api/src/infrastructure/core/security/phorge_webhook_verifier.dart';
import 'package:test/test.dart';

void main() {
  final verifier = PhorgeWebhookVerifier();

  String sign(String body, String key) {
    return Hmac(sha256, utf8.encode(key)).convert(utf8.encode(body)).toString();
  }

  test('accepts a valid unprefixed hex HMAC signature', () {
    const body = '{"object":{"type":"TASK","phid":"PHID-TASK-1"}}';
    const key = 'herald-hmac-key';

    expect(
      verifier.isValidSignature(
        body: body,
        signatureHeader: sign(body, key),
        hmacKey: key,
      ),
      isTrue,
    );
  });

  test('accepts uppercase hex signatures (case-insensitive compare)', () {
    const body = '{"a":1}';
    const key = 'k';

    expect(
      verifier.isValidSignature(
        body: body,
        signatureHeader: sign(body, key).toUpperCase(),
        hmacKey: key,
      ),
      isTrue,
    );
  });

  test('rejects signatures produced with a different key', () {
    const body = '{"a":1}';

    expect(
      verifier.isValidSignature(
        body: body,
        signatureHeader: sign(body, 'other-key'),
        hmacKey: 'k',
      ),
      isFalse,
    );
  });

  test('rejects empty signature or key', () {
    expect(
      verifier.isValidSignature(body: 'x', signatureHeader: '', hmacKey: 'k'),
      isFalse,
    );
    expect(
      verifier.isValidSignature(
        body: 'x',
        signatureHeader: 'deadbeef',
        hmacKey: '',
      ),
      isFalse,
    );
  });
}
