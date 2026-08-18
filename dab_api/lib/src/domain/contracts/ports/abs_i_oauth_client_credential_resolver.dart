/// [ARCH: DOMAIN]
/// ROLE: Instance OAuth app credentials (Admin ProviderConfig or env fallback).
class OauthAppCredentials {
  const OauthAppCredentials({required this.clientId, this.clientSecret});

  final String clientId;
  final String? clientSecret;
}

/// [ARCH: DOMAIN_PORT]
/// ROLE: Resolves OAuth client id/secret for a provider.
abstract interface class AbsIOauthClientCredentialResolver {
  OauthAppCredentials? resolve({
    required String providerId,
    required Map<String, dynamic> orgSettings,
  });
}
