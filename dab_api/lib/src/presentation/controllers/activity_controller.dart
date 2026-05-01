import 'dart:async';
import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:relic/relic.dart';
import '../../application/containers/activity_usecases.dart';
import '../../domain/core/failure.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../infrastructure/websockets/presence_service.dart';
import '../../domain/entities/activity/activity_provider.dart';
import '../../infrastructure/database/redis/redis_service.dart';
import '../../infrastructure/security/github_webhook_verifier.dart';
import '../../infrastructure/security/slack_request_verifier.dart';
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

  Future<Response> getLiveActivities(Request request) async {
    final userId = userIdProperty.get(request);
    final redis = sl<RedisService>();

    final limitParam = request.url.queryParameters['limit'];
    final scopeParam = request.url.queryParameters['scope']?.toLowerCase();
    final includeArchivedParam = request
        .url
        .queryParameters['includeArchived']
        ?.toLowerCase();
    final global = scopeParam == 'global';
    final includeArchived = includeArchivedParam == 'true' ||
        includeArchivedParam == '1';

    final parsedLimit = int.tryParse(limitParam ?? '');
    if (limitParam != null && parsedLimit == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid limit. Must be an integer.'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final limit = (parsedLimit ?? 50).clamp(1, 100);
    final result = await _activity.getLiveActivities.execute(
      userId: userId,
      limit: limit,
      global: global,
      includeArchived: includeArchived,
    );
    final syncToken = await redis.getCurrentVersion();

    return result.fold(
      (failure) => Response.internalServerError(
        body: Body.fromString(
          jsonEncode({
            'error': 'Failed to fetch live activities',
            'details': failure.message,
          }),
          mimeType: MimeType.json,
        ),
      ),
      (activities) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': activities.map((activity) => activity.toMap()).toList(),
            'meta': {
              'dataType': 'list:activity_live',
              'source': 'redis',
              'scope': global ? 'global' : 'user',
              'limit': limit,
              'includeArchived': includeArchived,
              'syncToken': syncToken.toString(),
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /activities/live/:id/archive — flips the caller's live-feed entry
  /// for [id] to `archived=true`. Returns 404 when the entry is not present in
  /// the caller's Redis live feed (already purged or never fanned out).
  Future<Response> archiveLiveActivity(Request request) async {
    final userId = userIdProperty.get(request);
    final activityId = request.pathParameters.raw[#id]?.toString();
    if (activityId == null || activityId.isEmpty) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Missing activity id'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final result = await _activity.archiveLiveActivity.execute(
      userId: userId,
      activityId: activityId,
    );
    return _respondWithTriageResult(result);
  }

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /activities/live/:id/unarchive — flips the caller's live-feed entry
  /// for [id] back to `archived=false`.
  Future<Response> unarchiveLiveActivity(Request request) async {
    final userId = userIdProperty.get(request);
    final activityId = request.pathParameters.raw[#id]?.toString();
    if (activityId == null || activityId.isEmpty) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Missing activity id'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final result = await _activity.unarchiveLiveActivity.execute(
      userId: userId,
      activityId: activityId,
    );
    return _respondWithTriageResult(result);
  }

  Response _respondWithTriageResult(Either<Failure, Activity> result) {
    return result.fold(
      (failure) {
        final message = failure.message;
        if (failure is NotFoundFailure) {
          return Response.notFound(
            body: Body.fromString(
              jsonEncode({'error': message}),
              mimeType: MimeType.json,
            ),
          );
        }
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': message}),
            mimeType: MimeType.json,
          ),
        );
      },
      (activity) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': activity.toMap(),
            'meta': {
              'dataType': 'object:activity',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Future<Response> receiveSlackEvents(Request request) async {
    final body = await request.readAsString();
    final signature = request.headers['X-Slack-Signature']?.first ?? '';
    final timestamp = request.headers['X-Slack-Request-Timestamp']?.first ?? '';
    final signingSecret = await _resolveSlackSigningSecret();

    if (signingSecret.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'Slack signing secret is not configured'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final verifier = sl<SlackRequestVerifier>();
    final valid = verifier.isValid(
      body: body,
      signatureHeader: signature,
      timestampHeader: timestamp,
      signingSecret: signingSecret,
    );
    if (!valid) {
      return Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Slack signature'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final payload = jsonDecode(body);
    if (payload is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Slack event payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    if (payload['type']?.toString() == 'url_verification') {
      print(
        '[SLACK_PIPELINE] webhook_received type=url_verification challenge=${payload['challenge']}',
      );
      return Response.ok(
        body: Body.fromString(
          jsonEncode({'challenge': payload['challenge']}),
          mimeType: MimeType.json,
        ),
      );
    }

    final eventId = payload['event_id']?.toString() ?? 'unknown';
    final eventType = payload['event'] is Map<String, dynamic>
        ? (payload['event']['type']?.toString() ?? 'unknown')
        : 'unknown';
    print(
      '[SLACK_PIPELINE] webhook_received type=event_callback event_id=$eventId event_type=$eventType',
    );

    // Slack requires an acknowledgement within ~3 seconds. We respond now and
    // process the event asynchronously through the ingestion use case.
    unawaited(
      _activity.ingestSlackEvent.execute(payload).then((result) {
        result.fold((failure) {
          print('Slack live ingestion failed: ${failure.message}');
        }, (_) {});
      }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'slack_event_ack',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /integrations/github/webhook — verifies `X-Hub-Signature-256` and ingests push events.
  Future<Response> receiveGitHubWebhook(Request request) async {
    final body = await request.readAsString();
    final signature = request.headers['X-Hub-Signature-256']?.first ?? '';
    final delivery = request.headers['X-GitHub-Delivery']?.first ?? '';
    final eventType = request.headers['X-GitHub-Event']?.first ?? '';

    final webhookSecret = await _resolveGitHubWebhookSecret();
    if (webhookSecret.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'GitHub webhook secret is not configured'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final verifier = sl<GitHubWebhookVerifier>();
    final valid = verifier.isValidSha256Signature(
      body: body,
      signature256Header: signature,
      webhookSecret: webhookSecret,
    );
    if (!valid) {
      return Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid GitHub webhook signature'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid GitHub webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    print(
      '[GITHUB_WEBHOOK] webhook_received event=${eventType.trim()} delivery=${delivery.trim()}',
    );

    unawaited(
      _activity.ingestGitHubWebhook
          .execute(
            payload: decoded,
            deliveryId: delivery,
            event: eventType,
          )
          .then((result) {
            result.fold((failure) {
              print('GitHub live ingestion failed: ${failure.message}');
            }, (_) {});
          }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'github_webhook_ack',
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

  Future<String> _resolveSlackSigningSecret() async {
    final repo = sl<AbsIProviderConfigRepository>();
    final result = await repo.getConfigs();
    final slackConfig = result
        .getOrElse((_) => const [])
        .where(
          (config) => config.id.toLowerCase() == 'slack' && config.isActive,
        )
        .firstOrNull;
    if (slackConfig == null) {
      return '';
    }
    return (slackConfig.settings['signingSecret'] ?? '').toString().trim();
  }

  Future<String> _resolveGitHubWebhookSecret() async {
    final repo = sl<AbsIProviderConfigRepository>();
    final result = await repo.getConfigs();
    final githubConfig = result
        .getOrElse((_) => const [])
        .where(
          (config) => config.id.toLowerCase() == 'github' && config.isActive,
        )
        .firstOrNull;
    if (githubConfig == null) {
      return '';
    }
    final settings = githubConfig.settings;
    return (settings['webhookSecret'] ?? settings['webhook_secret'] ?? '')
        .toString()
        .trim();
  }
}
