import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/metadata_service.dart';
import '../../service_locator.dart';
import '../middlewares/auth_middleware.dart';

class MetadataController {
  final MetadataService _service = sl<MetadataService>();

  Future<Response> getProviders(Request request) async {
    final userId = userIdProperty.get(request);
    print('User \$userId fetching metadata...');

    try {
      final metadata = await _service.getMetadata(userId);
      final jsonList = metadata.map((m) => m.toMap()).toList();

      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': jsonList,
            'meta': {
              'dataType': 'list:provider_metadata',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      );
    } catch (e) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({
            'error': 'Failed to fetch metadata',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }
}
