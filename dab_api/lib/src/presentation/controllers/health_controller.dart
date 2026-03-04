import 'dart:convert';

import 'package:relic/relic.dart';

import '../../infrastructure/database/postgres_client.dart';
import '../../service_locator.dart';

class HealthController {
  final PostgresClient _pg = sl<PostgresClient>();

  Future<Response> check(Request request) async {
    bool dbHealthy = false;
    try {
      final pool = _pg.pool;
      await pool.execute('SELECT 1');
      dbHealthy = true;
    } catch (e) {
      dbHealthy = false;
    }

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
