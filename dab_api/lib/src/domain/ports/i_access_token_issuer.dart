/// [ARCH: DOMAIN_PORT]
/// ROLE: Issues short-lived access tokens for authenticated sessions.
/// CONTRACT: Application auth use cases depend on this port, not the JWT helper.
/// Token verification stays on the infrastructure JWT helper (middleware).
abstract interface class IAccessTokenIssuer {
  /// Signs [payload] as an access token.
  String generateToken(Map<String, dynamic> payload);
}
