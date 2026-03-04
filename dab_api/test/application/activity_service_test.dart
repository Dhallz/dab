import 'package:dab_api/src/application/activity_service.dart';
import 'package:dab_api/src/application/presence_service.dart';
import 'package:dab_api/src/domain/core/failure.dart';
import 'package:dab_api/src/domain/entities/activity.dart';
import 'package:dab_api/src/domain/entities/activity_provider.dart';
import 'package:dab_api/src/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/infrastructure/database/redis/redis_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockActivityRepo extends Mock implements AbsIActivityRepository {}

class MockAuthRepo extends Mock implements AbsIAuthRepository {}

class MockPresence extends Mock implements PresenceService {}

class MockRedis extends Mock implements RedisService {}

void main() {
  late ActivityService service;
  late MockActivityRepo mockActivityRepo;
  late MockAuthRepo mockAuthRepo;
  late MockPresence mockPresence;
  late MockRedis mockRedis;

  setUpAll(() {
    registerFallbackValue(
      Activity(
        id: 'test',
        userId: 'test',
        provider: const PhorgeTaskProvider(taskPhid: 'T123'),
        title: 'test',
        content: 'test',
        createdAt: DateTime.now(),
      ),
    );
  });

  setUp(() {
    mockActivityRepo = MockActivityRepo();
    mockAuthRepo = MockAuthRepo();
    mockPresence = MockPresence();
    mockRedis = MockRedis();

    service = ActivityService(
      activityRepo: mockActivityRepo,
      authRepo: mockAuthRepo,
      presence: mockPresence,
      redis: mockRedis,
    );
  });

  group('ActivityService - logActivity', () {
    test(
      'logs activity, increments version, fans out to redis, and broadcasts',
      () async {
        // Arrange
        when(
          () => mockActivityRepo.createActivity(any()),
        ).thenAnswer((_) async => right<DatabaseFailure, void>(null));
        when(() => mockRedis.incrementVersion()).thenAnswer((_) async => 1042);
        when(() => mockRedis.fanOutActivity(any())).thenAnswer((_) async {});
        when(() => mockPresence.broadcast(any(), any())).thenReturn(null);

        // Act
        await service.logActivity(
          userId: 'u123',
          provider: const GenericProvider(name: 'Slack', category: 'message'),
          title: 'Test Broadcast',
          content: 'Hello World',
        );

        // Assert
        verify(() => mockActivityRepo.createActivity(any())).called(1);
        verify(() => mockRedis.incrementVersion()).called(1);
        verify(() => mockRedis.fanOutActivity(any())).called(1);
        verify(
          () => mockPresence.broadcast('ACTIVITY_RECEIVED', any()),
        ).called(1);
      },
    );

    test('does not fan out if database insert fails', () async {
      // Arrange
      when(
        () => mockActivityRepo.createActivity(any()),
      ).thenAnswer((_) async => left(DatabaseFailure('DB Error')));

      // Act
      await service.logActivity(
        userId: 'u123',
        provider: const GitHubCommitProvider(repo: 'org/repo', branch: 'main'),
        title: 'Failed Broadcast',
        content: 'Should not hit redis',
      );

      // Assert
      verify(() => mockActivityRepo.createActivity(any())).called(1);
      verifyNever(() => mockRedis.incrementVersion());
      verifyNever(() => mockRedis.fanOutActivity(any()));
      verifyNever(() => mockPresence.broadcast(any(), any()));
    });
  });

  group('ActivityService - getRecent', () {
    test('returns activities from repository', () async {
      // Arrange
      final mockList = [
        Activity(
          id: '1',
          userId: 'u1',
          provider: const GenericProvider(name: 'Slack', category: 'message'),
          title: 't1',
          content: 'c1',
          createdAt: DateTime.now(),
        ),
      ];
      when(
        () => mockActivityRepo.getRecentActivities(),
      ).thenAnswer((_) async => right(mockList));

      // Act
      final result = await service.getRecent();

      // Assert
      expect(result, equals(mockList));
      verify(() => mockActivityRepo.getRecentActivities()).called(1);
    });
  });
}
