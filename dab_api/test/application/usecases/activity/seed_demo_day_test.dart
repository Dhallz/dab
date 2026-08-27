import 'package:dab_api/src/application/usecases/activity/seed_demo_day.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/core/org_calendar.dart';
import 'package:dab_api/src/domain/entities/activity/activity.dart';
import 'package:dab_api/src/domain/entities/activity/activity_provider.dart';
import 'package:dab_api/src/domain/entities/group/group.dart';
import 'package:dab_api/src/domain/entities/group/group_type.dart';
import 'package:dab_api/src/domain/entities/provider/provider_config.dart';
import 'package:dab_api/src/domain/entities/user/activity_follow.dart';
import 'package:dab_api/src/domain/entities/user/daily_report.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_demo_activity_store.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_live_feed_store.dart';
import 'package:dab_api/src/domain/contracts/ports/abs_i_presence_broadcaster.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_follow_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_activity_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_auth_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_daily_report_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_system_settings_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../test_factories.dart';

class _MockAuth extends Mock implements AbsIAuthRepository {}

class _MockConfigs extends Mock implements AbsIProviderConfigRepository {}

class _MockSettings extends Mock implements AbsISystemSettingsRepository {}

class _MockActivities extends Mock implements AbsIActivityRepository {}

class _MockLiveFeed extends Mock implements AbsILiveFeedStore {}

class _MockPresence extends Mock implements AbsIPresenceBroadcaster {}

class _MockDemoStore extends Mock implements AbsIDemoActivityStore {}

class _MockFollows extends Mock implements AbsIActivityFollowRepository {}

class _MockReports extends Mock implements AbsIDailyReportRepository {}

class _MockDirectory extends Mock implements IUserRepository {}

void main() {
  late _MockAuth auth;
  late _MockConfigs configs;
  late _MockSettings settings;
  late _MockActivities activities;
  late _MockLiveFeed liveFeed;
  late _MockPresence presence;
  late _MockDemoStore demoStore;
  late _MockFollows follows;
  late _MockReports reports;
  late _MockDirectory directory;
  late bool enabled;

  final user = TestData.user(id: 'u-1', email: 'ada@acme.com');
  final now = DateTime.utc(2026, 8, 24, 17, 30);

  SeedDemoDay build() {
    return SeedDemoDay(
      auth: auth,
      configs: configs,
      settings: settings,
      activities: activities,
      liveFeed: liveFeed,
      presence: presence,
      demoStore: demoStore,
      follows: follows,
      reports: reports,
      directory: directory,
      isEnabled: () => enabled,
      now: () => now,
    );
  }

  setUpAll(() {
    initializeOrgCalendar();
    registerFallbackValue(
      Activity(
        id: 'fallback',
        userId: 'u',
        provider: const GenericProvider(name: 'Mock'),
        title: 'fallback',
        content: 'fallback',
        authorName: 'fallback',
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    registerFallbackValue(
      ActivityFollow(
        id: 'id',
        userId: 'u-1',
        providerId: 'jira',
        objectKey: 'DAB-42',
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    registerFallbackValue(
      const DailyReport(id: 'id', userId: 'u-1', date: '2026-01-01'),
    );
    registerFallbackValue(<Activity>[]);
    registerFallbackValue(<String, dynamic>{});
    registerFallbackValue(TestData.user(id: 'fallback-user'));
    registerFallbackValue(
      const Group(
        id: 'g',
        name: 'Engineering',
        type: GroupType.custom,
      ),
    );
  });

  setUp(() {
    auth = _MockAuth();
    configs = _MockConfigs();
    settings = _MockSettings();
    activities = _MockActivities();
    liveFeed = _MockLiveFeed();
    presence = _MockPresence();
    demoStore = _MockDemoStore();
    follows = _MockFollows();
    reports = _MockReports();
    directory = _MockDirectory();
    enabled = true;

    when(() => auth.findById('u-1')).thenAnswer((_) async => Right(user));
    when(() => settings.getSetting(any())).thenAnswer((_) async => const Right(null));
    when(() => settings.getAllowedDomain()).thenAnswer((_) async => const Right(null));
    when(() => configs.getConfigs()).thenAnswer(
      (_) async => const Right([
        ProviderConfig(
          id: 'jira',
          name: 'Jira',
          baseUrl: 'https://acme.atlassian.net',
        ),
      ]),
    );
    when(
      () => activities.createActivity(any()),
    ).thenAnswer((_) async => const Right(null));
    when(() => liveFeed.incrementVersion()).thenAnswer((_) async => 1);
    when(() => liveFeed.replaceFanOutActivity(any())).thenAnswer((_) async {});
    when(() => liveFeed.recordLiveIngestSuccess(any())).thenAnswer((_) async {});
    when(() => presence.broadcastToUser(any(), any(), any())).thenReturn(null);
    when(
      () => demoStore.replaceDay(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        activities: any(named: 'activities'),
      ),
    ).thenAnswer((_) async {});
    when(() => follows.upsert(any())).thenAnswer((invocation) async {
      return Right(invocation.positionalArguments.first as ActivityFollow);
    });
    when(() => reports.save(any())).thenAnswer((invocation) async {
      return Right(invocation.positionalArguments.first as DailyReport);
    });
    when(() => directory.saveGroup(any())).thenAnswer((invocation) async {
      return Right(invocation.positionalArguments.first as Group);
    });
  });

  test('rejects when mock seed is disabled', () async {
    enabled = false;
    final result = await build().execute(userId: 'u-1', date: '2026-08-24');
    expect(result.getLeft().toNullable(), isA<AuthFailure>());
    verifyNever(() => activities.createActivity(any()));
  });

  test('rejects an invalid date', () async {
    final result = await build().execute(userId: 'u-1', date: '24-08-2026');
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
  });

  test('rejects a missing user', () async {
    when(() => auth.findById('gone')).thenAnswer((_) async => const Right(null));
    final result = await build().execute(userId: 'gone', date: '2026-08-24');
    expect(result.getLeft().toNullable(), isA<NotFoundFailure>());
  });

  test('seeds today into live, demo search, follows, and a daily report', () async {
    final result = await build().execute(userId: 'u-1', date: '');
    final seeded = result.getOrElse((_) => throw StateError('left'));

    expect(seeded.date, '2026-08-24');
    expect(seeded.userId, 'u-1');
    expect(seeded.dashboardVisible, isTrue);
    expect(seeded.activityCount, greaterThan(8));
    expect(seeded.followCount, greaterThan(0));
    expect(seeded.reportLineCount, greaterThan(0));
    expect(seeded.providers, ['jira']);

    verify(() => activities.createActivity(any())).called(seeded.activityCount);
    verify(() => liveFeed.replaceFanOutActivity(any())).called(seeded.activityCount);
    verify(
      () => demoStore.replaceDay(
        userId: 'u-1',
        date: '2026-08-24',
        activities: any(named: 'activities'),
      ),
    ).called(1);
    verify(() => reports.save(any())).called(1);
  });

  test('historical dates are not dashboard-visible', () async {
    final result = await build().execute(userId: 'u-1', date: '2026-08-20');
    final seeded = result.getOrElse((_) => throw StateError('left'));
    expect(seeded.date, '2026-08-20');
    expect(seeded.dashboardVisible, isFalse);
  });

  test('ignores duplicate activity inserts', () async {
    when(() => activities.createActivity(any())).thenAnswer(
      (_) async => const Left(DatabaseFailure('duplicate key value violates unique constraint')),
    );

    final result = await build().execute(userId: 'u-1', date: '2026-08-24');
    expect(result.isRight(), isTrue);
    verify(() => demoStore.replaceDay(
      userId: any(named: 'userId'),
      date: any(named: 'date'),
      activities: any(named: 'activities'),
    )).called(1);
  });

  test('team mode creates roster users and seeds each with a variant', () async {
    when(() => settings.getAllowedDomain()).thenAnswer((_) async => const Right(null));
    when(() => auth.findByEmail(any())).thenAnswer((_) async => const Right(null));
    when(() => auth.createUser(any())).thenAnswer((_) async => const Right(null));

    final result = await build().execute(
      userId: 'u-1',
      date: '2026-08-24',
      team: true,
      teamSize: 3,
    );
    final seeded = result.getOrElse((_) => throw StateError('left'));

    expect(seeded.userCount, 3);
    expect(seeded.createdUserCount, 2);
    expect(seeded.userIds, hasLength(3));
    expect(seeded.userIds.first, 'u-1');
    expect(seeded.activityCount, greaterThan(0));
    expect(seeded.groupCount, 2);
    verify(() => auth.createUser(any())).called(2);
    verify(() => directory.saveGroup(any())).called(2);
    verify(
      () => demoStore.replaceDay(
        userId: any(named: 'userId'),
        date: '2026-08-24',
        activities: any(named: 'activities'),
      ),
    ).called(3);
  });

  test('team roster cards do not author as the operator', () async {
    final operator = TestData.user(
      id: 'u-1',
      name: 'Dhawud',
      email: 'dhawud@acme.com',
    );
    when(() => auth.findById('u-1')).thenAnswer((_) async => Right(operator));
    when(() => settings.getAllowedDomain()).thenAnswer((_) async => const Right(null));
    when(() => auth.findByEmail(any())).thenAnswer((_) async => const Right(null));
    when(() => auth.createUser(any())).thenAnswer((_) async => const Right(null));

    final created = <Activity>[];
    when(() => activities.createActivity(any())).thenAnswer((invocation) async {
      created.add(invocation.positionalArguments.first as Activity);
      return const Right(null);
    });

    final result = await build().execute(
      userId: 'u-1',
      date: '2026-08-24',
      team: true,
      teamSize: 3,
    );
    expect(result.isRight(), isTrue);

    final rosterRows = created.where((activity) => activity.userId != 'u-1');
    expect(rosterRows, isNotEmpty);
    expect(
      rosterRows.every((activity) {
        final blob =
            '${activity.authorName} ${activity.title} ${activity.content}'
                .toLowerCase();
        return !blob.contains('dhawud');
      }),
      isTrue,
    );
    expect(
      rosterRows.every((activity) => activity.senderUserId != 'u-1'),
      isTrue,
    );
  });

  test('userIds seeds existing accounts and includes the caller', () async {
    final other = TestData.user(id: 'u-2', email: 'rio@acme.com');
    when(() => auth.findById('u-2')).thenAnswer((_) async => Right(other));

    final result = await build().execute(
      userId: 'u-1',
      date: '2026-08-24',
      userIds: const ['u-2'],
    );
    final seeded = result.getOrElse((_) => throw StateError('left'));

    expect(seeded.userIds, ['u-1', 'u-2']);
    expect(seeded.createdUserCount, 0);
    verifyNever(() => auth.createUser(any()));
    verify(
      () => demoStore.replaceDay(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
        activities: any(named: 'activities'),
      ),
    ).called(2);
  });
}