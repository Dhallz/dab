import 'package:dab_api/src/infrastructure/core/security/oauth_pkce.dart';
import 'package:test/test.dart';

void main() {
  test('S256 challenge is deterministic and does not echo the verifier', () {
    final pkce = OauthPkce();
    const verifier = 'dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk';
    final challenge = pkce.challengeS256(verifier);
    expect(challenge, isNot(contains(verifier)));
    expect(pkce.challengeS256(verifier), challenge);
  });

  test('state ids and verifiers are unique', () {
    final pkce = OauthPkce();
    expect(pkce.generateStateId(), isNot(pkce.generateStateId()));
    expect(pkce.generateVerifier(), isNot(pkce.generateVerifier()));
  });
}
