/// [ARCH: DOMAIN]
/// ROLE: Normalized OAuth token-endpoint response (never logged).
class OauthTokenResponse {
  const OauthTokenResponse({
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.tokenType,
  });

  final String accessToken;
  final String? refreshToken;
  final int? expiresIn;
  final String? tokenType;
}
