import 'dart:convert';
import 'package:relic/relic.dart';
import '../../application/services/activity_purge_scheduler.dart';
import '../../domain/core/deployment_mode.dart';
import '../../domain/entities/provider/provider_config.dart';
import '../../application/containers/metadata_usecases.dart';
import '../../domain/contracts/repositories/abs_i_system_settings_repository.dart';
import '../../infrastructure/sources/discord/discord_gateway_client.dart';
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
    final result = await _metadata.getProviderMetadata.execute(userId);
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({
            'error': 'Failed to fetch metadata',
            'details': failure.message,
          }),
          mimeType: MimeType.json,
        ),
      ),
      (metadata) {
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
      },
    );
  }

  Future<Response> getCapabilities(Request request) async {
    try {
      final capabilities = await _metadata.getProviderCapabilities.execute();
      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': capabilities,
            'meta': {
              'dataType': 'list:provider_capability',
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
            'error': 'Failed to fetch provider capabilities',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> getConfigs(Request request) async {
    final result = await _metadata.getProviderConfigs.execute();
    if (result.isLeft()) {
      final failure = result.getLeft().toNullable()!;
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({
            'error': 'Failed to fetch provider configurations',
            'details': failure.message,
          }),
          mimeType: MimeType.json,
        ),
      );
    }
    final configs = result.getRight().toNullable()!;
    final jsonList = configs.map((c) => c.toMap()).toList();
    final statusResult = await _metadata.getSystemStatus.execute();
    final isSystemConfigured = statusResult.getOrElse((_) => false);

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': jsonList,
          'meta': {
            'dataType': 'list:provider_config',
            'isSystemConfigured': isSystemConfigured,
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  Future<Response> getStatus(Request request) async {
    try {
      final statusResult = await _metadata.getSystemStatus.execute();
      final isSystemConfigured = statusResult.getOrElse((_) => false);
      final systemTimezone = await loadOrgTimezoneId(
        sl<AbsISystemSettingsRepository>(),
      );
      final modeResult = await sl<AbsISystemSettingsRepository>().getSetting(
        kDeploymentModeSettingKey,
      );
      final deploymentMode = normalizeDeploymentMode(
        modeResult.getOrElse((_) => null),
      );

      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': {
              'isSystemConfigured': isSystemConfigured,
              'systemTimezone': systemTimezone,
              'deploymentMode': deploymentMode,
            },
            'meta': {
              'dataType': 'system_status',
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
            'error': 'Failed to fetch system status',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> saveConfig(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final data = jsonDecode(bodyStr) as Map<String, dynamic>;

      // Use the class fromMap method generated by dart_mappable
      final config = ProviderConfigMapper.fromMap(data);

      final result = await _metadata.saveProviderConfig.execute(config);

      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (savedConfig) {
          if (savedConfig.id == 'discord') {
            sl<DiscordGatewayClient>().reload().catchError((e) {
              print('Error reloading DiscordGatewayClient: $e');
            });
          }
          return Response.ok(
            body: Body.fromString(
              jsonEncode({'data': savedConfig.toMap()}),
              mimeType: MimeType.json,
            ),
          );
        },
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error': 'Invalid request body',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> testConfig(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final data = jsonDecode(bodyStr) as Map<String, dynamic>;
      final config = ProviderConfigMapper.fromMap(data);

      final result = await _metadata.testProviderConfig.execute(config);
      return result.fold(
        (failure) => Response.badRequest(
          body: Body.fromString(
            jsonEncode({
              'error': 'Connection failed',
              'details': failure.message,
            }),
            mimeType: MimeType.json,
          ),
        ),
        (report) => Response.ok(
          body: Body.fromString(
            jsonEncode({
              'data': {
                'aggregate': report.aggregate.name,
                'summaryMessage': report.summaryMessage,
                'sections': {
                  'core': {
                    'status': report.core.status.name,
                    'message': report.core.message,
                  },
                  'live': {
                    'status': report.live.status.name,
                    'message': report.live.message,
                  },
                  'polling': {
                    'status': report.polling.status.name,
                    'message': report.polling.message,
                  },
                },
              },
            }),
            mimeType: MimeType.json,
          ),
        ),
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error': 'Invalid request body',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }

  Future<Response> getSystemSettings(Request request) async {
    final result = await _metadata.getSystemSettings.execute();
    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({
            'error': 'Failed to fetch system settings',
            'details': failure.message,
          }),
          mimeType: MimeType.json,
        ),
      ),
      (settings) => Response.ok(
        body: Body.fromString(
          jsonEncode({'data': settings}),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> saveSystemSettings(Request request) async {
    try {
      final bodyStr = await request.readAsString();
      final data = jsonDecode(bodyStr) as Map<String, dynamic>;
      final settings = data.map(
        (key, value) => MapEntry(key, value.toString()),
      );

      final result = await _metadata.saveSystemSettings.execute(settings);
      return result.fold(
        (failure) => Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': failure.message}),
            mimeType: MimeType.json,
          ),
        ),
        (_) {
          sl<ActivityPurgeScheduler>().reschedule();
          return Response.ok(
            body: Body.fromString(
              jsonEncode({'success': true}),
              mimeType: MimeType.json,
            ),
          );
        },
      );
    } catch (e) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error': 'Invalid request body',
            'details': e.toString(),
          }),
          mimeType: MimeType.json,
        ),
      );
    }
  }
}
