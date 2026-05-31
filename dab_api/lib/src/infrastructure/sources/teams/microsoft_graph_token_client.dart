import 'dart:convert';

import 'package:http/http.dart' as http;

/// [ARCH: INFRASTRUCTURE]
/// ROLE: Azure AD client-credentials token acquisition for Microsoft Graph.
/// CONSTRAINTS: Never log secrets or tokens.
class MicrosoftGraphTokenClient {
  const MicrosoftGraphTokenClient();

  /// Returns a bearer token for `https://graph.microsoft.com/.default`, or null.
  Future<String?> fetchAppToken({
    required String tenantId,
    required String clientId,
    required String clientSecret,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final normalizedTenant = tenantId.trim();
    final normalizedClientId = clientId.trim();
    final normalizedSecret = clientSecret.trim();
    if (normalizedTenant.isEmpty ||
        normalizedClientId.isEmpty ||
        normalizedSecret.isEmpty) {
      return null;
    }

    final uri = Uri.parse(
      'https://login.microsoftonline.com/$normalizedTenant/oauth2/v2.0/token',
    );
    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: {
              'client_id': normalizedClientId,
              'client_secret': normalizedSecret,
              'grant_type': 'client_credentials',
              'scope': 'https://graph.microsoft.com/.default',
            },
          )
          .timeout(timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return null;
      }
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final token = decoded['access_token']?.toString().trim();
      if (token == null || token.isEmpty) {
        return null;
      }
      return token;
    } catch (_) {
      return null;
    }
  }
}
