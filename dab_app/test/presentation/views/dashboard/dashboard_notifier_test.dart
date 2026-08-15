import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/system_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_notifier.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_state.dart';
import 'package:dab_app/presentation/views/dashboard/models/dashboard_feed_mode.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockActivityRepository extends Mock implements IActivityRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

class _MockSystemUseCases extends Mock implements SystemUseCases {}

class _MockMetadataUseCases extends Mock implements MetadataUseCases {}

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

  setUpAll(() {
    registerFallbackValue(const ActivitySearchQuery());
  });

  setUp(() {
    repository = _MockActivityRepository();
    when(
      () => repository.watchActivities(),
    ).thenAnswer((_) => const Stream.empty());
  });

  ProviderContainer containerWithOverrides(
    DashboardNotifier Function() create,
  ) {
    return ProviderContainer(
      overrides: [
        dashboardNotifierProvider.overrideWith(create),
        appNotifierProvider.overrideWith(_TestAppNotifier.new),
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

    final container = containerWithOverrides(
      () => DashboardNotifier(
        ActivityUseCases(repository),
        isPersonalDeployment: () => false,
      ),
    );
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

      final container = containerWithOverrides(
        () => DashboardNotifier(
          ActivityUseCases(repository),
          isPersonalDeployment: () => false,
        ),
      );
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

  test(
    'personal deployment hydrates the team wall with global scope',
    () async {
      when(
        () => repository.getLiveActivities(
          limit: 50,
          global: true,
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

      final container = containerWithOverrides(
        () => DashboardNotifier(
          ActivityUseCases(repository),
          isPersonalDeployment: () => true,
        ),
      );
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
          global: true,
          includeArchived: true,
        ),
      ).called(1);
    },
  );

  test('setFeedMode changes layout without refetching', () async {
    when(
      () => repository.getLiveActivities(
        limit: 50,
        global: false,
        includeArchived: true,
      ),
    ).thenAnswer((_) async => Right(<Activity>[]));

    final container = containerWithOverrides(
      () => DashboardNotifier(
        ActivityUseCases(repository),
        isPersonalDeployment: () => false,
      ),
    );
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
}
