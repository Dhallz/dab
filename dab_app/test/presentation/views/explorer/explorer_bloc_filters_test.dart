import 'package:bloc_test/bloc_test.dart';
import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_category.dart';
import 'package:dab_app/domain/entities/group/group.dart';
import 'package:dab_app/domain/entities/group/group_type.dart';
import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/views/explorer/explorer_bloc.dart';
import 'package:dab_app/presentation/views/explorer/explorer_event.dart';
import 'package:dab_app/presentation/views/explorer/explorer_item.dart';
import 'package:dab_app/presentation/views/explorer/explorer_state.dart';
import 'package:dab_app/presentation/views/explorer/models/directory_type.dart';
import 'package:dab_app/presentation/views/explorer/models/explorer_date_mode.dart';
import 'package:fpdart/fpdart.dart' hide Group;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

void main() {
  late ExplorerBloc explorerBloc;
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

  setUpAll(() {
    registerFallbackValue(
      const Group(
        id: 'fallback',
        name: 'Fallback',
        type: GroupType.custom,
        members: [],
      ),
    );
  });

  setUp(() {
    mockActivityRepository = MockActivityRepository();
    mockUserRepository = MockUserRepository();
    mockProviderConfigRepository = MockProviderConfigRepository();

    activityUseCases = ActivityUseCases(mockActivityRepository);
    userUseCases = UserUseCases(mockUserRepository);
    metadataUseCases = MetadataUseCases(mockProviderConfigRepository);

    explorerBloc = ExplorerBloc(
      activityUseCases,
      userUseCases,
      metadataUseCases,
    );

    when(
      () => mockUserRepository.getUsers(),
    ).thenAnswer((_) async => const Right([alice, bob]));
    when(
      () => mockUserRepository.getGroups(),
    ).thenAnswer((_) async => Right([devGroup]));
    when(
      () => mockProviderConfigRepository.getProviderConfigs(),
    ).thenAnswer((_) async => Right([providerConfig, githubProviderConfig]));
    when(
      () => mockActivityRepository.searchActivities(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        users: any(named: 'users'),
        authoredOnly: any(named: 'authoredOnly'),
      ),
    ).thenAnswer(
      (_) async => Right([activityFor('u1', DateTime.utc(2026, 1, 1, 10))]),
    );
    when(() => mockUserRepository.saveGroup(any())).thenAnswer(
      (invocation) async => Right(invocation.positionalArguments.first),
    );
    when(
      () => mockUserRepository.deleteGroup(any()),
    ).thenAnswer((_) async => const Right(null));
  });

  tearDown(() async {
    await explorerBloc.close();
  });

  blocTest<ExplorerBloc, ExplorerState>(
    'uses only active admin-configured providers for provider/activity filters',
    build: () {
      when(() => mockProviderConfigRepository.getProviderConfigs()).thenAnswer(
        (_) async => Right([
          providerConfig,
          githubProviderConfig.copyWith(isActive: false),
        ]),
      );
      return explorerBloc;
    },
    act: (bloc) => bloc.add(const ExplorerStarted(connectedUserId: 'u1')),
    wait: const Duration(milliseconds: 50),
    verify: (bloc) {
      expect(bloc.state.availableProviders, ['slack']);
      expect(bloc.state.selectedProviders, {'slack'});
      expect(bloc.state.availableActivityCategories, {
        ActivityCategory.message,
      });
      expect(bloc.state.selectedActivityCategories, {ActivityCategory.message});
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'preselects connected user on first load',
    build: () => explorerBloc,
    act: (bloc) => bloc.add(const ExplorerStarted(connectedUserId: 'u1')),
    wait: const Duration(milliseconds: 50),
    verify: (bloc) {
      expect(bloc.state.selectedUserIds, {'u1'});
      verify(
        () => mockActivityRepository.searchActivities(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          users: ['u1'],
          authoredOnly: true,
        ),
      ).called(1);
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'uses inclusive start/end dates in range mode',
    build: () => explorerBloc,
    act: (bloc) {
      bloc.add(const ExplorerStarted(connectedUserId: 'u1'));
      bloc.add(const ExplorerDateModeChanged(ExplorerDateMode.range));
      bloc.add(
        ExplorerDateRangeChanged(
          startDate: DateTime.utc(2026, 1, 1),
          endDate: DateTime.utc(2026, 1, 7),
        ),
      );
    },
    wait: const Duration(milliseconds: 100),
    verify: (_) {
      verify(
        () => mockActivityRepository.searchActivities(
          startDate: DateTime.utc(2026, 1, 1),
          endDate: DateTime.utc(2026, 1, 7),
          users: ['u1'],
          authoredOnly: true,
        ),
      ).called(1);
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'uses selected users only while in users directory',
    build: () => explorerBloc,
    act: (bloc) {
      bloc.add(const ExplorerStarted(connectedUserId: 'u1'));
      bloc.add(const ExplorerGroupToggled('g1'));
    },
    wait: const Duration(milliseconds: 100),
    verify: (_) {
      verify(
        () => mockActivityRepository.searchActivities(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          users: ['u1'],
          authoredOnly: true,
        ),
      ).called(2);
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'uses selected group members only while in groups directory',
    build: () => explorerBloc,
    act: (bloc) {
      bloc.add(const ExplorerStarted(connectedUserId: 'u1'));
      bloc.add(const ExplorerGroupToggled('g1'));
      bloc.add(const ExplorerDirectoryTypeChanged(DirectoryType.groups));
    },
    wait: const Duration(milliseconds: 100),
    verify: (_) {
      verify(
        () => mockActivityRepository.searchActivities(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          users: ['u1', 'u2'],
          authoredOnly: true,
        ),
      ).called(1);
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'returns empty when no selection exists in active directory',
    build: () => explorerBloc,
    act: (bloc) {
      bloc.add(const ExplorerStarted());
    },
    wait: const Duration(milliseconds: 50),
    verify: (_) {
      verifyNever(
        () => mockActivityRepository.searchActivities(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          users: any(named: 'users'),
          authoredOnly: any(named: 'authoredOnly'),
        ),
      );
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'filters activities by selected activity categories',
    build: () {
      when(
        () => mockActivityRepository.searchActivities(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          users: any(named: 'users'),
          authoredOnly: any(named: 'authoredOnly'),
        ),
      ).thenAnswer(
        (_) async => Right([
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
        ]),
      );
      return explorerBloc;
    },
    act: (bloc) {
      bloc.add(const ExplorerStarted(connectedUserId: 'u1'));
      bloc.add(const ExplorerActivityCategoryToggled(ActivityCategory.message));
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      final items = bloc.state.items.whereType<SingleActivityItem>().toList();
      expect(items, hasLength(1));
      expect(items.first.activity.provider.category, ActivityCategory.commit);
      expect(
        bloc.state.selectedActivityCategories.contains(
          ActivityCategory.message,
        ),
        isFalse,
      );
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'renames a group in state through saveGroup',
    build: () => explorerBloc,
    act: (bloc) {
      bloc.add(const ExplorerStarted(connectedUserId: 'u1'));
      bloc.add(const ExplorerGroupRenamed(groupId: 'g1', name: 'Core Team'));
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      expect(
        bloc.state.groups.firstWhere((g) => g.id == 'g1').name,
        'Core Team',
      );
      verify(() => mockUserRepository.saveGroup(any())).called(1);
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'deletes a group from state and selection',
    build: () => explorerBloc,
    act: (bloc) {
      bloc.add(const ExplorerStarted(connectedUserId: 'u1'));
      bloc.add(const ExplorerGroupToggled('g1'));
      bloc.add(const ExplorerDirectoryTypeChanged(DirectoryType.groups));
      bloc.add(const ExplorerGroupDeleted('g1'));
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      expect(bloc.state.groups.where((g) => g.id == 'g1'), isEmpty);
      expect(bloc.state.selectedGroupIds.contains('g1'), isFalse);
      verify(() => mockUserRepository.deleteGroup('g1')).called(1);
    },
  );

  blocTest<ExplorerBloc, ExplorerState>(
    'updates existing group members through ExplorerGroupSaved',
    build: () => explorerBloc,
    act: (bloc) {
      bloc.add(const ExplorerStarted(connectedUserId: 'u1'));
      bloc.add(ExplorerGroupSaved(devGroup.copyWith(members: const [alice])));
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      final updatedGroup = bloc.state.groups.firstWhere((g) => g.id == 'g1');
      expect(updatedGroup.members.map((m) => m.id).toList(), ['u1']);
      expect(bloc.state.groups.where((g) => g.id == 'g1').length, 1);
      verify(() => mockUserRepository.saveGroup(any())).called(greaterThan(0));
    },
  );
}
