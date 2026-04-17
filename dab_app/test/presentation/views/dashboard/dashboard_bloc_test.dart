import 'package:bloc_test/bloc_test.dart';
import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_bloc.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_event.dart';
import 'package:dab_app/presentation/views/dashboard/dashboard_state.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockActivityRepository extends Mock implements IActivityRepository {}

void main() {
  late _MockActivityRepository repository;
  late DashboardBloc bloc;

  setUpAll(() {
    registerFallbackValue(const ActivitySearchQuery());
  });

  setUp(() {
    repository = _MockActivityRepository();
    final useCases = ActivityUseCases(repository);
    bloc = DashboardBloc(useCases);
    when(
      () => repository.watchActivities(),
    ).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() async {
    await bloc.close();
  });

  blocTest<DashboardBloc, DashboardState>(
    'loads live activities on start',
    build: () {
      when(
        () => repository.getLiveActivities(limit: 50, global: false),
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
}
