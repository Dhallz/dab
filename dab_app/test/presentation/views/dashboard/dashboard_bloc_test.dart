import 'package:bloc_test/bloc_test.dart';
import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/upcoming_event_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_upcoming_events_repository.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_bloc.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_event.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockActivityRepository extends Mock implements IActivityRepository {}

class _MockUpcomingRepository extends Mock
    implements IUpcomingEventsRepository {}

void main() {
  late _MockActivityRepository repository;
  late _MockUpcomingRepository upcomingRepository;
  late DashboardBloc bloc;

  setUpAll(() {
    registerFallbackValue(const ActivitySearchQuery());
  });

  setUp(() {
    repository = _MockActivityRepository();
    upcomingRepository = _MockUpcomingRepository();
    final useCases = ActivityUseCases(repository);
    final upcomingUseCases = UpcomingEventUseCases(upcomingRepository);
    bloc = DashboardBloc(useCases, upcomingUseCases);
    when(
      () => repository.watchActivities(),
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => upcomingRepository.getUpcomingEvents(
        from: any(named: 'from'),
        to: any(named: 'to'),
      ),
    ).thenAnswer((_) async => const Right([]));
  });

  tearDown(() async {
    await bloc.close();
  });

  blocTest<DashboardBloc, DashboardState>(
    'loads live activities on start',
    build: () {
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
      return bloc;
    },
    act: (bloc) => bloc.add(const DashboardStarted()),
    wait: const Duration(milliseconds: 80),
    expect: () => [
      isA<DashboardState>().having(
        (s) => s.status,
        'status',
        ViewStatus.loading,
      ),
      isA<DashboardState>()
          .having((s) => s.status, 'status', ViewStatus.success)
          .having((s) => s.activities.length, 'activities length', 1),
    ],
  );

  // Regression: on app restart we must hydrate archived entries so the user's
  // triage state survives. They stay hidden by default (visibleActivities
  // filters them), and toggling 'Show archived' must reveal them *without*
  // issuing a second API call.
  blocTest<DashboardBloc, DashboardState>(
    'hydrates archived entries on start and reveals them via visibility toggle',
    build: () {
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
      return bloc;
    },
    act: (bloc) async {
      bloc.add(const DashboardStarted());
      await Future<void>.delayed(const Duration(milliseconds: 50));
      bloc.add(const DashboardArchivedVisibilityToggled());
    },
    wait: const Duration(milliseconds: 100),
    verify: (bloc) {
      expect(bloc.state.activities.length, 2);
      expect(
        bloc.state.activities.where((a) => a.archived).length,
        1,
        reason: 'archived flag must survive hydration',
      );
      expect(
        bloc.state.showArchivedActivities,
        true,
        reason: 'toggle must flip to show archived',
      );
      expect(
        bloc.state.visibleActivities.length,
        2,
        reason: 'archived entry must become visible after toggle',
      );

      // Exactly one hydration call; toggling must not trigger a refetch.
      verify(
        () => repository.getLiveActivities(
          limit: 50,
          global: false,
          includeArchived: true,
        ),
      ).called(1);
    },
  );
}
