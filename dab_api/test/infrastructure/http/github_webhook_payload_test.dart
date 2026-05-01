import 'package:dab_api/src/infrastructure/http/github_webhook_payload.dart';
import 'package:test/test.dart';

void main() {
  group('decodeGitHubWebhookPayload', () {
    test('parses raw JSON', () {
      const body = '{"ref":"refs/heads/main","zen":"ping"}';
      final map = decodeGitHubWebhookPayload(body);
      expect(map, isNotNull);
      expect(map!['ref'], 'refs/heads/main');
    });

    test('parses application/x-www-form-urlencoded payload field', () {
      // GitHub sends JSON url-encoded as the payload form value.
      const inner = '{"ref":"refs/heads/main"}';
      final encoded = Uri.encodeQueryComponent(inner);
      final body = 'payload=$encoded';
      final map = decodeGitHubWebhookPayload(body);
      expect(map, isNotNull);
      expect(map!['ref'], 'refs/heads/main');
    });

    test('returns null for garbage', () {
      expect(decodeGitHubWebhookPayload('not-json'), isNull);
      expect(decodeGitHubWebhookPayload(''), isNull);
    });
  });
}
