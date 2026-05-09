import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_category.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/entities/group/group.dart';
import 'package:dab_app/domain/entities/group/group_type.dart';
import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/views/explorer/explorer_notifier.dart';
import 'package:dab_app/presentation/views/explorer/models/directory_type.dart';
import 'package:dab_app/presentation/views/explorer/models/explorer_date_mode.dart';
import 'package:dab_app/presentation/views/explorer/models/explorer_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

void main() {
  late MockActivityRepository mockActivityRepository;
  late MockUserRepository mockUserRepository;
  late MockProviderConfigRepository mockProviderConfigRepository;

  late ActivityUseCases activityUseCases;
  late UserUseCases userUseCases;
  late MetadataUseCases metadataUseCases;

  const alice = User(id: 'u1', name: 'Alice', email: 'alice@example.com');
  const bob = User(id: 'u2', name: 'Bob', email: 'bob@example.com');
  final devGroup = Group(
    id: 'g1',
    name: 'Developers',
    type: GroupType.custom,
    members: const [alice, bob],
  );
  final providerConfig = ProviderConfig(
    id: 'slack',
    name: 'Slack',
    baseUrl: 'https://slack.example.com',
    isActive: true,
  );
  final githubProviderConfig = ProviderConfig(
    id: 'github',
    name: 'GitHub',
    baseUrl: 'https://github.example.com',
    isActive: true,
  );

  Activity activityFor(String userId, DateTime createdAt) {
    return Activity(
      id: 'a-$userId-${createdAt.millisecondsSinceEpoch}',
      userId: userId,
      provider: const SlackMessageProvider(channelId: 'C123'),
      title: 'Activity',
      content: 'Content',
      authorName: 'Author',
      commentCount: 0,
      createdAt: createdAt,
    );
  }

  ExplorerNotifier createNotifier() =>
      ExplorerNotifier(activityUseCases, userUseCases, metadataUseCases);

  /// Avoid auto-disposing [explorerNotifierProvider] between async gaps.
  void subscribeExplorer(ProviderContainer container) {
    final sub = container.listen(explorerNotifierProvider, (_, _) {});
    addTearDown(sub.close);
  }

  setUpAll(() {
    registerFallbackValue(
      const Group(
        id: 'fallback',
        name: 'Fallback',
        type: GroupType.custom,
        members: [],
      ),
    );
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
    when(
      () => mockUserRepository.getGroups(),
    ).thenAnswer((_) async => Right([devGroup]));
    when(
      () => mockProviderConfigRepository.getProviderConfigs(),
    ).thenAnswer((_) async => Right([providerConfig, githubProviderConfig]));
    when(() => mockActivityRepository.searchActivities(any())).thenAnswer(
      (_) async => Right([activityFor('u1', DateTime.utc(2026, 1, 1, 10))]),
    );
    when(() => mockUserRepository.saveGroup(any())).thenAnswer(
      (invocation) async => Right(invocation.positionalArguments.first),
    );
    when(
      () => mockUserRepository.deleteGroup(any()),
    ).thenAnswer((_) async => const Right(null));
  });

  test(
    'uses only active admin-configured providers for provider/activity filters',
    () async {
      when(() => mockProviderConfigRepository.getProviderConfigs()).thenAnswer(
        (_) async => Right([
          providerConfig,
          githubProviderConfig.copyWith(isActive: false),
        ]),
      );

      final container = ProviderContainer(
        overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
      );
      subscribeExplorer(container);
      addTearDown(container.dispose);

      await container.read(explorerNotifierProvider.notifier).started('u1');
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(explorerNotifierProvider);
      expect(state.availableProviders, ['slack']);
      expect(state.selectedProviders, {'slack'});
      expect(state.availableActivityCategories, {ActivityCategory.message});
      expect(state.selectedActivityCategories, {ActivityCategory.message});
    },
  );

  test('preselects connected user on first load', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    await container.read(explorerNotifierProvider.notifier).started('u1');
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(container.read(explorerNotifierProvider).selectedUserIds, {'u1'});
    verify(
      () => mockActivityRepository.searchActivities(
        any(
          that: isA<ActivitySearchQuery>()
              .having((query) => query.users, 'users', ['u1'])
              .having((query) => query.providers, 'providers', {
                'slack',
                'github',
              })
              .having((query) => query.coverageProviders, 'coverageProviders', {
                'slack',
                'github',
              })
              .having((query) => query.categories, 'categories', {
                ActivityCategory.message,
                ActivityCategory.commit,
              }),
        ),
      ),
    ).called(1);
  });

  test('uses inclusive start/end dates in range mode', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    final notifier = container.read(explorerNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.changeDateMode(ExplorerDateMode.range);
    await notifier.changeDateRange(
      DateTime.utc(2026, 1, 1),
      DateTime.utc(2026, 1, 7),
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));

    verify(
      () => mockActivityRepository.searchActivities(
        any(
          that: isA<ActivitySearchQuery>()
              .having(
                (query) => query.startDate,
                'startDate',
                DateTime.utc(2026, 1, 1),
              )
              .having(
                (query) => query.endDate,
                'endDate',
                DateTime.utc(2026, 1, 7),
              )
              .having((query) => query.users, 'users', ['u1']),
        ),
      ),
    ).called(1);
  });

  test('uses selected users only while in users directory', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    final notifier = container.read(explorerNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.toggleGroup('g1');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    verify(
      () => mockActivityRepository.searchActivities(
        any(
          that: isA<ActivitySearchQuery>().having(
            (query) => query.users,
            'users',
            ['u1'],
          ),
        ),
      ),
    ).called(2);
  });

  test('uses selected group members only while in groups directory', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    final notifier = container.read(explorerNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.toggleGroup('g1');
    await notifier.setDirectoryType(DirectoryType.groups);
    await Future<void>.delayed(const Duration(milliseconds: 100));

    verify(
      () => mockActivityRepository.searchActivities(
        any(
          that: isA<ActivitySearchQuery>().having(
            (query) => query.users,
            'users',
            ['u1', 'u2'],
          ),
        ),
      ),
    ).called(1);
  });

  test('returns empty when no selection exists in active directory', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    await container.read(explorerNotifierProvider.notifier).started(null);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    verifyNever(() => mockActivityRepository.searchActivities(any()));
  });

  test('filters activities by selected activity categories', () async {
    final allActivities = [
      Activity(
        id: 'commit-1',
        userId: 'u1',
        provider: const GitHubCommitProvider(),
        title: 'Commit',
        content: 'Code updated',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 1, 11),
      ),
      Activity(
        id: 'message-1',
        userId: 'u1',
        provider: const SlackMessageProvider(channelId: 'C123'),
        title: 'Message',
        content: 'Slack update',
        authorName: 'Alice',
        commentCount: 0,
        createdAt: DateTime.utc(2026, 1, 1, 10),
      ),
    ];
    when(() => mockActivityRepository.searchActivities(any())).thenAnswer((
      invocation,
    ) async {
      final query = invocation.positionalArguments.first as ActivitySearchQuery;
      final filtered = allActivities
          .where(
            (activity) => query.categories.contains(activity.provider.category),
          )
          .toList();
      return Right(filtered);
    });

    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    final notifier = container.read(explorerNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.toggleActivityCategory(ActivityCategory.message);
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final state = container.read(explorerNotifierProvider);
    final items = state.items.whereType<SingleActivityItem>().toList();
    expect(items, hasLength(1));
    expect(items.first.activity.provider.category, ActivityCategory.commit);
    expect(
      state.selectedActivityCategories.contains(ActivityCategory.message),
      isFalse,
    );
  });

  test('renames a group in state through saveGroup', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    final notifier = container.read(explorerNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.renameGroup('g1', 'Core Team');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    expect(
      container
          .read(explorerNotifierProvider)
          .groups
          .firstWhere((g) => g.id == 'g1')
          .name,
      'Core Team',
    );
    verify(() => mockUserRepository.saveGroup(any())).called(1);
  });

  test('deletes a group from state and selection', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    final notifier = container.read(explorerNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.toggleGroup('g1');
    await notifier.setDirectoryType(DirectoryType.groups);
    await notifier.deleteGroup('g1');
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final state = container.read(explorerNotifierProvider);
    expect(state.groups.where((g) => g.id == 'g1'), isEmpty);
    expect(state.selectedGroupIds.contains('g1'), isFalse);
    verify(() => mockUserRepository.deleteGroup('g1')).called(1);
  });

  test('updates existing group members through saveGroup', () async {
    final container = ProviderContainer(
      overrides: [explorerNotifierProvider.overrideWith(createNotifier)],
    );
    subscribeExplorer(container);
    addTearDown(container.dispose);

    final notifier = container.read(explorerNotifierProvider.notifier);
    await notifier.started('u1');
    await notifier.saveGroup(devGroup.copyWith(members: const [alice]));
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final state = container.read(explorerNotifierProvider);
    final updatedGroup = state.groups.firstWhere((g) => g.id == 'g1');
    expect(updatedGroup.members.map((m) => m.id).toList(), ['u1']);
    expect(state.groups.where((g) => g.id == 'g1').length, 1);
    verify(() => mockUserRepository.saveGroup(any())).called(greaterThan(0));
  });
}
