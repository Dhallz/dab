import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/containers/group_usecases.dart';
import '../../domain/entities/group/group.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for Group and Organizational Unit management.
/// CONTRACT: Maps HTTP requests for group CRUD operations to [GroupUseCases].
/// CONSTRAINTS: Handles entity mapping (via GroupMapper) and HTTP response status coordination.
class GroupController {
  final GroupUseCases _group = sl<GroupUseCases>();

  Future<Response> getGroups(Request request) async {
    try {
      final groups = await _group.getGroups.execute();
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

      final savedGroup = await _group.saveGroup.execute(group);

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
      await _group.deleteGroup.execute(id);
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
