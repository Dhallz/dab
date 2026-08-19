import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/system_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/core/activity_follow_key.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/entities/user/activity_follow.dart';
import 'package:dab_app/domain/entities/user/follow_candidate.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_inbox_local_notification.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/features/app/app_lifecycle.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_notifier.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_state.dart';
import 'package:dab_app/presentation/views/dashboard/models/dashboard_feed_mode.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockActivityRepository extends Mock implements IActivityRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

class _MockSystemUseCases extends Mock implements SystemUseCases {}

class _MockMetadataUseCases extends Mock implements MetadataUseCases {}

class _RecordingInbox implements IInboxLocalNotification {
  int calls = 0;
  String? lastId;
  String? lastTitle;
  String? lastBody;

  @override
  Future<void> show({
    required String notificationId,
    required String title,
    required String body,
  }) async {
    calls += 1;
    lastId = notificationId;
    lastTitle = title;
    lastBody = body;
  }
}

/// Stable [AppState] without async [AppNotifier.init] for unit tests.
class _TestAppNotifier extends AppNotifier {
  _TestAppNotifier()
    : super(
        _MockSystemUseCases(),
        _MockMetadataUseCases(),
        _MockUserRepository(),
        _MockProviderConfigRepository(),
      );

  @override
  AppState build() => const AppState();
}

void main() {
  late _MockActivityRepository repository;
  late _MockUserRepository userRepository;

  setUpAll(() {
    registerFallbackValue(const ActivitySearchQuery());
  });

  setUp(() {
    repository = _MockActivityRepository();
    userRepository = _MockUserRepository();
    when(
      () => repository.watchActivities(),
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => userRepository.listMyActivityFollows(),
    ).thenAnswer((_) async => const Right(<ActivityFollow>[]));
    when(
      () => userRepository.listMyFollowCandidates(
        query: any(named: 'query'),
      ),
    ).thenAnswer((_) async => const Right(<FollowCandidate>[]));
  });

  DashboardNotifier createNotifier() => DashboardNotifier(
    ActivityUseCases(repository),
    UserUseCases(userRepository),
  );

  ProviderContainer containerWithOverrides(
    DashboardNotifier Function() create, {
    List<Override> extra = const [],
  }) {
    return ProviderContainer(
      overrides: [
        dashboardNotifierProvider.overrideWith(create),
        appNotifierProvider.overrideWith(_TestAppNotifier.new),
        ...extra,
      ],
    );
  }

  test('loads live activities on start', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer(
      (_) async => Right([
        Activity(
          id: 'a-1',
          userId: 'u-1',
          provider: const SlackMessageProvider(channelId: 'C1'),
          title: 'Slack message',
          content: 'Hello from Slack',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 1, 10),
        ),
      ]),
    );

    final container = containerWithOverrides(createNotifier);
    final keepAlive = container.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    addTearDown(container.dispose);

    await Future<void>.delayed(const Duration(milliseconds: 150));

    final state = container.read(dashboardNotifierProvider);
    expect(state.status, ViewStatus.success);
    expect(state.activities.length, 1);
  });

  test(
    'hydrates archived entries on start and reveals them via visibility toggle',
    () async {
      when(
        () => repository.getLiveActivities(
          limit: 50,
          global: false,
          includeArchived: true,
        ),
      ).thenAnswer(
        (_) async => Right([
          Activity(
            id: 'a-1',
            userId: 'u-1',
            provider: const SlackMessageProvider(channelId: 'C1'),
            title: 'Visible message',
            content: 'still on the feed',
            authorName: 'Alice',
            commentCount: 0,
            createdAt: DateTime.utc(2026, 1, 1, 10),
          ),
          Activity(
            id: 'a-2',
            userId: 'u-1',
            provider: const SlackMessageProvider(channelId: 'C1'),
            title: 'Archived earlier',
            content: 'user archived before restart',
            authorName: 'Alice',
            commentCount: 0,
            createdAt: DateTime.utc(2026, 1, 1, 9),
            archived: true,
          ),
        ]),
      );

      final container = containerWithOverrides(createNotifier);
      final keepAlive = container.listen<DashboardState>(
        dashboardNotifierProvider,
        (_, _) {},
      );
      addTearDown(keepAlive.close);
      addTearDown(container.dispose);

      await Future<void>.delayed(const Duration(milliseconds: 120));

      final notifier = container.read(dashboardNotifierProvider.notifier);
      notifier.toggleArchivedVisibility();
      await Future<void>.delayed(const Duration(milliseconds: 80));

      final state = container.read(dashboardNotifierProvider);
      expect(state.activities.length, 2);
      expect(
        state.activities.where((a) => a.archived).length,
        1,
        reason: 'archived flag must survive hydration',
      );
      expect(
        state.showArchivedActivities,
        true,
        reason: 'toggle must flip to show archived',
      );
      expect(
        state.visibleActivities.length,
        2,
        reason: 'archived entry must become visible after toggle',
      );

      verify(
        () => repository.getLiveActivities(
          limit: 50,
          global: false,
          includeArchived: true,
        ),
      ).called(1);
    },
  );

  test('always hydrates the user-scoped inbound inbox', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer(
      (_) async => Right([
        Activity(
          id: 'bob-push',
          userId: 'bob',
          provider: const GenericProvider(name: 'github'),
          title: 'Bob push',
          content: 'sha',
          authorName: 'Bob',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 1, 10),
        ),
      ]),
    );

    final container = containerWithOverrides(createNotifier);
    final keepAlive = container.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    addTearDown(container.dispose);

    await Future<void>.delayed(const Duration(milliseconds: 120));

    final state = container.read(dashboardNotifierProvider);
    expect(state.activities.map((a) => a.id), ['bob-push']);
    verify(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).called(1);
  });

  test('setFeedMode changes layout without refetching', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer((_) async => Right(<Activity>[]));

    final container = containerWithOverrides(createNotifier);
    final keepAlive = container.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    addTearDown(container.dispose);

    await Future<void>.delayed(const Duration(milliseconds: 120));

    final notifier = container.read(dashboardNotifierProvider.notifier);
    expect(
      container.read(dashboardNotifierProvider).feedMode,
      DashboardFeedMode.timeline,
    );

    notifier.setFeedMode(DashboardFeedMode.provider);
    expect(
      container.read(dashboardNotifierProvider).feedMode,
      DashboardFeedMode.provider,
    );
    notifier.setFeedMode(DashboardFeedMode.category);
    expect(
      container.read(dashboardNotifierProvider).feedMode,
      DashboardFeedMode.category,
    );

    verify(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).called(1);
  });

  test('hydrates Follow pins and follow/unfollow updates local refs', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer(
      (_) async => Right([
        Activity(
          id: 'a-1',
          userId: 'u-1',
          provider: const PhorgeTaskProvider(taskPhid: 'PHID-TASK-1'),
          title: '[T1] Task',
          content: 'comment',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 1, 10),
          url: '/T1',
        ),
      ]),
    );
    when(() => userRepository.listMyActivityFollows()).thenAnswer(
      (_) async => const Right([
        ActivityFollow(providerId: 'phorge', objectKey: 'PHID-TASK-1'),
      ]),
    );
    when(
      () => userRepository.deleteMyActivityFollow(
        providerId: any(named: 'providerId'),
        objectKey: any(named: 'objectKey'),
      ),
    ).thenAnswer((_) async => const Right(null));
    when(
      () => userRepository.saveMyActivityFollow(
        providerId: any(named: 'providerId'),
        objectKey: any(named: 'objectKey'),
        title: any(named: 'title'),
        url: any(named: 'url'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        ActivityFollow(
          providerId: 'phorge',
          objectKey: 'PHID-TASK-1',
          title: '[T1] Task',
          url: '/T1',
        ),
      ),
    );

    final container = containerWithOverrides(createNotifier);
    final keepAlive = container.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    addTearDown(container.dispose);

    await Future<void>.delayed(const Duration(milliseconds: 150));

    final notifier = container.read(dashboardNotifierProvider.notifier);
    var state = container.read(dashboardNotifierProvider);
    expect(state.followedObjectRefs, [
      followObjectRef('phorge', 'PHID-TASK-1'),
    ]);
    expect(state.isFollowing(state.activities.first), isTrue);

    await notifier.unfollow(state.activities.first);
    state = container.read(dashboardNotifierProvider);
    expect(state.isFollowing(state.activities.first), isFalse);

    await notifier.follow(state.activities.first);
    state = container.read(dashboardNotifierProvider);
    expect(state.isFollowing(state.activities.first), isTrue);
    expect(state.watchingPins.single.displayTitle, '[T1] Task');
    verify(
      () => userRepository.saveMyActivityFollow(
        providerId: 'phorge',
        objectKey: 'PHID-TASK-1',
        title: '[T1] Task',
        url: '/T1',
      ),
    ).called(1);
  });

  test('follow is a no-op for git commits without a branch', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer(
      (_) async => Right([
        Activity(
          id: 'commit-1',
          userId: 'u-1',
          provider: const GitHubCommitProvider(repo: 'acme/app'),
          title: 'Fix login',
          content: 'sha',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 1, 10),
        ),
      ]),
    );

    final container = containerWithOverrides(createNotifier);
    final keepAlive = container.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    addTearDown(container.dispose);

    await Future<void>.delayed(const Duration(milliseconds: 120));

    final notifier = container.read(dashboardNotifierProvider.notifier);
    final activity = container.read(dashboardNotifierProvider).activities.first;
    expect(followObjectKeyFor(activity.provider), isNull);
    await notifier.follow(activity);
    verifyNever(
      () => userRepository.saveMyActivityFollow(
        providerId: any(named: 'providerId'),
        objectKey: any(named: 'objectKey'),
        title: any(named: 'title'),
        url: any(named: 'url'),
      ),
    );
  });

  test('followCandidate pins an issue from the Following picker', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => userRepository.saveMyActivityFollow(
        providerId: any(named: 'providerId'),
        objectKey: any(named: 'objectKey'),
        title: any(named: 'title'),
        url: any(named: 'url'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        ActivityFollow(
          providerId: 'jira',
          objectKey: 'DAB-7',
          title: '[DAB-7] Inbox',
        ),
      ),
    );

    final container = containerWithOverrides(createNotifier);
    final keepAlive = container.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    addTearDown(container.dispose);

    await Future<void>.delayed(const Duration(milliseconds: 150));

    final notifier = container.read(dashboardNotifierProvider.notifier);
    await notifier.followCandidate(
      const FollowCandidate(
        providerId: 'jira',
        objectKey: 'DAB-7',
        title: '[DAB-7] Inbox',
        url: 'https://example.com/browse/DAB-7',
      ),
    );

    final state = container.read(dashboardNotifierProvider);
    expect(state.followedObjectRefs, [followObjectRef('jira', 'DAB-7')]);
    expect(state.followedFeed, hasLength(1));
    expect(state.followedFeed.single.title, '[DAB-7] Inbox');
    verify(
      () => userRepository.saveMyActivityFollow(
        providerId: 'jira',
        objectKey: 'DAB-7',
        title: '[DAB-7] Inbox',
        url: 'https://example.com/browse/DAB-7',
      ),
    ).called(1);
  });

  test('setFollowSearchQuery debounces candidate refresh', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => userRepository.listMyFollowCandidates(query: 'foo'),
    ).thenAnswer(
      (_) async => const Right([
        FollowCandidate(
          providerId: 'github',
          objectKey: 'acme/app|feature/foo',
          title: 'acme/app · feature/foo',
          kind: 'gitBranch',
        ),
      ]),
    );

    final container = containerWithOverrides(createNotifier);
    final keepAlive = container.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(keepAlive.close);
    addTearDown(container.dispose);

    await Future<void>.delayed(const Duration(milliseconds: 150));

    final notifier = container.read(dashboardNotifierProvider.notifier);
    notifier.setFollowSearchQuery('foo');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final state = container.read(dashboardNotifierProvider);
    expect(state.followSearchQuery, 'foo');
    expect(state.followPickerVisible, hasLength(1));
    expect(state.followPickerVisible.single.objectKey, 'acme/app|feature/foo');
    verify(() => userRepository.listMyFollowCandidates(query: 'foo')).called(1);
  });

  test('shows a local banner when unfocused and skips when focused', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer((_) async => const Right([]));

    final unfocusedInbox = _RecordingInbox();
    final unfocused = containerWithOverrides(
      () => DashboardNotifier(
        ActivityUseCases(repository, inboxNotifications: unfocusedInbox),
        UserUseCases(userRepository),
      ),
      extra: [
        appLifecycleProvider.overrideWith(
          (ref) => AppLifecycleState.inactive,
        ),
      ],
    );
    final unfocusedKeep = unfocused.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(unfocusedKeep.close);
    addTearDown(unfocused.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 120));

    unfocused.read(dashboardNotifierProvider.notifier).onActivityReceived(
      Activity(
        id: 'a-live',
        userId: 'u-1',
        provider: const SlackMessageProvider(channelId: 'C1'),
        title: 'Hello from Slack',
        content: 'secret body',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 8, 17),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(unfocusedInbox.calls, 1);
    expect(unfocusedInbox.lastId, 'a-live:directed');
    expect(unfocusedInbox.lastTitle, 'Hello from Slack');
    expect(unfocusedInbox.lastBody, 'Directed');

    final focusedInbox = _RecordingInbox();
    final focused = containerWithOverrides(
      () => DashboardNotifier(
        ActivityUseCases(repository, inboxNotifications: focusedInbox),
        UserUseCases(userRepository),
      ),
    );
    final focusedKeep = focused.listen<DashboardState>(
      dashboardNotifierProvider,
      (_, _) {},
    );
    addTearDown(focusedKeep.close);
    addTearDown(focused.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 120));

    focused.read(dashboardNotifierProvider.notifier).onActivityReceived(
      Activity(
        id: 'a-live-2',
        userId: 'u-1',
        provider: const SlackMessageProvider(channelId: 'C1'),
        title: 'Hello from Slack',
        content: 'secret body',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 8, 17),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(focusedInbox.calls, 0);
  });
}
