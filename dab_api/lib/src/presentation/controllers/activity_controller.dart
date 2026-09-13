import 'dart:async';
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:relic/relic.dart';

import '../../application/containers/activity_usecases.dart';
import '../../domain/core/failures/failure.dart';
import '../../domain/core/org_calendar.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_provider.dart';
import '../../domain/contracts/ports/abs_i_webhook_request_authenticator.dart';
import '../../domain/contracts/ports/webhook_auth_input.dart';
import '../../domain/contracts/ports/webhook_auth_status.dart';
import '../../domain/contracts/repositories/abs_i_system_settings_repository.dart';
import '../../infrastructure/core/http/github_webhook_payload.dart';
import '../../infrastructure/persistence/redis/redis_service.dart';
import '../../infrastructure/core/realtime/presence_service.dart';
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
  final AbsIWebhookRequestAuthenticator _webhookAuth =
      sl<AbsIWebhookRequestAuthenticator>();

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
    final includeArchivedParam = request.url.queryParameters['includeArchived']
        ?.toLowerCase();
    final global = scopeParam == 'global';
    final includeArchived =
        includeArchivedParam == 'true' || includeArchivedParam == '1';

    final parsedLimit = int.tryParse(limitParam ?? '');
    if (limitParam != null && parsedLimit == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid limit. Must be an integer.'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final limit = (parsedLimit ?? 50).clamp(1, 250);
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
    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(
        providerId: 'slack',
        body: body,
        signatureHeader: request.headers['X-Slack-Signature']?.first ?? '',
        timestampHeader:
            request.headers['X-Slack-Request-Timestamp']?.first ?? '',
      ),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'Slack signing secret is not configured',
      invalid: 'Invalid Slack signature',
    );
    if (authRejected != null) return authRejected;

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
    final delivery = request.headers['X-GitHub-Delivery']?.first ?? '';
    final eventType = request.headers['X-GitHub-Event']?.first ?? '';

    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(
        providerId: 'github',
        body: body,
        signatureHeader: request.headers['X-Hub-Signature-256']?.first ?? '',
      ),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'GitHub webhook secret is not configured',
      invalid: 'Invalid GitHub webhook signature',
    );
    if (authRejected != null) return authRejected;

    final decoded = body.decodeGitHubWebhookPayload();
    if (decoded == null) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({
            'error': 'Invalid GitHub webhook payload',
            'hint':
                'Use Content type application/json in GitHub, or form '
                'payload= (application/x-www-form-urlencoded). Body must match '
                'the format used when the webhook secret was generated.',
          }),
          mimeType: MimeType.json,
        ),
      );
    }

    print(
      '[GITHUB_WEBHOOK] webhook_received event=${eventType.trim()} delivery=${delivery.trim()}',
    );

    unawaited(
      _activity.ingestGitHubWebhook
          .execute(payload: decoded, deliveryId: delivery, event: eventType)
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

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /integrations/phorge/webhook — verifies the Herald
  /// `X-Phabricator-Webhook-Signature` HMAC and ingests task transactions.
  Future<Response> receivePhorgeWebhook(Request request) async {
    final body = await request.readAsString();

    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(
        providerId: 'phorge',
        body: body,
        signatureHeader:
            request.headers['X-Phabricator-Webhook-Signature']?.first ?? '',
      ),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'Phorge webhook HMAC key is not configured',
      invalid: 'Invalid Phorge webhook signature',
    );
    if (authRejected != null) return authRejected;

    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Phorge webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }
    if (decoded is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Phorge webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    print(
      '[PHORGE_WEBHOOK] webhook_received object=${decoded['object']?['phid']}',
    );

    unawaited(
      _activity.ingestPhorgeWebhook.execute(payload: decoded).then((result) {
        result.fold((failure) {
          print('Phorge live ingestion failed: ${failure.message}');
        }, (_) {});
      }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'phorge_webhook_ack',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /integrations/bitbucket/webhook — verifies the Bitbucket
  /// `X-Hub-Signature` header (`sha256=` HMAC of the raw body — same scheme
  /// as GitHub, so the GitHub verifier is reused) and ingests `repo:push`
  /// events.
  Future<Response> receiveBitbucketWebhook(Request request) async {
    final body = await request.readAsString();
    final deliveryId =
        request.headers['X-Request-UUID']?.first ??
        request.headers['X-Hook-UUID']?.first;
    final eventKey = request.headers['X-Event-Key']?.first ?? '';

    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(
        providerId: 'bitbucket',
        body: body,
        signatureHeader: request.headers['X-Hub-Signature']?.first ?? '',
      ),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'Bitbucket webhook secret is not configured',
      invalid: 'Invalid Bitbucket webhook signature',
    );
    if (authRejected != null) return authRejected;

    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Bitbucket webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }
    if (decoded is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Bitbucket webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    print('[BITBUCKET_WEBHOOK] webhook_received event=$eventKey');

    unawaited(
      _activity.ingestBitbucketWebhook
          .execute(payload: decoded, deliveryId: deliveryId)
          .then((result) {
            result.fold((failure) {
              print('Bitbucket live ingestion failed: ${failure.message}');
            }, (_) {});
          }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'bitbucket_webhook_ack',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /integrations/gitlab/webhook — GitLab webhooks carry a plain shared
  /// token (`X-Gitlab-Token` header, no HMAC), compared constant-time against
  /// the provider's `webhookSecret` setting.
  Future<Response> receiveGitLabWebhook(Request request) async {
    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(
        providerId: 'gitlab',
        sharedSecretHeader: request.headers['X-Gitlab-Token']?.first ?? '',
      ),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'GitLab webhook secret is not configured',
      invalid: 'Invalid GitLab webhook token',
    );
    if (authRejected != null) return authRejected;

    final body = await request.readAsString();
    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid GitLab webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }
    if (decoded is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid GitLab webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    print(
      '[GITLAB_WEBHOOK] webhook_received kind=${decoded['object_kind']} ref=${decoded['ref']}',
    );

    unawaited(
      _activity.ingestGitLabWebhook.execute(payload: decoded).then((result) {
        result.fold((failure) {
          print('GitLab live ingestion failed: ${failure.message}');
        }, (_) {});
      }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'gitlab_webhook_ack',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /integrations/linear/webhook — verifies the `linear-signature`
  /// HMAC against the provider's `webhookSecret` and ingests Issue and
  /// Comment events.
  Future<Response> receiveLinearWebhook(Request request) async {
    final body = await request.readAsString();
    final deliveryId = request.headers['linear-delivery']?.first;

    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(
        providerId: 'linear',
        body: body,
        signatureHeader: request.headers['linear-signature']?.first ?? '',
      ),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'Linear webhook secret is not configured',
      invalid: 'Invalid Linear webhook signature',
    );
    if (authRejected != null) return authRejected;

    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Linear webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }
    if (decoded is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Linear webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    print(
      '[LINEAR_WEBHOOK] webhook_received type=${decoded['type']} action=${decoded['action']}',
    );

    unawaited(
      _activity.ingestLinearWebhook
          .execute(payload: decoded, deliveryId: deliveryId)
          .then((result) {
            result.fold((failure) {
              print('Linear live ingestion failed: ${failure.message}');
            }, (_) {});
          }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'linear_webhook_ack',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  /// [ARCH: PRESENTATION_ROUTE]
  /// POST /integrations/jira/webhook — verifies Jira Cloud admin webhook
  /// `X-Hub-Signature` (`sha256=` HMAC of the raw body, per Atlassian docs).
  /// Falls back to plain `X-Webhook-Secret` / `?secret=` for Bruno simulations.
  Future<Response> receiveJiraWebhook(Request request) async {
    final body = await request.readAsString();

    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(
        providerId: 'jira',
        body: body,
        signatureHeader: request.headers['X-Hub-Signature']?.first ?? '',
        sharedSecretHeader: request.headers['X-Webhook-Secret']?.first ?? '',
        sharedSecretQuery: request.url.queryParameters['secret'] ?? '',
      ),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'Jira webhook secret is not configured',
      invalid: 'Invalid Jira webhook signature or secret',
    );
    if (authRejected != null) return authRejected;

    final dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Jira webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }
    if (decoded is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Jira webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    print(
      '[JIRA_WEBHOOK] webhook_received event=${decoded['webhookEvent']} issue=${decoded['issue']?['key']}',
    );

    unawaited(
      _activity.ingestJiraWebhook.execute(payload: decoded).then((result) {
        result.fold((failure) {
          print('Jira live ingestion failed: ${failure.message}');
        }, (_) {});
      }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'jira_webhook_ack',
            'timestamp': DateTime.now().toIso8601String(),
          },
        }),
        mimeType: MimeType.json,
      ),
    );
  }

  Future<Response> receiveFigmaWebhook(Request request) async {
    final body = await request.readAsString();

    dynamic decoded;
    try {
      decoded = jsonDecode(body);
    } catch (_) {
      decoded = null;
    }
    final passcode = decoded is Map
        ? (decoded['passcode'] ?? '').toString()
        : '';

    final auth = await _webhookAuth.authenticate(
      WebhookAuthInput(providerId: 'figma', body: body, jsonPasscode: passcode),
    );
    final authRejected = _webhookAuthResponse(
      auth,
      missingSecret: 'Figma webhook passcode is not configured',
      invalid: 'Invalid Figma webhook passcode',
    );
    if (authRejected != null) return authRejected;

    if (decoded is! Map<String, dynamic>) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Figma webhook payload'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final event = (decoded['event_type'] ?? decoded['eventType'] ?? '')
        .toString();
    print(
      '[FIGMA_WEBHOOK] webhook_received event=$event file=${decoded['file_key']}',
    );

    if (event.toString().trim().toUpperCase() == 'PING') {
      return Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': {'accepted': true},
            'meta': {
              'dataType': 'figma_webhook_ack',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      );
    }

    unawaited(
      _activity.ingestFigmaWebhook.execute(payload: decoded).then((result) {
        result.fold((failure) {
          print('Figma live ingestion failed: ${failure.message}');
        }, (_) {});
      }),
    );

    return Response.ok(
      body: Body.fromString(
        jsonEncode({
          'data': {'accepted': true},
          'meta': {
            'dataType': 'figma_webhook_ack',
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
    final providersStr = request.url.queryParameters['providers'];

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
      final orgTimezoneId = await loadOrgTimezoneId(
        sl<AbsISystemSettingsRepository>(),
      );
      final range = parseOrgDateQueryRange(
        orgTimezoneId: orgTimezoneId,
        startDate: startDateStr,
        endDate: endDateStr,
      );
      startDate = range.startUtc;
      endDate = range.endUtc;
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

    final providerIds = _parseProviderIds(providersStr);

    try {
      final activities = await _activity.searchActivities.execute(
        targetUserIds: targetUserIds,
        startDate: startDate,
        endDate: endDate,
        authoredOnly: authoredOnly,
        providerIds: providerIds,
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

  Future<Response> seedDemoDay(Request request) async {
    final callerId = userIdProperty.get(request);
    Map<String, dynamic> data = {};
    try {
      final body = await request.readAsString();
      if (body.trim().isNotEmpty) {
        final decoded = jsonDecode(body);
        if (decoded is! Map) {
          return Response.badRequest(
            body: Body.fromString(
              jsonEncode({'error': 'Body must be a JSON object'}),
              mimeType: MimeType.json,
            ),
          );
        }
        data = Map<String, dynamic>.from(decoded);
      }
    } catch (_) {
      return Response.badRequest(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid JSON body'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final rawUserId = data['userId']?.toString().trim() ?? '';
    final team =
        data['team'] == true ||
        data['team']?.toString().toLowerCase() == 'true';
    final teamSizeRaw = data['teamSize'];
    final teamSize = teamSizeRaw is num
        ? teamSizeRaw.toInt()
        : int.tryParse(teamSizeRaw?.toString() ?? '') ?? 20;
    final userIds = <String>[];
    final rawUserIds = data['userIds'];
    if (rawUserIds is List) {
      for (final entry in rawUserIds) {
        final id = entry.toString().trim();
        if (id.isNotEmpty) userIds.add(id);
      }
    }
    final result = await _activity.seedDemoDay.execute(
      userId: rawUserId.isNotEmpty ? rawUserId : callerId,
      date: data['date']?.toString() ?? '',
      team: team,
      teamSize: teamSize,
      userIds: userIds,
    );
    return result.fold(
      (failure) {
        final message = failure.message;
        if (failure is ValidationFailure) {
          return Response.badRequest(
            body: Body.fromString(
              jsonEncode({'error': message}),
              mimeType: MimeType.json,
            ),
          );
        }
        if (failure is AuthFailure) {
          return Response.forbidden(
            body: Body.fromString(
              jsonEncode({'error': message}),
              mimeType: MimeType.json,
            ),
          );
        }
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
      (seeded) => Response.ok(
        body: Body.fromString(
          jsonEncode({
            'data': seeded.toMap(),
            'meta': {
              'dataType': 'object:demo_day',
              'timestamp': DateTime.now().toIso8601String(),
            },
          }),
          mimeType: MimeType.json,
        ),
      ),
    );
  }

  Response? _webhookAuthResponse(
    WebhookAuthStatus status, {
    required String missingSecret,
    required String invalid,
  }) {
    switch (status) {
      case WebhookAuthStatus.ok:
        return null;
      case WebhookAuthStatus.missingSecret:
        return Response.internalServerError(
          body: Body.fromString(
            jsonEncode({'error': missingSecret}),
            mimeType: MimeType.json,
          ),
        );
      case WebhookAuthStatus.invalid:
        return Response.unauthorized(
          body: Body.fromString(
            jsonEncode({'error': invalid}),
            mimeType: MimeType.json,
          ),
        );
    }
  }

  /// Comma-separated provider config ids. Empty or omitted means every active
  /// connector.
  Set<String>? _parseProviderIds(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final ids = raw
        .split(',')
        .map((value) => value.trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    return ids.isEmpty ? null : ids;
  }
}
