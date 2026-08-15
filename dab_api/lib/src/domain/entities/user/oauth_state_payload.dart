/// [ARCH: DOMAIN]
/// ROLE: One-time OAuth CSRF/PKCE state stored in Redis until the callback.
class OauthStatePayload {
  const OauthStatePayload({
    required this.userId,
    required this.providerId,
    required this.codeVerifier,
    required this.redirectUri,
  });

  final String userId;
  final String providerId;
  final String codeVerifier;
  final String redirectUri;

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'providerId': providerId,
    'codeVerifier': codeVerifier,
    'redirectUri': redirectUri,
  };

  factory OauthStatePayload.fromMap(Map<String, dynamic> map) {
    return OauthStatePayload(
      userId: (map['userId'] ?? '').toString(),
      providerId: (map['providerId'] ?? '').toString(),
      codeVerifier: (map['codeVerifier'] ?? '').toString(),
      redirectUri: (map['redirectUri'] ?? '').toString(),
    );
  }
}
