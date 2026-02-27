import 'dart:convert';

import 'package:relic/relic.dart';

import '../../services/auth_service.dart';

class AuthMiddleware extends MiddlewareObject {
  final AuthService _authService = AuthService();

  @override
  Handler call(Handler next) {
    return (request) async {
      final auth = request.headers.authorization;

      if (auth is! BearerAuthorizationHeader) {
        return Response.unauthorized(
          body: Body.fromString(
            jsonEncode({'error': 'Missing or invalid Authorization header'}),
            mimeType: MimeType.json,
          ),
        );
      }

      final jwt = _authService.verifyToken(auth.token);

      if (jwt == null) {
        return Response.unauthorized(
          body: Body.fromString(
            jsonEncode({'error': 'Invalid or expired token'}),
            mimeType: MimeType.json,
          ),
        );
      }

      return await next(request);
    };
  }
}
