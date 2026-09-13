import 'dart:convert';
import 'package:relic/relic.dart';
import '../../application/containers/health_usecases.dart';
import '../../service_locator.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Controller for System Health and Monitoring.
/// CONTRACT: Standard Relic Controller providing status and database connectivity info.
/// CONSTRAINTS: Purely for system vitals. Uses [HealthUseCases] to verify DB connectivity.
class HealthController {
  final HealthUseCases _health = sl<HealthUseCases>();

  Future<Response> check(Request request) async {
    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'status': 'healthy',
          'timestamp': DateTime.now().toIso8601String(),
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  Future<Response> checkDb(Request request) async {
    final result = await _health.checkDatabaseHealth.execute();
    final dbHealthy = result.isRight();

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'status': dbHealthy ? 'healthy' : 'degraded',
          'database': dbHealthy ? 'connected' : 'disconnected',
          'timestamp': DateTime.now().toIso8601String(),
        }),
        mimeType: MimeType.json,
      ),
    );
  }
}
