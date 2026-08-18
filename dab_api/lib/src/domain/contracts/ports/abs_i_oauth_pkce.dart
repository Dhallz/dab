/// [ARCH: DOMAIN_PORT]
/// ROLE: PKCE S256 and OAuth state identifiers.
abstract interface class AbsIOauthPkce {
  String generateStateId();
  String generateVerifier();
  String challengeS256(String verifier);
}
