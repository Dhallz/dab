import 'package:dab_api/src/infrastructure/core/config/config.dart';
import 'package:dab_api/src/infrastructure/core/adapters/oauth_client_credential_resolver.dart';
import 'package:test/test.dart';

void main() {
  final resolver = OauthClientCredentialResolver(Config());

  test('readOauthSetting skips JSON null and the string null', () {
    expect(({'clientId': null}).readOauthSetting(const ['clientId']), isNull);
    expect(({'clientId': 'null'}).readOauthSetting(const ['clientId']), isNull);
    expect(({'clientId': '  '}).readOauthSetting(const ['clientId']), isNull);
    expect(
      ({'clientId': '"abc-client"'}).readOauthSetting(const ['clientId']),
      'abc-client',
    );
  });

  test('does not send client_id=null when settings omit clientId', () {
    final result = resolver.resolve(
      providerId: 'no-such-oauth-provider',
      orgSettings: const {'clientId': null},
    );
    expect(result, isNull);
  });

  test('uses a real clientId from org settings', () {
    final result = resolver.resolve(
      providerId: 'jira',
      orgSettings: const {
        'clientId': '  real-client-id  ',
        'clientSecret': 's',
      },
    );
    expect(result?.clientId, 'real-client-id');
    expect(result?.clientSecret, 's');
  });
}
