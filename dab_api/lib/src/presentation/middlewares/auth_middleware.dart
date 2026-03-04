import 'package:relic/relic.dart';

import '../../application/auth_service.dart';
import '../../service_locator.dart';

final userIdProperty = ContextProperty<String>('userId');

extension AuthContext on Request {
  String get userId => userIdProperty.get(this);
  String? get userIdOrNull => userIdProperty[this];
}

class AuthMiddleware extends MiddlewareObject {
  final AuthService _authService = sl<AuthService>();

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
      final jwt = _authService.verifyToken(token);

      if (jwt == null) {
        return Response.unauthorized(body: Body.fromString('Invalid token'));
      }

      // Store the userId in the context property
      userIdProperty[request] = jwt.payload['sub'] as String;

      return await next(request);
    };
  }
}
