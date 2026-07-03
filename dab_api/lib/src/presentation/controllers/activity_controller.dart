import 'dart:async';
import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:relic/relic.dart';

import '../../application/containers/activity_usecases.dart';
import '../../domain/core/failures/failure.dart';
import '../../domain/core/org_calendar.dart';
import '../../domain/entities/activity/activity.dart';
import '../../domain/entities/activity/activity_provider.dart';
import '../../domain/repositories/abs_i_provider_config_repository.dart';
import '../../domain/repositories/abs_i_system_settings_repository.dart';
import '../../infrastructure/core/http/github_webhook_payload.dart';
import '../../infrastructure/core/security/github_webhook_verifier.dart';
import '../../infrastructure/core/security/linear_webhook_verifier.dart';
import '../../infrastructure/core/security/phorge_webhook_verifier.dart';
import '../../infrastructure/core/security/shared_secret_verifier.dart';
import '../../infrastructure/core/security/slack_request_verifier.dart';
import '../../infrastructure/database/redis/redis_service.dart';
import '../../infrastructure/websockets/presence_service.dart';
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

    final decoded = decodeGitHubWebhookPayload(body);
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
    final signature =
        request.headers['X-Phabricator-Webhook-Signature']?.first ?? '';

    final hmacKey = await _resolveProviderSetting('phorge', const [
      'webhookHmacKey',
      'webhook_hmac_key',
    ]);
    if (hmacKey.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'Phorge webhook HMAC key is not configured'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final verifier = sl<PhorgeWebhookVerifier>();
    final valid = verifier.isValidSignature(
      body: body,
      signatureHeader: signature,
      hmacKey: hmacKey,
    );
    if (!valid) {
      return Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Phorge webhook signature'}),
          mimeType: MimeType.json,
        ),
      );
    }

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
    final signature = request.headers['X-Hub-Signature']?.first ?? '';
    final deliveryId =
        request.headers['X-Request-UUID']?.first ??
        request.headers['X-Hook-UUID']?.first;
    final eventKey = request.headers['X-Event-Key']?.first ?? '';

    final webhookSecret = await _resolveProviderSetting('bitbucket', const [
      'webhookSecret',
      'webhook_secret',
    ]);
    if (webhookSecret.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'Bitbucket webhook secret is not configured'}),
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
          jsonEncode({'error': 'Invalid Bitbucket webhook signature'}),
          mimeType: MimeType.json,
        ),
      );
    }

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
    final provided = request.headers['X-Gitlab-Token']?.first ?? '';

    final expected = await _resolveProviderSetting('gitlab', const [
      'webhookSecret',
      'webhook_secret',
    ]);
    if (expected.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'GitLab webhook secret is not configured'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final verifier = sl<SharedSecretVerifier>();
    if (!verifier.isValid(provided: provided, expected: expected)) {
      return Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid GitLab webhook token'}),
          mimeType: MimeType.json,
        ),
      );
    }

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
  /// HMAC against the provider's `webhookSecret` and ingests Issue events.
  Future<Response> receiveLinearWebhook(Request request) async {
    final body = await request.readAsString();
    final signature = request.headers['linear-signature']?.first ?? '';
    final deliveryId = request.headers['linear-delivery']?.first;

    final signingSecret = await _resolveProviderSetting('linear', const [
      'webhookSecret',
      'webhook_secret',
    ]);
    if (signingSecret.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'Linear webhook secret is not configured'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final verifier = sl<LinearWebhookVerifier>();
    final valid = verifier.isValidSignature(
      body: body,
      signatureHeader: signature,
      signingSecret: signingSecret,
    );
    if (!valid) {
      return Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Linear webhook signature'}),
          mimeType: MimeType.json,
        ),
      );
    }

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
  /// POST /integrations/jira/webhook — Jira Cloud admin webhooks carry no HMAC
  /// signature, so access is gated by a shared secret (header
  /// `X-Webhook-Secret` or `?secret=` query parameter) compared against the
  /// provider's `webhookSecret` setting.
  Future<Response> receiveJiraWebhook(Request request) async {
    final provided =
        request.headers['X-Webhook-Secret']?.first ??
        request.url.queryParameters['secret'] ??
        '';

    final expected = await _resolveProviderSetting('jira', const [
      'webhookSecret',
      'webhook_secret',
    ]);
    if (expected.isEmpty) {
      return Response.internalServerError(
        body: Body.fromString(
          jsonEncode({'error': 'Jira webhook secret is not configured'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final verifier = sl<SharedSecretVerifier>();
    if (!verifier.isValid(provided: provided, expected: expected)) {
      return Response.unauthorized(
        body: Body.fromString(
          jsonEncode({'error': 'Invalid Jira webhook secret'}),
          mimeType: MimeType.json,
        ),
      );
    }

    final body = await request.readAsString();
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
      final orgTimezoneId = await loadOrgTimezoneId(
        sl<ISystemSettingsRepository>(),
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

  /// Reads the first non-empty settings value among [keys] from the active
  /// provider config identified by [providerId]. Returns '' when the provider
  /// is inactive, missing, or no key is set.
  Future<String> _resolveProviderSetting(
    String providerId,
    List<String> keys,
  ) async {
    final repo = sl<AbsIProviderConfigRepository>();
    final result = await repo.getConfigs();
    final config = result
        .getOrElse((_) => const [])
        .where((c) => c.id.toLowerCase() == providerId && c.isActive)
        .firstOrNull;
    if (config == null) {
      return '';
    }
    for (final key in keys) {
      final value = (config.settings[key] ?? '').toString().trim();
      if (value.isNotEmpty) return value;
    }
    return '';
  }
}
