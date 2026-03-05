import 'dart:convert';

import 'package:relic/relic.dart';

import '../../application/activity_service.dart';
import '../../application/presence_service.dart';
import '../../domain/entities/activity_provider.dart';
import '../../infrastructure/database/redis/redis_service.dart';
import '../../service_locator.dart';
import '../middlewares/auth_middleware.dart';

class ActivityController {
  final ActivityService _activityService = sl<ActivityService>();
  final PresenceService _presence = sl<PresenceService>();

  Future<Response> getActivities(Request request) async {
    final userId = userIdProperty.get(request);
    final redis = sl<RedisService>(); // Get RedisService instance
    print('User $userId fetching activities...');
    final activities = await _activityService.getRecent();
    final syncToken = await redis.getCurrentVersion(); // Fetch syncToken

    final jsonList = activities.map((a) => a.toMap()).toList(); // Use a.toMap()

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': jsonList,
          'meta': {
            'dataType': 'list:activity',
            'syncToken': syncToken.toString(),
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  Future<Response> getPastActivities(Request request) async {
    final userId = userIdProperty.get(request);
    final dateStr = request.url.queryParameters['date'];

    if (dateStr == null) {
      return Response.badRequest(
        body: Body.fromString(jsonEncode({'error': 'Missing date parameter'})),
      );
    }

    DateTime date;
    try {
      date = DateTime.parse(dateStr);
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid date format. Use YYYY-MM-DD'}),
        ),
      );
    }

    try {
      final activities = await _activityService.fetchPastActivities(
        userId,
        date,
      );
      final jsonList = activities.map((a) => a.toMap()).toList();

      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': jsonList,
            'meta': {
              'dataType': 'list:activity',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      );
    } catch (e) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'Failed to fetch past activities: $e'}),
        ),
      );
    }
  }

  WebSocketUpgrade wsHandler(Request request) {
    return WebSocketUpgrade((webSocket) async {
      _presence.addSession(webSocket);

      await for (final _ in webSocket.events) {
        if (webSocket.isClosed) {
          break;
        }
      }

      _presence.removeSession(webSocket);
    });
  }

  Future<Response> createMock(Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    await _activityService.logActivity(
      userId: data['userId'] ?? 'system',
      provider: GenericProvider(
        name: data['provider'] ?? 'Mock',
        category: data['type'] ?? 'generic',
      ),
      title: data['title'] ?? 'New Activity',
      content: data['content'] ?? 'Something happened',
      url: data['url'],
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({'status': 'Activity logged and broadcasted'}),
        mimeType: MimeType.json,
      ),
    );
  }
}
