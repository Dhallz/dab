import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../core/oauth_providers.dart';
import '../../entities/user/oauth_token_response.dart';

/// [ARCH: DOMAIN_PORT]
/// ROLE: Exchanges an authorization code for tokens. Never logs secrets.
abstract interface class AbsIOauthTokenClient {
  Future<Either<Failure, OauthTokenResponse>> exchangeAuthorizationCode({
    required OauthProviderSpec spec,
    required String clientId,
    String? clientSecret,
    required String code,
    required String redirectUri,
    required String codeVerifier,
  });

  /// Authenticated JSON GET used for Jira accessible-resources.
  Future<Either<Failure, List<Map<String, dynamic>>>> getJsonList(
    Uri uri, {
    required Map<String, String> headers,
  });

  /// Exchanges a refresh token for a new access token. Never logs secrets.
  Future<Either<Failure, OauthTokenResponse>> refreshAccessToken({
    required OauthProviderSpec spec,
    required String clientId,
    String? clientSecret,
    required String refreshToken,
  });
}
