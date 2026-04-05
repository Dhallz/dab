import 'package:relic/relic.dart';
import '../../infrastructure/security/jwt_provider.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTEXT]
/// ROLE: Cross-cutting Identity Property for the Request context.
final userIdProperty = ContextProperty<String>('userId');

extension AuthContext on Request {
  String get userId => userIdProperty.get(this);
  String? get userIdOrNull => userIdProperty[this];
}

/// [ARCH: PRESENTATION_MIDDLEWARE]
/// ROLE: Request Interceptor for Authentication Guarding.
/// CONTRACT: Implements [MiddlewareObject] to verify Bearer tokens via [JwtProvider].
/// CONSTRAINTS: Must fail early with 401 Unauthorized for invalid or missing tokens.
class AuthMiddleware extends MiddlewareObject {
  final JwtProvider _jwtProvider = sl<JwtProvider>();

  @override
  Handler call(Handler next) {
    return (request) async {
      final authHeaders = request.headers['Authorization'];
      final authHeader = authHeaders?.isNotEmpty == true
          ? authHeaders!.first
          : null;

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.unauthorized(
          body: Body.fromString('Missing or invalid token'),
        );
      }

      final token = authHeader.substring(7);
      final jwt = _jwtProvider.verifyToken(token);

      if (jwt == null) {
        return Response.unauthorized(body: Body.fromString('Invalid token'));
      }

      // Store the userId in the context property
      userIdProperty[request] = jwt.payload['sub'] as String;

      return await next(request);
    };
  }
}
