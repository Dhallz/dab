import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dab_api/src/infrastructure/core/security/linear_webhook_verifier.dart';
import 'package:test/test.dart';

void main() {
  final verifier = LinearWebhookVerifier();
  const secret = 'lin_wh_secret';
  const body = '{"type":"Issue","action":"update"}';

  String sign(String payload, String key) {
    return Hmac(sha256, utf8.encode(key)).convert(utf8.encode(payload)).toString();
  }

  test('accepts a valid signature', () {
    expect(
      verifier.isValidSignature(
        body: body,
        signatureHeader: sign(body, secret),
        signingSecret: secret,
      ),
      isTrue,
    );
  });

  test('rejects a signature produced with a different secret', () {
    expect(
      verifier.isValidSignature(
        body: body,
        signatureHeader: sign(body, 'other'),
        signingSecret: secret,
      ),
      isFalse,
    );
  });

  test('rejects a signature over a tampered body', () {
    expect(
      verifier.isValidSignature(
        body: '$body ',
        signatureHeader: sign(body, secret),
        signingSecret: secret,
      ),
      isFalse,
    );
  });

  test('rejects empty signature or secret', () {
    expect(
      verifier.isValidSignature(
        body: body,
        signatureHeader: '',
        signingSecret: secret,
      ),
      isFalse,
    );
    expect(
      verifier.isValidSignature(
        body: body,
        signatureHeader: sign(body, secret),
        signingSecret: '',
      ),
      isFalse,
    );
  });
}
