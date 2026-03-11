import 'package:dab_api/src/application/activity_service.dart';
import 'package:dab_api/src/application/presence_service.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/presentation/controllers/activity_controller.dart';
import 'package:dab_api/src/presentation/middlewares/auth_middleware.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

class MockActivityService extends Mock implements ActivityService {}

class MockPresenceService extends Mock implements PresenceService {}

class MockRedisService extends Mock implements RedisService {}

void main() {
  group('ActivityController - searchActivities', () {
    late ActivityController controller;
    late MockActivityService mockActivityService;

    setUp(() {
      mockActivityService = MockActivityService();

      sl.reset();
      sl.registerSingleton<ActivityService>(mockActivityService);
      sl.registerSingleton<PresenceService>(MockPresenceService());
      sl.registerSingleton<RedisService>(MockRedisService());

      controller = ActivityController();
    });

    test('should parse YYYY-MM-DD as UTC and expand to next day UTC', () async {
      final request = TestRequest.create(
        url: Uri.parse(
          'http://localhost/search?startDate=2026-03-08&endDate=2026-03-08',
        ),
      );
      userIdProperty[request] = 'user123';

      // We expect the controller to call the service with UTC dates
      // 2026-03-08 00:00:00.000Z to 2026-03-09 00:00:00.000Z
      final expectedStart = DateTime.utc(2026, 3, 8);
      final expectedEnd = DateTime.utc(2026, 3, 9);

      when(
        () => mockActivityService.searchActivities(
          targetUserIds: any(named: 'targetUserIds'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          authoredOnly: any(named: 'authoredOnly'),
        ),
      ).thenAnswer((_) async => []);

      await controller.searchActivities(request);

      final captured = verify(
        () => mockActivityService.searchActivities(
          targetUserIds: any(named: 'targetUserIds'),
          startDate: captureAny(named: 'startDate'),
          endDate: captureAny(named: 'endDate'),
          authoredOnly: any(named: 'authoredOnly'),
        ),
      ).captured;

      final capturedStart = captured[0] as DateTime;
      final capturedEnd = captured[1] as DateTime;

      expect(capturedStart.isUtc, isTrue, reason: 'Start date should be UTC');
      expect(capturedStart, equals(expectedStart));

      expect(capturedEnd.isUtc, isTrue, reason: 'End date should be UTC');
      expect(capturedEnd, equals(expectedEnd));
    });

    test('should maintain UTC if ISO 8601 UTC string is provided', () async {
      final request = TestRequest.create(
        url: Uri.parse(
          'http://localhost/search?startDate=2026-03-08T10:00:00Z&endDate=2026-03-08T20:00:00Z',
        ),
      );
      userIdProperty[request] = 'user123';

      final expectedStart = DateTime.utc(2026, 3, 8, 10);

      when(
        () => mockActivityService.searchActivities(
          targetUserIds: any(named: 'targetUserIds'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          authoredOnly: any(named: 'authoredOnly'),
        ),
      ).thenAnswer((_) async => []);

      await controller.searchActivities(request);

      final capturedStart =
          verify(
                () => mockActivityService.searchActivities(
                  targetUserIds: any(named: 'targetUserIds'),
                  startDate: captureAny(named: 'startDate'),
                  endDate: any(named: 'endDate'),
                  authoredOnly: any(named: 'authoredOnly'),
                ),
              ).captured.first
              as DateTime;

      expect(capturedStart, equals(expectedStart));
      expect(capturedStart.isUtc, isTrue);
    });
  });
}
