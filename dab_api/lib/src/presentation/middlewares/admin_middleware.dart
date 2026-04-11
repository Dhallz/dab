import 'package:dab_api/src/presentation/middlewares/auth_middleware.dart';
import 'package:relic/relic.dart';

import '../../domain/entities/user/user_role.dart';
import '../../domain/repositories/abs_i_auth_repository.dart';
import '../../infrastructure/config/config.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_MIDDLEWARE]
/// ROLE: Authorization Guard for Administrative routes.
/// CONTRACT: Implements [MiddlewareObject] to enforce 'Admin' role requirements.
/// CONSTRAINTS: Must be placed AFTER [AuthMiddleware] in the pipeline.
/// BOOTSTRAP: If 0 admins exist, only the [Config.initialAdminEmail] is permitted.
class AdminMiddleware extends MiddlewareObject {
  final AbsIAuthRepository _authRepo = sl<AbsIAuthRepository>();
  final Config _config = Config();

  @override
  Handler call(Handler next) {
    return (request) async {
      final userId = request.userIdOrNull;

      if (userId == null) {
        return Response.unauthorized(
          body: Body.fromString('Authentication required'),
        );
      }

      final userResult = await _authRepo.findById(userId);
      final user = userResult.getRight().toNullable();
      if (user == null) {
        return Response.unauthorized(
          body: Body.fromString('Authentication required'),
        );
      }

      // 1. Bootstrap lock: zero admins — only the configured initial admin email may access /admin.
      final adminCountResult = await _authRepo.countAdmins();
      final adminCount = adminCountResult.getOrElse((_) => 0);

      if (adminCount == 0) {
        if (user.email.toLowerCase() ==
            _config.initialAdminEmail.toLowerCase()) {
          return await next(request);
        }

        return Response.forbidden(
          body: Body.fromString(
            'Bootstrap Lock: System not configured. Only initial admin is permitted.',
          ),
        );
      }

      // 2. Authorize from DB role so promotions/demotions apply without waiting for JWT expiry.
      if (user.role != UserRole.admin) {
        return Response.forbidden(
          body: Body.fromString('Admin privileges required'),
        );
      }

      return await next(request);
    };
  }
}
