import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/system_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/entities/user/daily_report.dart';
import 'package:dab_app/domain/entities/user/daily_report_line.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
import 'package:dab_app/presentation/core/models/view_status.dart';
import 'package:dab_app/presentation/features/app/app_notifier.dart';
import 'package:dab_app/presentation/features/app/app_state.dart';
import 'package:dab_app/presentation/views/reports/reports_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class _MockActivityRepository extends Mock implements IActivityRepository {}

class _MockUserRepository extends Mock implements IUserRepository {}

class _MockProviderConfigRepository extends Mock
    implements IProviderConfigRepository {}

class _MockSystemUseCases extends Mock implements SystemUseCases {}

class _MockMetadataUseCases extends Mock implements MetadataUseCases {}

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
  late _MockActivityRepository activityRepository;
  late _MockUserRepository userRepository;

  final now = DateTime.utc(2026, 8, 22, 16);

  Activity slack() => Activity(
    id: 'a-1',
    userId: 'u-1',
    provider: const SlackMessageProvider(
      workspaceId: 'T1',
      channelId: 'C1',
      messageTs: '100.2',
    ),
    title: '@you in #schema',
    content: 'hello',
    authorName: 'Ada',
    commentCount: 0,
    createdAt: DateTime.utc(2026, 8, 22, 14, 5),
  );

  setUpAll(() {
    registerFallbackValue(const ActivitySearchQuery());
    registerFallbackValue(const <DailyReportLine>[]);
  });

  setUp(() {
    activityRepository = _MockActivityRepository();
    userRepository = _MockUserRepository();
    when(
      () => activityRepository.watchActivities(),
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => activityRepository.getLiveActivities(
        limit: any(named: 'limit'),
        global: any(named: 'global'),
        includeArchived: any(named: 'includeArchived'),
      ),
    ).thenAnswer((_) async => Right([slack()]));
    when(
      () => activityRepository.searchActivities(any()),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => userRepository.getMyDailyReport(date: any(named: 'date')),
    ).thenAnswer(
      (_) async => const Right(DailyReport(date: '2026-08-22')),
    );
    when(
      () => userRepository.saveMyDailyReport(
        date: any(named: 'date'),
        includeFollowing: any(named: 'includeFollowing'),
        lines: any(named: 'lines'),
      ),
    ).thenAnswer(
      (_) async => const Right(DailyReport(date: '2026-08-22')),
    );
  });

  ReportsNotifier createNotifier() => ReportsNotifier(
    ActivityUseCases(activityRepository),
    UserUseCases(userRepository),
    now: () => now,
  );

  ProviderContainer containerWith(ReportsNotifier Function() create) {
    return ProviderContainer(
      overrides: [
        reportsNotifierProvider.overrideWith(create),
        appNotifierProvider.overrideWith(_TestAppNotifier.new),
      ],
    );
  }

  test('debounced save persists include changes', () async {
    final container = containerWith(createNotifier);
    addTearDown(container.dispose);
    container.listen(reportsNotifierProvider, (_, __) {});
    final notifier = container.read(reportsNotifierProvider.notifier);

    await notifier.started('u-1');
    expect(container.read(reportsNotifierProvider).status, ViewStatus.success);
    expect(container.read(reportsNotifierProvider).lines, isNotEmpty);

    final key = container.read(reportsNotifierProvider).lines.single.subjectKey;
    notifier.setLineIncluded(key, false);
    await Future<void>.delayed(const Duration(milliseconds: 600));

    verify(
      () => userRepository.saveMyDailyReport(
        date: '2026-08-22',
        includeFollowing: false,
        lines: any(named: 'lines'),
      ),
    ).called(1);
    expect(
      container.read(reportsNotifierProvider).lines.single.included,
      isFalse,
    );
  });
}
