import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/system_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity_category.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:dab_app/presentation/views/admin/models/provider_connection_status.dart';
import 'package:dab_app/presentation/views/insights/insights_notifier.dart';
import 'package:dab_app/presentation/views/insights/insights_state.dart';
import 'package:dab_app/presentation/views/insights/models/insights_date_preset.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

class MockSystemUseCases extends Mock implements SystemUseCases {}

class MockMetadataUseCases extends Mock implements MetadataUseCases {}

Map<String, ProviderConnectionStatus> successConnectionsFor(
  Iterable<String> providerIds,
) {
  return {
    for (final id in providerIds)
      id: const ProviderConnectionStatus(status: ViewStatus.success),
  };
}

/// Stable [AppState] without async [AppNotifier.init] for unit tests.
class TestAppNotifier extends AppNotifier {
  TestAppNotifier({Map<String, ProviderConnectionStatus>? connections})
    : _connections =
          connections ?? successConnectionsFor(const ['slack', 'github']),
      super(
        MockSystemUseCases(),
        MockMetadataUseCases(),
        MockUserRepository(),
        MockProviderConfigRepository(),
      );

  final Map<String, ProviderConnectionStatus> _connections;

  @override
  AppState build() => AppState(providerConnectionStatuses: _connections);
}

void main() {
  late MockActivityRepository mockActivityRepository;
  late MockUserRepository mockUserRepository;
  late MockProviderConfigRepository mockProviderConfigRepository;

  late ActivityUseCases activityUseCases;
  late UserUseCases userUseCases;
  late MetadataUseCases metadataUseCases;

  const alice = User(id: 'u1', name: 'Alice', email: 'alice@example.com');
  const bob = User(id: 'u2', name: 'Bob', email: 'bob@example.com');

  setUpAll(() {
    registerFallbackValue(const ActivitySearchQuery());
  });

  setUp(() {
    mockActivityRepository = MockActivityRepository();
    mockUserRepository = MockUserRepository();
    mockProviderConfigRepository = MockProviderConfigRepository();

    activityUseCases = ActivityUseCases(mockActivityRepository);
    userUseCases = UserUseCases(mockUserRepository);
    metadataUseCases = MetadataUseCases(mockProviderConfigRepository);

    when(
      () => mockUserRepository.getUsers(),
    ).thenAnswer((_) async => const Right([alice, bob]));
    when(() => mockProviderConfigRepository.getProviderConfigs()).thenAnswer(
      (_) async => Right([
        const ProviderConfig(
          id: 'slack',
          name: 'Slack',
          baseUrl: 'https://slack.example.com',
          isActive: true,
        ),
        const ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.example.com',
          isActive: true,
        ),
      ]),
    );
    when(() => mockActivityRepository.searchActivities(any())).thenAnswer(
      (_) async => Right([
        Activity(
          id: 'a1',
          userId: 'u1',
          provider: const SlackMessageProvider(channelId: 'C1'),
          title: 'Message',
          content: 'Hello',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 1, 10),
        ),
      ]),
    );
  });

  InsightsNotifier createNotifier() =>
      InsightsNotifier(activityUseCases, userUseCases, metadataUseCases);

  ProviderContainer createTestContainer({
    Map<String, ProviderConnectionStatus>? connections,
  }) =>
      ProviderContainer(
        overrides: [
          insightsNotifierProvider.overrideWith(createNotifier),
          appNotifierProvider.overrideWith(
            () => TestAppNotifier(connections: connections),
          ),
        ],
      );

  void subscribeInsights(ProviderContainer container) {
    final sub = container.listen(insightsNotifierProvider, (_, _) {});
    addTearDown(sub.close);
  }

  test('preselects connected user and queries by selected filters', () async {
    final container = createTestContainer();
    subscribeInsights(container);
    addTearDown(container.dispose);

    await container.read(insightsNotifierProvider.notifier).started('u1');
    await Future<void>.delayed(const Duration(milliseconds: 80));

    expect(container.read(insightsNotifierProvider).selectedUserIds, {'u1'});
    verify(
      () => mockActivityRepository.searchActivities(
        any(
          that: isA<ActivitySearchQuery>()
              .having((query) => query.users, 'users', ['u1'])
              .having((query) => query.providers, 'providers', {
                'slack',
                'github',
              }),
        ),
      ),
    ).called(1);
  });

  test('uses only active connected providers for filters', () async {
    when(() => mockProviderConfigRepository.getProviderConfigs()).thenAnswer(
      (_) async => Right([
        const ProviderConfig(
          id: 'slack',
          name: 'Slack',
          baseUrl: 'https://slack.example.com',
          isActive: true,
        ),
        const ProviderConfig(
          id: 'github',
          name: 'GitHub',
          baseUrl: 'https://github.example.com',
          isActive: false,
        ),
      ]),
    );

    final container = createTestContainer(
      connections: successConnectionsFor(['slack']),
    );
    subscribeInsights(container);
    addTearDown(container.dispose);

    await container.read(insightsNotifierProvider.notifier).started('u1');
    await Future<void>.delayed(const Duration(milliseconds: 80));

    final state = container.read(insightsNotifierProvider);
    expect(state.availableProviders, ['slack']);
    expect(state.selectedProviders, {'slack'});
    expect(state.availableActivityCategories, {ActivityCategory.message});
  });

  test('switches to last 30 days preset', () async {
    final container = createTestContainer();
    subscribeInsights(container);
    addTearDown(container.dispose);

    final notifier = container.read(insightsNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.setDatePreset(InsightsDatePreset.last30Days);
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final state = container.read(insightsNotifierProvider);
    expect(state.datePreset, InsightsDatePreset.last30Days);
    final dayDiff = state.endDate.difference(state.startDate).inDays;
    expect(dayDiff, 29);
  });

  test('projects analytics counters from fetched activities', () async {
    when(() => mockActivityRepository.searchActivities(any())).thenAnswer(
      (_) async => Right([
        Activity(
          id: 'a1',
          userId: 'u1',
          provider: const SlackMessageProvider(channelId: 'C1'),
          title: 'Message 1',
          content: 'Hello',
          authorName: 'Alice',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 1, 10),
        ),
        Activity(
          id: 'a2',
          userId: 'u2',
          provider: const GitHubCommitProvider(),
          title: 'Commit',
          content: 'Code',
          authorName: 'Bob',
          commentCount: 0,
          createdAt: DateTime.utc(2026, 1, 1, 12),
        ),
      ]),
    );

    final container = createTestContainer();
    subscribeInsights(container);
    addTearDown(container.dispose);

    await container.read(insightsNotifierProvider.notifier).started(null);
    await Future<void>.delayed(const Duration(milliseconds: 80));

    final state = container.read(insightsNotifierProvider);
    expect(state.totalActivities, 2);
    expect(state.activeUsersCount, 2);
    expect(state.activeProvidersCount, 2);
    expect(state.mostFrequentCategory, isNotNull);
  });
}
