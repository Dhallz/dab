import 'package:dab_api/src/infrastructure/core/http/github_webhook_payload.dart';
import 'package:test/test.dart';

void main() {
  group('decodeGitHubWebhookPayload', () {
    test('parses raw JSON', () {
      const body = '{"ref":"refs/heads/main","zen":"ping"}';
      final map = body.decodeGitHubWebhookPayload();
      expect(map, isNotNull);
      expect(map!['ref'], 'refs/heads/main');
    });

    test('parses application/x-www-form-urlencoded payload field', () {
      // GitHub sends JSON url-encoded as the payload form value.
      const inner = '{"ref":"refs/heads/main"}';
      final encoded = Uri.encodeQueryComponent(inner);
      final body = 'payload=$encoded';
      final map = body.decodeGitHubWebhookPayload();
      expect(map, isNotNull);
      expect(map!['ref'], 'refs/heads/main');
    });

    test('returns null for garbage', () {
      expect(('not-json').decodeGitHubWebhookPayload(), isNull);
      expect(('').decodeGitHubWebhookPayload(), isNull);
    });
  });
}
