import 'dart:async';

import 'package:dab_api/src/infrastructure/protocols/protocol_exceptions.dart';
import 'package:dab_api/src/infrastructure/protocols/rest/http_json_rest_protocol.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  late _MockClient mockClient;
  late HttpJsonRestProtocol protocol;

  setUp(() {
    mockClient = _MockClient();
    protocol = HttpJsonRestProtocol(client: mockClient);
    registerFallbackValue(Uri.parse('https://example.com'));
  });

  group('getJsonList', () {
    test('returns list on 200 JSON array', () async {
      final uri = Uri.parse('https://api.github.com/repos/o/r/commits');
      when(
        () => mockClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('[{"sha":"abc"}]', 200));

      final list = await protocol.getJsonList(
        uri,
        headers: {'Accept': 'application/json'},
      );
      expect(list, hasLength(1));
      expect(list.first, isA<Map>());
      verify(
        () => mockClient.get(uri, headers: {'Accept': 'application/json'}),
      ).called(1);
    });

    test('throws JsonRestProtocolException on non-2xx', () async {
      final uri = Uri.parse('https://api.github.com/x');
      when(
        () => mockClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('Forbidden', 403));

      expect(
        () => protocol.getJsonList(uri),
        throwsA(isA<JsonRestProtocolException>()),
      );
    });

    test('throws JsonRestProtocolException when body is not array', () async {
      final uri = Uri.parse('https://api.github.com/x');
      when(
        () => mockClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('{}', 200));

      expect(
        () => protocol.getJsonList(uri),
        throwsA(isA<JsonRestProtocolException>()),
      );
    });
  });

  group('getJsonMap', () {
    test('returns map on 200 JSON object', () async {
      final uri = Uri.parse('https://api.example.com/v');
      when(
        () => mockClient.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('{"a":1}', 200));

      final map = await protocol.getJsonMap(uri);
      expect(map, {'a': 1});
    });
  });

  test('coalesces identical in-flight GETs into one HTTP call', () async {
    final uri = Uri.parse('https://api.figma.com/v1/files/abc/comments');
    final gate = Completer<http.Response>();
    var calls = 0;
    when(
      () => mockClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) {
      calls++;
      return gate.future;
    });

    final first = protocol.get(uri, headers: const {'X-Token': 't'});
    final second = protocol.get(uri, headers: const {'X-Token': 't'});
    await Future<void>.delayed(Duration.zero);
    expect(calls, 1);

    gate.complete(http.Response('{"comments":[]}', 200));
    await Future.wait([first, second]);
    expect(calls, 1);
  });
}
