import 'dart:async';
import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/containers/user_usecases.dart';
import '../../application/services/identity_discovery_service.dart';
import '../../domain/core/failures/failure.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for User Directory and Synchronization.
/// CONTRACT: Maps HTTP requests for user retrieval and Phorge syncing to [UserUseCases].
/// CONSTRAINTS: Acts as a thin wrapper for UseCase execution and JSON serialization.
class UserController {
  final UserUseCases _user = sl<UserUseCases>();

  Future<Response> getUsers(Request request) async {
    final result = await _user.getUsers.execute();
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
  }

  Future<Response> getUser(Request request) async {
    final id = request.pathParameters.raw[#id];
    if (id == null) return Response.badRequest();

    final result = await _user.getUserById.execute(id);
    return result.fold(
      (failure) {
        if (failure is NotFoundFailure) {
          return Response.notFound(
            body: Body.fromString(
              jsonEncode({'error': failure.message}),
              mimeType: MimeType.json,
            ),
          );
        }
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      },
      (user) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': user.toMap(),
            'meta': {
              'dataType': 'user',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> syncUsers(Request request) async {
    final result = await _user.syncPhorgeUsers.execute();
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      if (failure is NotFoundFailure) {
        return Response.notFound(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        );
      }
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      );
    }
    final count = result.getRight().toNullable()!;
    unawaited(sl<IdentityDiscoveryService>().runFullDiscovery());

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'createdCount': count},
          'meta': {
            'dataType': 'sync_result',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }
}
