import 'package:dab_api/src/domain/core/provider_credential_keys.dart';
import 'package:test/test.dart';

void main() {
  test('Jira OAuth prefers apiToken over an org PAT in api.token', () {
    final token = ({
      'api.token': 'org-pat',
      'apiToken': 'oauth-access',
      'tokenType': 'oauth',
    }).extractProviderToken('jira');
    expect(token, 'oauth-access');
  });

  test('Jira PAT still reads api.token', () {
    final token = ({
      'api.token': 'org-pat',
      'email': 'ada@example.com',
    }).extractProviderToken('jira');
    expect(token, 'org-pat');
  });

  test('GitHub falls back to accessToken when api.token is absent', () {
    expect(
      ({'accessToken': 'gho_oauth'}).extractProviderToken('github'),
      'gho_oauth',
    );
  });

  test('Linear falls back to accessToken when apiKey is absent', () {
    expect(
      ({'accessToken': 'lin_oauth'}).extractProviderToken('linear'),
      'lin_oauth',
    );
  });

  test('oauthAccessTokenNeedsRefresh is true near expiry', () {
    final now = DateTime.utc(2026, 8, 14, 20);
    expect(
      ({
        'tokenType': 'oauth',
        'refreshToken': 'r',
        'tokenExpiresAt': DateTime.utc(2026, 8, 14, 20, 1).toIso8601String(),
      }).oauthAccessTokenNeedsRefresh(now: now),
      isTrue,
    );
    expect(
      ({
        'tokenType': 'oauth',
        'refreshToken': 'r',
        'tokenExpiresAt': DateTime.utc(2026, 8, 14, 22).toIso8601String(),
      }).oauthAccessTokenNeedsRefresh(now: now),
      isFalse,
    );
  });
}
