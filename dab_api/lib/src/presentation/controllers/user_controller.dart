import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/user_service.dart';
import '../../service_locator.dart';

class UserController {
  final UserService _userService = sl<UserService>();

  Future<Response> getUsers(Request request) async {
    try {
      final users = await _userService.getUsers();
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
       final user = await _userService.getUser(id);
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
       final count = await _userService.syncPhorgeUsers();
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
