import 'dart:convert';
import 'package:relic/relic.dart';
import '../../application/containers/user_usecases.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for User Directory and Synchronization.
/// CONTRACT: Maps HTTP requests for user retrieval and Phorge syncing to [UserUseCases].
/// CONSTRAINTS: Acts as a thin wrapper for UseCase execution and JSON serialization.
class UserController {
  final UserUseCases _user = sl<UserUseCases>();

  Future<Response> getUsers(Request request) async {
    try {
      final users = await _user.getUsers.execute();
      final jsonList = users.map((u) => u.toMap()).toList();

      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': jsonList,
            'meta': {
              'dataType': 'list:user',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
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

   Future<Response> getUser(Request request) async {
     final id = request.pathParameters.raw[#id];
     if (id == null) return Response.badRequest();

     try {
       final user = await _user.getUserById.execute(id);
       return Response.ok(
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
       );
     } catch (e) {
       return Response.notFound(
         body: Body.fromString(
           jsonEncode({'error': e.toString()}),
           mimeType: MimeType.json,
         ),
       );
     }
   }

   Future<Response> syncUsers(Request request) async {
     try {
       final result = await _user.syncPhorgeUsers.execute();
       final count = result.getOrElse((l) => throw Exception(l.message));
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
     } catch (e) {
       return Response.internalServerError(
         body: Body.fromString(
           jsonEncode({'error': e.toString()}),
           mimeType: MimeType.json,
         ),
       );
     }
   }
 }
