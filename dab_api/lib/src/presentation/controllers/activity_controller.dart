import 'dart:convert';
import 'package:relic/relic.dart';
import '../../application/containers/activity_usecases.dart';
import '../../infrastructure/websockets/presence_service.dart';
import '../../domain/entities/activity/activity_provider.dart';
import '../../infrastructure/database/redis/redis_service.dart';
import '../../service_locator.dart';
import '../middlewares/auth_middleware.dart';

/// [ARCH: PRESENTATION_CONTROLLER]
/// ROLE: Entry point for the Activity Feed API.
/// CONTRACT: Standard Relic Controller mapping HTTP/WebSocket requests to Application UseCases.
/// CONSTRAINTS: Must not contain business logic. Delegates to [ActivityUseCases].
/// 
/// This controller handles historical activity retrieval, complex multi-source 
/// searches, and real-time WebSocket session management.
class ActivityController {
  final ActivityUseCases _activity = sl<ActivityUseCases>();
  final PresenceService _presence = sl<PresenceService>();

  Future<Response> getActivities(Request request) async {
    final userId = userIdProperty.get(request);
    final redis = sl<RedisService>(); // Get RedisService instance
    print('User $userId fetching activities...');
    final activitiesResult = await _activity.getRecentActivities.execute();
    final activities = activitiesResult.getOrElse((_) => []);
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

  Future<Response> searchActivities(Request request) async {
    final callerId = userIdProperty.get(request);

    final startDateStr = request.url.queryParameters['startDate'];
    final endDateStr = request.url.queryParameters['endDate'];
    final usersStr = request.url.queryParameters['users'];
    final authoredOnlyStr = request.url.queryParameters['authoredOnly'];

    if (startDateStr == null || endDateStr == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Missing startDate or endDate parameter'}),
        ),
      );
    }

    DateTime startDate;
    DateTime endDate;
    try {
      // Helper to ensure date strings are interpreted as UTC if no TZ provided
      DateTime parseUtc(String s) {
        if (!s.contains('Z') && !s.contains('+') && !s.contains('-') ||
            (s.length <= 10 && !s.contains('T'))) {
          // If it's YYYY-MM-DD or lacks TZ, force UTC
          return DateTime.parse('${s.contains('T') ? s : '${s}T00:00:00'}Z');
        }
        return DateTime.parse(s).toUtc();
      }

      startDate = parseUtc(startDateStr);
      endDate = parseUtc(endDateStr);

      // If dates are the same, expand endDate to cover the full day
      if (startDate.isAtSameMomentAs(endDate)) {
        startDate = DateTime.utc(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        endDate = startDate.add(const Duration(days: 1));
      } else if (endDate.hour == 0 &&
          endDate.minute == 0 &&
          endDate.second == 0) {
        // If endDate is just a date (at midnight UTC), make it cover that full day
        endDate = endDate.add(const Duration(days: 1));
      }
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error': 'Invalid date format. Use ISO 8601 or YYYY-MM-DD',
          }),
        ),
      );
    }

    final targetUserIds = usersStr != null && usersStr.isNotEmpty
        ? usersStr.split(',')
        : [callerId];

    final authoredOnly = authoredOnlyStr?.toLowerCase() != 'false';

    try {
      final activities = await _activity.searchActivities.execute(
        targetUserIds: targetUserIds,
        startDate: startDate,
        endDate: endDate,
        authoredOnly: authoredOnly,
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
          jsonEncode({'error': 'Failed to search activities: $e'}),
        ),
      );
    }
  }

  WebSocketUpgrade wsHandler(Request request) {
    final userId = userIdProperty.get(request);
    return WebSocketUpgrade((webSocket) async {
      _presence.addSession(webSocket, userId);

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

    await _activity.logActivity.execute(
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
