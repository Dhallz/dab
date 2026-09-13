import 'package:dab_api/src/application/services/activity_live_poll_scheduler.dart';
import 'package:dab_api/src/application/services/activity_live_publisher.dart';
import 'package:dab_api/src/application/services/unified_activity_fetcher.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/infrastructure/persistence/redis/redis_service.dart';
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

  test('does not fetch or publish authored poll rows into the live inbox', () async {
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
    verifyNever(() => publisher.publish(any()));
    scheduler.stop();
  });
}
