import 'package:dab_api/src/domain/core/inbox_wake.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/infrastructure/core/realtime/fcm_http_v1_push_wake_client.dart';
import 'package:test/test.dart';

void main() {
  test('tryParse returns null for empty or incomplete JSON', () {
    expect(FcmHttpV1PushWakeClient.tryParse(''), isNull);
    expect(FcmHttpV1PushWakeClient.tryParse('{"project_id":"p"}'), isNull);
  });

  test('sendWake posts data-only messages without a notification block', () async {
    Uri? sentUri;
    Map<String, String>? sentHeaders;
    Map<String, dynamic>? sentBody;
    final pushClient = FcmHttpV1PushWakeClient(
      projectId: 'dab-prod',
      sendHttp: ({required uri, required headers, required body}) async {
        sentUri = uri;
        sentHeaders = headers;
        sentBody = body;
      },
    );
    final activity = Activity(
      id: 'a-9',
      userId: 'u-1',
      provider: const GenericProvider(name: 'jira'),
      title: 'Must not appear',
      content: 'Must not appear either',
      authorName: 'Bob',
      createdAt: DateTime.utc(2026, 8, 17),
      inboxLane: ActivityInboxLane.follow,
    );

    await pushClient.sendWake(
      tokens: ['device-1'],
      data: activity.inboxWakeData(),
    );

    expect(
      sentUri.toString(),
      'https://fcm.googleapis.com/v1/projects/dab-prod/messages:send',
    );
    expect(sentHeaders?['Content-Type'], 'application/json');
    final message = sentBody?['message'] as Map<String, dynamic>;
    expect(message.containsKey('notification'), isFalse);
    expect(message['token'], 'device-1');
    expect(message['data'], {
      'type': 'inbox_wake',
      'lane': 'follow',
      'activityId': 'a-9',
    });
  });

  test('sendWake drops payloads that include activity copy', () async {
    var called = false;
    final pushClient = FcmHttpV1PushWakeClient(
      projectId: 'dab-prod',
      sendHttp: ({required uri, required headers, required body}) async {
        called = true;
      },
    );

    await pushClient.sendWake(
      tokens: ['device-1'],
      data: {
        'type': 'inbox_wake',
        'lane': 'directed',
        'activityId': 'a-1',
        'title': 'leaked',
      },
    );

    expect(called, isFalse);
  });
}
