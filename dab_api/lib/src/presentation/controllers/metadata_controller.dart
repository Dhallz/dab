import 'dart:convert';
import 'package:relic/relic.dart';
import '../../application/containers/metadata_usecases.dart';
import '../../service_locator.dart';
import '../middlewares/auth_middleware.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for Platform Metadata and Configuration.
/// CONTRACT: Maps HTTP requests for provider settings and dynamic metadata to [MetadataUseCases].
/// CONSTRAINTS: Purely for data delivery. Handles user context resolution from [userIdProperty].
class MetadataController {
  final MetadataUseCases _metadata = sl<MetadataUseCases>();

  Future<Response> getProviders(Request request) async {
    final userId = userIdProperty.get(request);
    print('User $userId fetching metadata...');

    try {
      final metadata = await _metadata.getProviderMetadata.execute(userId);
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

  Future<Response> getConfigs(Request request) async {
    try {
      final configs = await _metadata.getProviderConfigs.execute();
      final jsonList = configs.map((c) => c.toMap()).toList();

      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': jsonList,
            'meta': {
              'dataType': 'list:provider_config',
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
            'error': 'Failed to fetch provider configurations',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }
}
