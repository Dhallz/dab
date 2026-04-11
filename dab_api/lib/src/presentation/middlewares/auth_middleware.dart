import 'package:relic/relic.dart';

import '../../domain/entities/user/user_role.dart';
import '../../infrastructure/security/jwt_provider.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTEXT]
/// ROLE: Cross-cutting Identity Property for the Request context.
final userIdProperty = ContextProperty<String>('userId');
final userRoleProperty = ContextProperty<String>('userRole');

extension AuthContext on Request {
  String get userId => userIdProperty.get(this);
  String? get userIdOrNull => userIdProperty[this];
  String get userRole => userRoleProperty.get(this);
  String? get userRoleOrNull => userRoleProperty[this];
}

/// [ARCH: PRESENTATION_MIDDLEWARE]
/// ROLE: Request Interceptor for Authentication Guarding.
/// CONTRACT: Implements [MiddlewareObject] to verify Bearer tokens via [JwtProvider].
/// CONSTRAINTS: Must fail early with 401 Unauthorized for invalid or missing tokens.
class AuthMiddleware extends MiddlewareObject {
  final JwtProvider _jwtProvider = sl<JwtProvider>();

  /// Bootstrap endpoints that must work before login. Relic [Router.use] composes
  /// middleware along path prefixes; this bypass guarantees no accidental wrap.
  static bool _anonymousGetAllowed(Request request) {
    if (request.method != Method.get) return false;
    var path = Uri.decodeFull(request.url.path);
    while (path.contains('//')) {
      path = path.replaceAll('//', '/');
    }
    if (path.isEmpty) path = '/';
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path == '/metadata/configs' || path == '/metadata/status';
  }

  @override
  Handler call(Handler next) {
    return (request) async {
      if (_anonymousGetAllowed(request)) {
        return await next(request);
      }

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

      // Store the userId and userRole in the context property
      userIdProperty[request] = jwt.payload['sub'] as String;
      userRoleProperty[request] =
          jwt.payload['role'] as String? ?? UserRole.standard.name;

      return await next(request);
    };
  }
}
