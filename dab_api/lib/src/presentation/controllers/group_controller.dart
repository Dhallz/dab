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
    final result = await _group.getGroups.execute();
    return await result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (groups) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': groups.map((g) => g.toMap()).toList(),
            'meta': {
              'dataType': 'list:group',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> saveGroup(Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final group = GroupMapper.fromMap(data);

      final result = await _group.saveGroup.execute(group);

      return await result.fold(
        (failure) => Response.badRequest(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (savedGroup) => Response.ok(
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

    final result = await _group.deleteGroup.execute(id);
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': failure.message}),
          mimeType: MimeType.json,
        ),
      ),
      (_) => Response.ok(),
    );
  }
}
