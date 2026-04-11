import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/containers/auth_usecases.dart';
import '../../domain/entities/user/user_identity_status.dart';
import '../../domain/entities/user/user_role.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for Admin Console privileged operations.
/// CONTRACT: Maps identity resolution and platform configuration requests to UseCases.
/// CONSTRAINTS: Protected by AdminMiddleware.
class AdminController {
  final AuthUseCases _auth = sl<AuthUseCases>();

  Future<Response> getIdentitiesSummary(Request request) async {
    try {
      final result = await _auth.countUnresolvedIdentities.execute();

      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (count) => Response.ok(
          body: Body.fromString(
            jsonEncode({
              'data': {'unresolvedCount': count},
              'meta': {
                'dataType': 'identity_resolution_summary',
                'timestamp': DateTime.now().toIso8601String(),
              },
            }),
            mimeType: MimeType.json,
          ),
        ),
      );
    } catch (e) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': e.toString()}),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> getIdentities(Request request) async {
    try {
      final result = await _auth.getAllIdentities.execute();

      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (identities) => Response.ok(
          body: Body.fromString(
            jsonEncode({
              'data': identities.map((i) => i.toMap()).toList(),
              'meta': {
                'dataType': 'list:user_identity',
                'timestamp': DateTime.now().toIso8601String(),
              },
            }),
            mimeType: MimeType.json,
          ),
        ),
      );
    } catch (e) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': e.toString()}),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> linkIdentity(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final data = jsonDecode(bodyStr) as Map<String, dynamic>;

      final userId = data['userId'] as String?;
      final providerId = data['providerId'] as String?;
      final externalId = data['externalId'] as String?;

      if (userId == null || providerId == null || externalId == null) {
        return Response.badRequest(
          body: Body.fromString(
            jsonEncode({
              'error': 'userId, providerId, and externalId are required',
            }),
            mimeType: MimeType.json,
          ),
        );
      }

      final result = await _auth.linkUserIdentity.execute(
        userId: userId,
        providerId: providerId,
        externalId: externalId,
      );

      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (identity) => Response.ok(
          body: Body.fromString(
            jsonEncode({'data': identity.toMap()}),
            mimeType: MimeType.json,
          ),
        ),
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': e.toString()}),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> resolveIdentity(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final data = jsonDecode(bodyStr) as Map<String, dynamic>;

      final userId = data['userId'] as String?;
      final providerId = data['providerId'] as String?;
      final statusStr = data['status'] as String?;

      if (userId == null || providerId == null || statusStr == null) {
        return Response.badRequest(
          body: Body.fromString(
            jsonEncode({
              'error': 'userId, providerId, and status are required',
            }),
            mimeType: MimeType.json,
          ),
        );
      }

      final status = UserIdentityStatus.values.firstWhere(
        (s) => s.name.toLowerCase() == statusStr.toLowerCase(),
        orElse: () => UserIdentityStatus.pending,
      );

      final result = await _auth.resolveUserIdentity.execute(
        userId: userId,
        providerId: providerId,
        status: status,
      );

      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (identity) => Response.ok(
          body: Body.fromString(
            jsonEncode({'data': identity.toMap()}),
            mimeType: MimeType.json,
          ),
        ),
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': e.toString()}),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> getUsers(Request request) async {
    try {
      final result = await _auth.findAllUsers.execute();

      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (users) => Response.ok(
          body: Body.fromString(
            jsonEncode({
              'data': users.map((u) => u.toMap()).toList(),
              'meta': {
                'dataType': 'list:user',
                'timestamp': DateTime.now().toIso8601String(),
              },
            }),
            mimeType: MimeType.json,
          ),
        ),
      );
    } catch (e) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': e.toString()}),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> postUpdateUserRole(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final data = jsonDecode(bodyStr) as Map<String, dynamic>;

      final userId = data['userId'] as String?;
      final role = data['role'] as String?;

      if (userId == null || role == null) {
        return Response.badRequest(
          body: Body.fromString(
            jsonEncode({'error': 'userId and role are required'}),
            mimeType: MimeType.json,
          ),
        );
      }

      final userRole = UserRole.values.firstWhere(
        (e) => e.name.toLowerCase() == role.toLowerCase(),
        orElse: () => UserRole.standard,
      );

      final result = await _auth.updateUserRole.execute(userId, userRole);

      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (_) => Response.ok(
          body: Body.fromString(
            jsonEncode({'data': 'User role updated successfully'}),
            mimeType: MimeType.json,
          ),
        ),
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': e.toString()}),
          mimeType: MimeType.json,
        ),
      );
    }
  }
}
