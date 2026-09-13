import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dab_api/src/infrastructure/core/security/github_webhook_verifier.dart';
import 'package:test/test.dart';

void main() {
  group('GitHubWebhookVerifier', () {
    final verifier = GitHubWebhookVerifier();

    test('returns true for valid sha256 signature', () {
      const body = '{"action":"push"}';
      const secret = 'webhook_secret';
      final digest = Hmac(
        sha256,
        utf8.encode(secret),
      ).convert(utf8.encode(body));
      final signature = 'sha256=$digest';

      final valid = verifier.isValidSha256Signature(
        body: body,
        signature256Header: signature,
        webhookSecret: secret,
      );

      expect(valid, isTrue);
    });

    test('returns false for wrong secret', () {
      const body = '{"action":"push"}';
      const secret = 'webhook_secret';
      final digest = Hmac(
        sha256,
        utf8.encode(secret),
      ).convert(utf8.encode(body));
      final signature = 'sha256=$digest';

      final valid = verifier.isValidSha256Signature(
        body: body,
        signature256Header: signature,
        webhookSecret: 'other',
      );

      expect(valid, isFalse);
    });

    test('returns false when header missing sha256 prefix', () {
      const body = '{}';
      const secret = 's';
      final digest = Hmac(
        sha256,
        utf8.encode(secret),
      ).convert(utf8.encode(body));

      final valid = verifier.isValidSha256Signature(
        body: body,
        signature256Header: digest.toString(),
        webhookSecret: secret,
      );

      expect(valid, isFalse);
    });

    test('matches Atlassian Jira admin webhook test vector', () {
      const body = 'Hello World!';
      const secret = "It's a Secret to Everybody";
      const signature =
          'sha256=a4771c39fbe90f317c7824e83ddef3caae9cb3d976c214ace1f2937e133263c9';

      final valid = verifier.isValidSha256Signature(
        body: body,
        signature256Header: signature,
        webhookSecret: secret,
      );

      expect(valid, isTrue);
    });
  });
}
