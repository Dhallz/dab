import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

import '../../../domain/contracts/ports/abs_i_push_wake_gateway.dart';
import '../../../domain/core/inbox_wake.dart';
import '../config/config.dart';
import 'noop_push_wake_gateway.dart';

/// [ARCH: INFRASTRUCTURE]
/// ROLE: FCM HTTP v1 data-only inbox wakes. Never sets a `notification` block.
class FcmHttpV1PushWakeGateway implements AbsIPushWakeGateway {
  FcmHttpV1PushWakeGateway({
    required this.projectId,
    required this.sendHttp,
  });

  final String projectId;
  final Future<void> Function({
    required Uri uri,
    required Map<String, String> headers,
    required Map<String, dynamic> body,
  })
  sendHttp;

  @override
  Future<void> sendWake({
    required List<String> tokens,
    required Map<String, String> data,
  }) async {
    if (!isInboxWakeData(data)) return;
    for (final raw in tokens) {
      final token = raw.trim();
      if (token.isEmpty) continue;
      final body = <String, dynamic>{
        'message': <String, dynamic>{
          'token': token,
          'data': data,
        },
      };
      await sendHttp(
        uri: Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
        ),
        headers: const {'Content-Type': 'application/json'},
        body: body,
      );
    }
  }

  /// No-op in development or when a service account is missing/invalid.
  static AbsIPushWakeGateway resolve(
    Config config, {
    http.Client? client,
  }) {
    if (config.isDevelopment) return const NoopPushWakeGateway();
    return tryParse(config.fcmServiceAccountJson, client: client) ??
        const NoopPushWakeGateway();
  }

  /// Builds a gateway from a Google service-account JSON string.
  ///
  /// Returns null when [raw] is not a usable service account (caller uses noop).
  static FcmHttpV1PushWakeGateway? tryParse(
    String raw, {
    http.Client? client,
  }) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    late final Map<String, dynamic> map;
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map) return null;
      map = Map<String, dynamic>.from(decoded);
    } catch (_) {
      return null;
    }
    final projectId = (map['project_id'] ?? '').toString().trim();
    final clientEmail = (map['client_email'] ?? '').toString().trim();
    final privateKey = (map['private_key'] ?? '').toString().replaceAll(
      r'\n',
      '\n',
    );
    if (projectId.isEmpty || clientEmail.isEmpty || privateKey.isEmpty) {
      return null;
    }
    final httpClient = client ?? http.Client();
    String? cachedAccessToken;
    DateTime? tokenExpiresAt;
    return FcmHttpV1PushWakeGateway(
      projectId: projectId,
      sendHttp: ({required uri, required headers, required body}) async {
        final encoded = jsonEncode(body);
        if (encoded.contains('"notification"')) {
          return;
        }
        final now = DateTime.now().toUtc();
        if (cachedAccessToken == null ||
            tokenExpiresAt == null ||
            !now.isBefore(tokenExpiresAt!.subtract(const Duration(minutes: 2)))) {
          cachedAccessToken = await _fetchAccessToken(
            httpClient: httpClient,
            clientEmail: clientEmail,
            privateKeyPem: privateKey,
          );
          tokenExpiresAt = DateTime.now().toUtc().add(const Duration(minutes: 50));
        }
        await httpClient.post(
          uri,
          headers: {
            ...headers,
            'Authorization': 'Bearer $cachedAccessToken',
          },
          body: encoded,
        );
      },
    );
  }
}

Future<String> _fetchAccessToken({
  required http.Client httpClient,
  required String clientEmail,
  required String privateKeyPem,
}) async {
  final jwt = JWT({
    'iss': clientEmail,
    'sub': clientEmail,
    'aud': 'https://oauth2.googleapis.com/token',
    'scope': 'https://www.googleapis.com/auth/firebase.messaging',
  });
  final assertion = jwt.sign(
    RSAPrivateKey(privateKeyPem),
    algorithm: JWTAlgorithm.RS256,
    expiresIn: const Duration(hours: 1),
  );
  final response = await httpClient.post(
    Uri.parse('https://oauth2.googleapis.com/token'),
    headers: const {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      'assertion': assertion,
    },
  );
  final decoded = jsonDecode(response.body);
  if (decoded is! Map) {
    throw StateError('FCM OAuth token response was not a map');
  }
  final accessToken = (decoded['access_token'] ?? '').toString().trim();
  if (accessToken.isEmpty) {
    throw StateError('FCM OAuth token response missing access_token');
  }
  return accessToken;
}
