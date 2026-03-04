import 'package:dab_api/src/application/presence_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../test_utils.dart';

class MockRelicWebSocket extends Mock implements RelicWebSocket {}

void main() {
  group('PresenceService', () {
    late PresenceService presenceService;
    late MockRelicWebSocket mockSocket;

    setUp(() {
      presenceService = PresenceService();
      mockSocket = MockRelicWebSocket();
      registerFallbackValue(
        TestRequest.create(url: Uri.parse('http://localhost')),
      );
      when(() => mockSocket.trySendText(any())).thenReturn(true);
    });

    test('addSession should track a new session', () {
      presenceService.addSession(mockSocket);
      // We check broadcast to verify it's tracked
      presenceService.broadcast('test', {'foo': 'bar'});
      verify(() => mockSocket.trySendText(any())).called(1);
    });

    test('removeSession should stop tracking a session', () {
      presenceService.addSession(mockSocket);
      presenceService.removeSession(mockSocket);
      presenceService.broadcast('test', {'foo': 'bar'});
      verifyNever(() => mockSocket.trySendText(any()));
    });

    test('broadcast should send payload to all tracked sessions', () {
      final mockSocket2 = MockRelicWebSocket();
      when(() => mockSocket2.trySendText(any())).thenReturn(true);

      presenceService.addSession(mockSocket);
      presenceService.addSession(mockSocket2);

      presenceService.broadcast('alert', {'msg': 'hello'});

      verify(() => mockSocket.trySendText(any())).called(1);
      verify(() => mockSocket2.trySendText(any())).called(1);
    });
  });
}
