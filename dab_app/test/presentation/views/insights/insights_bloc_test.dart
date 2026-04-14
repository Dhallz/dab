import 'package:bloc_test/bloc_test.dart';
import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/entities/provider/provider_config.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/views/insights/insights_bloc.dart';
import 'package:dab_app/presentation/views/insights/insights_event.dart';
import 'package:dab_app/presentation/views/insights/insights_state.dart';
import 'package:dab_app/presentation/views/insights/models/insights_date_preset.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockActivityRepository extends Mock implements IActivityRepository {}

class MockUserRepository extends Mock implements IUserRepository {}

class MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

void main() {
  late InsightsBloc insightsBloc;
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

    insightsBloc = InsightsBloc(
      activityUseCases,
      userUseCases,
      metadataUseCases,
    );

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

  tearDown(() async {
    await insightsBloc.close();
  });

  blocTest<InsightsBloc, InsightsState>(
    'preselects connected user and queries by selected filters',
    build: () => insightsBloc,
    act: (bloc) => bloc.add(const InsightsStarted(connectedUserId: 'u1')),
    wait: const Duration(milliseconds: 80),
    verify: (bloc) {
      expect(bloc.state.selectedUserIds, {'u1'});
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
    },
  );

  blocTest<InsightsBloc, InsightsState>(
    'switches to last 30 days preset',
    build: () => insightsBloc,
    act: (bloc) {
      bloc.add(const InsightsStarted(connectedUserId: 'u1'));
      bloc.add(const InsightsDatePresetChanged(InsightsDatePreset.last30Days));
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      expect(bloc.state.datePreset, InsightsDatePreset.last30Days);
      final dayDiff = bloc.state.endDate
          .difference(bloc.state.startDate)
          .inDays;
      expect(dayDiff, 29);
    },
  );

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

    insightsBloc.add(const InsightsStarted());
    await Future<void>.delayed(const Duration(milliseconds: 80));

    expect(insightsBloc.state.totalActivities, 2);
    expect(insightsBloc.state.activeUsersCount, 2);
    expect(insightsBloc.state.activeProvidersCount, 2);
    expect(insightsBloc.state.mostFrequentCategory, isNotNull);
  });
}
