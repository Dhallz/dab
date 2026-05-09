import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/slack/http_slack_web_protocol.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  late _MockClient mockClient;
  late HttpSlackWebProtocol protocol;

  setUp(() {
    mockClient = _MockClient();
    protocol = HttpSlackWebProtocol(client: mockClient);
    registerFallbackValue(Uri.parse('https://slack.com/api/x'));
  });

  test('getJson returns map when ok true', () async {
    final uri = Uri.parse('https://slack.com/api/auth.test');
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => http.Response(
        '{"ok":true,"team_id":"T123"}',
        200,
      ),
    );

    final map = await protocol.getJson(uri, bearerToken: 'xoxb-test');
    expect(map['team_id'], 'T123');
    verify(
      () => mockClient.get(
        uri,
        headers: any(
          named: 'headers',
          that: containsPair('Authorization', 'Bearer xoxb-test'),
        ),
      ),
    ).called(1);
  });

  test('getJson throws SlackWebProtocolException when ok false', () async {
    final uri = Uri.parse('https://slack.com/api/x');
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => http.Response('{"ok":false,"error":"channel_not_found"}', 200),
    );

    expect(
      () => protocol.getJson(uri, bearerToken: 't'),
      throwsA(isA<SlackWebProtocolException>()),
    );
  });

  test('postJson parses envelope', () async {
    final uri = Uri.parse('https://slack.com/api/auth.test');
    when(
      () => mockClient.post(any(), headers: any(named: 'headers')),
    ).thenAnswer(
      (_) async => http.Response('{"ok":true,"team_id":"T9"}', 200),
    );

    final map = await protocol.postJson(uri, bearerToken: 't');
    expect(map['team_id'], 'T9');
  });
}
