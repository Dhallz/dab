import 'dart:convert';

import 'package:dab_api/src/application/activity_service.dart';
import 'package:dab_api/src/application/presence_service.dart';
import 'package:dab_api/src/domain/entities/activity_provider.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:dab_api/src/presentation/controllers/activity_controller.dart';
import 'package:dab_api/src/presentation/middlewares/auth_middleware.dart';
import 'package:dab_api/src/service_locator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:relic/relic.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

class MockActivityService extends Mock implements ActivityService {}

class MockPresenceService extends Mock implements PresenceService {}

class MockRedisService extends Mock implements RedisService {}

void main() {
  group('ActivityController', () {
    late ActivityController controller;
    late MockActivityService mockActivityService;
    late MockPresenceService mockPresenceService;
    late MockRedisService mockRedisService;

    setUp(() {
      mockActivityService = MockActivityService();
      mockPresenceService = MockPresenceService();
      mockRedisService = MockRedisService();

      sl.reset();
      sl.registerSingleton<ActivityService>(mockActivityService);
      sl.registerSingleton<PresenceService>(mockPresenceService);
      sl.registerSingleton<RedisService>(mockRedisService);

      controller = ActivityController();
    });

    test(
      'getActivities should return Envelope Pattern response with syncToken',
      () async {
        final request = TestRequest.create(
          url: Uri.parse('http://localhost/activities'),
        );
        userIdProperty[request] = 'user123';

        final mockActivities = [TestData.activity(userId: 'user123')];

        when(
          () => mockActivityService.getRecent(),
        ).thenAnswer((_) async => mockActivities);
        when(
          () => mockRedisService.getCurrentVersion(),
        ).thenAnswer((_) async => 42);

        final response = await controller.getActivities(request);

        expect(response.statusCode, equals(200));
        final body = jsonDecode(await response.readAsString());

        expect(body['data'], isA<List>());
        expect(body['data'].length, 1);
        expect(body['meta']['dataType'], equals('list:activity'));
        expect(body['meta']['syncToken'], equals('42'));
      },
    );

    test('createMock should log activity via service', () async {
      final request = TestRequest.create(
        method: Method.post,
        url: Uri.parse('http://localhost/mock'),
        body: Body.fromString(
          jsonEncode({
            'userId': 'user1',
            'provider': 'GitHub',
            'title': 'Commit',
          }),
        ),
      );

      registerFallbackValue(const GenericProvider(name: 'Mock'));

      when(
        () => mockActivityService.logActivity(
          userId: any(named: 'userId'),
          provider: any(named: 'provider'),
          title: any(named: 'title'),
          content: any(named: 'content'),
          url: any(named: 'url'),
        ),
      ).thenAnswer((_) async {});

      final response = await controller.createMock(request);

      expect(response.statusCode, equals(200));
      verify(
        () => mockActivityService.logActivity(
          userId: 'user1',
          provider: any(named: 'provider'),
          title: 'Commit',
          content: any(named: 'content'),
          url: any(named: 'url'),
        ),
      ).called(1);
    });
  });
}
