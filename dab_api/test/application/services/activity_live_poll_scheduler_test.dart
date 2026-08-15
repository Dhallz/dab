import 'package:dab_api/src/application/services/activity_live_poll_scheduler.dart';
import 'package:dab_api/src/application/services/activity_live_publisher.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockFetcher extends Mock implements UnifiedActivityFetcher {}

class _MockUsers extends Mock implements IUserRepository {}

class _MockActivities extends Mock implements AbsIActivityRepository {}

class _MockRedis extends Mock implements RedisService {}

class _MockPublisher extends Mock implements ActivityLivePublisher {}

void main() {
  late _MockFetcher fetcher;
  late _MockUsers users;
  late _MockActivities activities;
  late _MockRedis redis;
  late _MockPublisher publisher;
  late ActivityLivePollScheduler scheduler;
  final now = DateTime.utc(2026, 6, 1, 12);
  final activity = Activity(
    id: 'a-1',
    userId: 'u-1',
    provider: const JiraIssueProvider(issueKey: 'DAB-1', projectKey: 'DAB'),
    title: '[DAB-1] Move me',
    content: 'Status: In Progress',
    authorName: 'Ada',
    createdAt: DateTime.utc(2026, 6, 1, 11, 50),
  );

  setUpAll(() {
    registerFallbackValue(<User>[]);
    registerFallbackValue(DateTime.utc(2026, 1, 1));
    registerFallbackValue(<String>{});
    registerFallbackValue(activity);
    registerFallbackValue(
      User(
        id: 'fallback',
        name: 'F',
        email: 'f@example.com',
        passwordHash: 'x',
        role: UserRole.standard,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
  });

  setUp(() {
    fetcher = _MockFetcher();
    users = _MockUsers();
    activities = _MockActivities();
    redis = _MockRedis();
    publisher = _MockPublisher();
    scheduler = ActivityLivePollScheduler(
      fetcher,
      users,
      activities,
      redis,
      publisher,
      now: () => now,
      tickImmediately: false,
    );
  });

  test(
    'skips fetch when live ingest is fresh for every PAT provider',
    () async {
      when(
        () => redis.getLiveIngestLastSuccess(any()),
      ).thenAnswer((_) async => now.subtract(const Duration(seconds: 30)));
      scheduler.start();
      await scheduler.runNow();
      verifyNever(() => users.getUsers());
      verifyNever(
        () => fetcher.fetchAll(
          users: any(named: 'users'),
          start: any(named: 'start'),
          end: any(named: 'end'),
          authoredOnly: any(named: 'authoredOnly'),
          providerIds: any(named: 'providerIds'),
        ),
      );
      scheduler.stop();
    },
  );

  test('fetches stale providers when webhook ingest is old', () async {
    when(
      () => redis.getLiveIngestLastSuccess(any()),
    ).thenAnswer((_) async => null);
    when(() => users.getUsers()).thenAnswer(
      (_) async => Right([
        User(
          id: 'u-1',
          name: 'Ada',
          email: 'ada@example.com',
          passwordHash: 'x',
          role: UserRole.standard,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ]),
    );
    when(
      () => fetcher.fetchAll(
        users: any(named: 'users'),
        start: any(named: 'start'),
        end: any(named: 'end'),
        authoredOnly: any(named: 'authoredOnly'),
        providerIds: any(named: 'providerIds'),
      ),
    ).thenAnswer((_) async => const []);

    scheduler.start();
    await scheduler.runNow();
    verify(
      () => fetcher.fetchAll(
        users: any(named: 'users'),
        start: any(named: 'start'),
        end: any(named: 'end'),
        authoredOnly: true,
        providerIds: any(named: 'providerIds'),
      ),
    ).called(1);
    scheduler.stop();
  });

  test(
    'publishes newly created activities and skips postgres duplicates',
    () async {
      when(
        () => redis.getLiveIngestLastSuccess(any()),
      ).thenAnswer((_) async => null);
      when(() => users.getUsers()).thenAnswer(
        (_) async => Right([
          User(
            id: 'u-1',
            name: 'Ada',
            email: 'ada@example.com',
            passwordHash: 'x',
            role: UserRole.standard,
            createdAt: DateTime.utc(2026, 1, 1),
          ),
        ]),
      );
      when(
        () => fetcher.fetchAll(
          users: any(named: 'users'),
          start: any(named: 'start'),
          end: any(named: 'end'),
          authoredOnly: any(named: 'authoredOnly'),
          providerIds: any(named: 'providerIds'),
        ),
      ).thenAnswer((_) async => [activity]);
      when(() => activities.createActivity(activity)).thenAnswer(
        (_) async => const Left(DatabaseFailure('duplicate key value')),
      );

      scheduler.start();
      await scheduler.runNow();
      verifyNever(() => publisher.publish(any()));

      when(
        () => activities.createActivity(activity),
      ).thenAnswer((_) async => const Right(null));
      when(() => publisher.publish(activity)).thenAnswer((_) async {});
      when(() => redis.recordLiveIngestSuccess(any())).thenAnswer((_) async {});

      await scheduler.runNow();
      verify(() => publisher.publish(activity)).called(1);
      verify(() => redis.recordLiveIngestSuccess('jira')).called(1);
      scheduler.stop();
    },
  );
}
