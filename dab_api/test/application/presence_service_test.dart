import 'package:dab_api/src/infrastructure/core/realtime/presence_service.dart';
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
      presenceService.addSession(mockSocket, 'user1');
      // We check broadcast to verify it's tracked
      presenceService.broadcast('test', {'foo': 'bar'});
      verify(() => mockSocket.trySendText(any())).called(1);
    });

    test('removeSession should stop tracking a session', () {
      presenceService.addSession(mockSocket, 'user1');
      presenceService.removeSession(mockSocket);
      presenceService.broadcast('test', {'foo': 'bar'});
      verifyNever(() => mockSocket.trySendText(any()));
    });

    test('broadcast should send payload to all tracked sessions', () {
      final mockSocket2 = MockRelicWebSocket();
      when(() => mockSocket2.trySendText(any())).thenReturn(true);

      presenceService.addSession(mockSocket, 'user1');
      presenceService.addSession(mockSocket2, 'user2');

      presenceService.broadcast('alert', {'msg': 'hello'});

      verify(() => mockSocket.trySendText(any())).called(1);
      verify(() => mockSocket2.trySendText(any())).called(1);
    });

    test('broadcastToUser ACTIVITY_RECEIVED stays author-scoped', () {
      final mockSocket2 = MockRelicWebSocket();
      when(() => mockSocket2.trySendText(any())).thenReturn(true);

      presenceService.addSession(mockSocket, 'user1');
      presenceService.addSession(mockSocket2, 'user2');

      presenceService.broadcastToUser('user2', 'ACTIVITY_RECEIVED', {
        'id': 'a-1',
      });

      verifyNever(() => mockSocket.trySendText(any()));
      verify(() => mockSocket2.trySendText(any())).called(1);
    });

    test('hasSession is true only for connected user ids', () {
      presenceService.addSession(mockSocket, 'user1');

      expect(presenceService.hasSession('user1'), isTrue);
      expect(presenceService.hasSession('user2'), isFalse);
      expect(presenceService.hasSession('  '), isFalse);

      presenceService.removeSession(mockSocket);
      expect(presenceService.hasSession('user1'), isFalse);
    });
  });
}
