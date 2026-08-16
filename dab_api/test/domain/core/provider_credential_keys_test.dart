import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:test/test.dart';

void main() {
  test('Jira OAuth prefers apiToken over an org PAT in api.token', () {
    final token = extractProviderToken('jira', {
      'api.token': 'org-pat',
      'apiToken': 'oauth-access',
      'tokenType': 'oauth',
    });
    expect(token, 'oauth-access');
  });

  test('Jira PAT still reads api.token', () {
    final token = extractProviderToken('jira', {
      'api.token': 'org-pat',
      'email': 'ada@example.com',
    });
    expect(token, 'org-pat');
  });

  test('GitHub falls back to accessToken when api.token is absent', () {
    expect(
      extractProviderToken('github', {'accessToken': 'gho_oauth'}),
      'gho_oauth',
    );
  });

  test('oauthAccessTokenNeedsRefresh is true near expiry', () {
    final now = DateTime.utc(2026, 8, 14, 20);
    expect(
      oauthAccessTokenNeedsRefresh(
        {
          'tokenType': 'oauth',
          'refreshToken': 'r',
          'tokenExpiresAt': DateTime.utc(2026, 8, 14, 20, 1).toIso8601String(),
        },
        now: now,
      ),
      isTrue,
    );
    expect(
      oauthAccessTokenNeedsRefresh(
        {
          'tokenType': 'oauth',
          'refreshToken': 'r',
          'tokenExpiresAt': DateTime.utc(2026, 8, 14, 22).toIso8601String(),
        },
        now: now,
      ),
      isFalse,
    );
  });
}
