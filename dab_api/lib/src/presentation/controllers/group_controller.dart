import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/user_service.dart';
import '../../domain/entities/group.dart';
import '../../service_locator.dart';

class GroupController {
  final UserService _userService = sl<UserService>();

  Future<Response> getGroups(Request request) async {
    try {
      final groups = await _userService.getGroups();
      final jsonList = groups.map((g) => g.toMap()).toList();

      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': jsonList,
            'meta': {
              'dataType': 'list:group',
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

  Future<Response> saveGroup(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final group = GroupMapper.fromMap(data);

      final savedGroup = await _userService.saveGroup(group);

      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': savedGroup.toMap(),
            'meta': {
              'dataType': 'group',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
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

  Future<Response> deleteGroup(Request request) async {
    final id = request.pathParameters.raw[#id];
    if (id == null) return Response.badRequest();

    try {
      await _userService.deleteGroup(id);
      return Response.ok();
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
