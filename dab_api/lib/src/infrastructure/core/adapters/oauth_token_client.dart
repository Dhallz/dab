import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../domain/core/failures/failure.dart';
import '../../domain/core/oauth_providers.dart';
import '../../domain/entities/user/oauth_token_response.dart';
import '../../domain/ports/i_oauth_token_client.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: OAuth token exchange over HTTP. Never logs tokens or client secrets.
class HttpOauthTokenClient implements IOauthTokenClient {
  HttpOauthTokenClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<Either<Failure, OauthTokenResponse>> exchangeAuthorizationCode({
    required OauthProviderSpec spec,
    required String clientId,
    String? clientSecret,
    required String code,
    required String redirectUri,
    required String codeVerifier,
  }) async {
    final fields = <String, String>{
      'grant_type': 'authorization_code',
      'client_id': clientId,
      'code': code,
      'redirect_uri': redirectUri,
    };
    if (spec.usePkce) {
      fields['code_verifier'] = codeVerifier;
    }
    return _postToken(
      spec: spec,
      clientId: clientId,
      clientSecret: clientSecret,
      fields: fields,
      rejectedMessage: 'Provider rejected the OAuth code exchange',
      failedMessage: 'Could not complete OAuth token exchange',
    );
  }

  @override
  Future<Either<Failure, OauthTokenResponse>> refreshAccessToken({
    required OauthProviderSpec spec,
    required String clientId,
    String? clientSecret,
    required String refreshToken,
  }) {
    return _postToken(
      spec: spec,
      clientId: clientId,
      clientSecret: clientSecret,
      fields: {
        'grant_type': 'refresh_token',
        'client_id': clientId,
        'refresh_token': refreshToken,
      },
      rejectedMessage: 'Provider rejected the OAuth token refresh',
      failedMessage: 'Could not refresh the OAuth access token',
    );
  }

  Future<Either<Failure, OauthTokenResponse>> _postToken({
    required OauthProviderSpec spec,
    required String clientId,
    required String? clientSecret,
    required Map<String, String> fields,
    required String rejectedMessage,
    required String failedMessage,
  }) async {
    try {
      if (clientSecret != null &&
          clientSecret.isNotEmpty &&
          !spec.useBasicClientAuth) {
        fields['client_secret'] = clientSecret;
      }

      final headers = <String, String>{
        'Accept': 'application/json',
      };
      if (spec.useBasicClientAuth &&
          clientSecret != null &&
          clientSecret.isNotEmpty) {
        final basic = base64Encode(utf8.encode('$clientId:$clientSecret'));
        headers['Authorization'] = 'Basic $basic';
      }

      http.Response response;
      if (spec.tokenRequestJson) {
        headers['Content-Type'] = 'application/json';
        response = await _client.post(
          Uri.parse(spec.tokenUrl),
          headers: headers,
          body: jsonEncode(fields),
        );
      } else {
        headers['Content-Type'] = 'application/x-www-form-urlencoded';
        response = await _client.post(
          Uri.parse(spec.tokenUrl),
          headers: headers,
          body: fields,
        );
      }

      if (response.statusCode < 200 || response.statusCode >= 300) {
        return Left(ValidationFailure(rejectedMessage));
      }

      final decoded = _decodeBody(response.body);
      final access = (decoded['access_token'] ?? '').toString().trim();
      if (access.isEmpty) {
        return const Left(
          ValidationFailure('Provider did not return an access token'),
        );
      }
      final refresh = (decoded['refresh_token'] ?? '').toString().trim();
      final expiresRaw = decoded['expires_in'];
      int? expiresIn;
      if (expiresRaw is num) {
        expiresIn = expiresRaw.toInt();
      } else if (expiresRaw != null) {
        expiresIn = int.tryParse(expiresRaw.toString());
      }
      return Right(
        OauthTokenResponse(
          accessToken: access,
          refreshToken: refresh.isEmpty ? null : refresh,
          expiresIn: expiresIn,
          tokenType: (decoded['token_type'] ?? '').toString().trim().isEmpty
              ? null
              : decoded['token_type'].toString().trim(),
        ),
      );
    } catch (_) {
      return Left(ValidationFailure(failedMessage));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getJsonList(
    Uri uri, {
    required Map<String, String> headers,
  }) async {
    try {
      final response = await _client.get(uri, headers: headers);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return const Left(
          ValidationFailure('Provider resource request failed'),
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        return const Left(ValidationFailure('Unexpected provider response'));
      }
      return Right([
        for (final item in decoded)
          if (item is Map) Map<String, dynamic>.from(item),
      ]);
    } catch (_) {
      return const Left(
        ValidationFailure('Could not read provider resources'),
      );
    }
  }

  Map<String, dynamic> _decodeBody(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return const {};
    if (trimmed.startsWith('{')) {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return const {};
    }
    return Uri.splitQueryString(trimmed);
  }
}
