import 'package:relic/relic.dart';

import '../../domain/entities/user/user_role.dart';
import '../../infrastructure/core/security/jwt_provider.dart';
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
  AuthMiddleware({JwtProvider? jwtProvider})
    : _jwtProvider = jwtProvider ?? sl<JwtProvider>();

  final JwtProvider _jwtProvider;

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

      final token = _readBearerToken(request);

      if (token == null) {
        return Response.unauthorized(
          body: Body.fromString('Missing or invalid token'),
        );
      }

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

  /// Relic stores Authorization as a typed header; raw map lookup can miss it
  /// depending on how dart:io folded the name. Prefer the typed accessor.
  static String? _readBearerToken(Request request) {
    try {
      final auth = request.headers.authorization;
      if (auth is BearerAuthorizationHeader) {
        final token = auth.token.trim();
        return token.isEmpty ? null : token;
      }
    } on HeaderException {
      // Malformed Authorization — try the raw value below.
    }

    final raw = _rawAuthorizationHeader(request);
    if (raw == null || !raw.startsWith('Bearer ')) return null;
    final token = raw.substring(7).trim();
    return token.isEmpty ? null : token;
  }

  static String? _rawAuthorizationHeader(Request request) {
    final direct = request.headers['Authorization'];
    if (direct != null && direct.isNotEmpty) {
      return direct.first;
    }

    final lower = request.headers['authorization'];
    if (lower != null && lower.isNotEmpty) {
      return lower.first;
    }

    for (final entry in request.headers.entries) {
      if (entry.key.toLowerCase() == 'authorization' &&
          entry.value.isNotEmpty) {
        return entry.value.first;
      }
    }
    return null;
  }
}
