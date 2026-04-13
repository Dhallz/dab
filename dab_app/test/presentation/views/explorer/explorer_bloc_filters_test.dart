import 'package:bloc_test/bloc_test.dart';
import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/group/group.dart';
import 'package:dab_app/domain/entities/group/group_type.dart';
import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/views/explorer/explorer_bloc.dart';
import 'package:dab_app/presentation/views/explorer/explorer_event.dart';
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
    ).thenAnswer((_) async => Right([providerConfig]));
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
  });

  tearDown(() async {
    await explorerBloc.close();
  });

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
}
