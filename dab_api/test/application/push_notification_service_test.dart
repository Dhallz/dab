import 'package:dab_api/src/infrastructure/notifications/push_notification_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockNotificationProvider extends Mock implements NotificationProvider {}

void main() {
  group('PushNotificationService', () {
    late PushNotificationService service;
    late MockNotificationProvider mockProvider;

    setUp(() {
      mockProvider = MockNotificationProvider();
    });

    test('notify should delegate to provider if present', () async {
      service = PushNotificationService(provider: mockProvider);

      when(
        () => mockProvider.send(any(), any(), any(), data: any(named: 'data')),
      ).thenAnswer((_) async {});

      await service.notify('token', 'title', 'body', data: {'key': 'val'});

      verify(
        () => mockProvider.send('token', 'title', 'body', data: {'key': 'val'}),
      ).called(1);
    });

    test('notify should drop notification if no provider', () async {
      service = PushNotificationService(provider: null);

      // Should not throw and just return
      await expectLater(service.notify('token', 'title', 'body'), completes);

      verifyNever(
        () => mockProvider.send(any(), any(), any(), data: any(named: 'data')),
      );
    });
  });
}
