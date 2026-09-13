import 'package:dab_app/domain/containers/activity_usecases.dart';
import 'package:dab_app/domain/containers/metadata_usecases.dart';
import 'package:dab_app/domain/containers/system_usecases.dart';
import 'package:dab_app/domain/containers/user_usecases.dart';
import 'package:dab_app/domain/core/report_subject_key.dart';
import 'package:dab_app/domain/entities/activity/activity.dart';
import 'package:dab_app/domain/entities/activity/activity_search_query.dart';
import 'package:dab_app/domain/entities/user/daily_report.dart';
import 'package:dab_app/domain/entities/user/daily_report_line.dart';
import 'package:dab_app/domain/entities/user/follow_candidate.dart';
import 'package:dab_app/domain/entities/user/user.dart';
import 'package:dab_app/domain/entities/user/user_role.dart';
import 'package:dab_app/domain/repositories/abs_i_activity_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_provider_config_repository.dart';
import 'package:dab_app/domain/repositories/abs_i_user_repository.dart';
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
    ).thenAnswer((_) async => const Right(DailyReport(date: '2026-08-22')));
    when(
      () => userRepository.saveMyDailyReport(
        date: any(named: 'date'),
        includeFollowing: any(named: 'includeFollowing'),
        lines: any(named: 'lines'),
      ),
    ).thenAnswer((_) async => const Right(DailyReport(date: '2026-08-22')));
    when(
      () => userRepository.getUsers(),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => userRepository.listMyDailyReports(),
    ).thenAnswer((_) async => const Right(['2026-08-22']));
    when(
      () => userRepository.listUserDailyReports(userId: any(named: 'userId')),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => userRepository.listMyFollowCandidates(query: any(named: 'query')),
    ).thenAnswer((_) async => const Right([]));
    when(
      () => userRepository.getUserDailyReport(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer(
      (_) async => const Right(DailyReport(date: '2026-08-22', userId: 'u-2')),
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

  test('edits enable save and persist only on save', () async {
    final container = containerWith(createNotifier);
    addTearDown(container.dispose);
    container.listen(reportsNotifierProvider, (_, __) {});
    final notifier = container.read(reportsNotifierProvider.notifier);

    await notifier.started(connectedUserId: 'u-1');
    expect(container.read(reportsNotifierProvider).canSave, isFalse);

    final key = container.read(reportsNotifierProvider).lines.single.subjectKey;
    notifier.setLineIncluded(key, false);
    expect(container.read(reportsNotifierProvider).canSave, isTrue);
    verifyNever(
      () => userRepository.saveMyDailyReport(
        date: any(named: 'date'),
        includeFollowing: any(named: 'includeFollowing'),
        lines: any(named: 'lines'),
      ),
    );

    await notifier.save();
    verify(
      () => userRepository.saveMyDailyReport(
        date: '2026-08-22',
        includeFollowing: false,
        lines: any(named: 'lines'),
      ),
    ).called(1);
    expect(container.read(reportsNotifierProvider).canSave, isFalse);
    expect(container.read(reportsNotifierProvider).isDirty, isFalse);
  });

  test('search add keeps a non-today activity on today and persists', () async {
    final monday = Activity(
      id: 'linear-mon',
      userId: 'u-1',
      provider: const LinearIssueProvider(identifier: 'DAB-1'),
      title: 'Ship schema Monday',
      content: 'from Monday',
      authorName: 'Ada',
      commentCount: 0,
      createdAt: DateTime.utc(2026, 8, 17, 14),
    );
    when(() => activityRepository.searchActivities(any())).thenAnswer((
      invocation,
    ) async {
      final query = invocation.positionalArguments.first as ActivitySearchQuery;
      if ((query.text ?? '').isNotEmpty) {
        return Right([monday]);
      }
      return const Right([]);
    });

    final container = containerWith(createNotifier);
    addTearDown(container.dispose);
    container.listen(reportsNotifierProvider, (_, __) {});
    final notifier = container.read(reportsNotifierProvider.notifier);

    await notifier.started(connectedUserId: 'u-1');
    notifier.setSearchQuery('schema');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(
      container.read(reportsNotifierProvider).searchPickerVisible.single.title,
      'Ship schema Monday',
    );

    notifier.addFromSearch(monday);
    expect(
      container
          .read(reportsNotifierProvider)
          .lines
          .any((line) => line.title == 'Ship schema Monday'),
      isTrue,
    );
    expect(container.read(reportsNotifierProvider).canSave, isTrue);
    verifyNever(
      () => userRepository.saveMyDailyReport(
        date: any(named: 'date'),
        includeFollowing: any(named: 'includeFollowing'),
        lines: any(named: 'lines'),
      ),
    );

    await notifier.save();
    verify(
      () => userRepository.saveMyDailyReport(
        date: '2026-08-22',
        includeFollowing: false,
        lines: any(named: 'lines'),
      ),
    ).called(1);
    expect(container.read(reportsNotifierProvider).isDirty, isFalse);
  });

  test('search includes Phorge tasks from follow candidates', () async {
    when(
      () => userRepository.listMyFollowCandidates(query: any(named: 'query')),
    ).thenAnswer((invocation) async {
      final query = invocation.namedArguments[#query] as String? ?? '';
      if (query != 'login') return const Right([]);
      return const Right([
        FollowCandidate(
          providerId: 'phorge',
          objectKey: 'PHID-TASK-12',
          title: '[T12] Fix login',
          url: 'https://phorge.example.com/T12',
        ),
      ]);
    });

    final container = containerWith(createNotifier);
    addTearDown(container.dispose);
    container.listen(reportsNotifierProvider, (_, __) {});
    final notifier = container.read(reportsNotifierProvider.notifier);

    await notifier.started(connectedUserId: 'u-1');
    notifier.setSearchQuery('login');
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final hit = container
        .read(reportsNotifierProvider)
        .searchPickerVisible
        .single;
    expect(hit.title, '[T12] Fix login');
    expect(hit.reportProviderId, 'phorge');
  });

  test('manager can open a teammate report read-only without PUT', () async {
    const teammateLine = DailyReportLine(
      subjectKey: 'linear|DAB-9',
      title: 'Their task',
      included: true,
    );
    when(
      () => userRepository.getUserDailyReport(
        userId: 'u-2',
        date: any(named: 'date'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        DailyReport(date: '2026-08-22', userId: 'u-2', lines: [teammateLine]),
      ),
    );
    when(() => userRepository.getUsers()).thenAnswer(
      (_) async => const Right([
        User(id: 'u-1', name: 'Me', email: 'me@x.com'),
        User(id: 'u-2', name: 'Ada', email: 'ada@x.com'),
      ]),
    );
    when(
      () => userRepository.listUserDailyReports(userId: 'u-2'),
    ).thenAnswer((_) async => const Right(['2026-08-21']));

    final container = containerWith(createNotifier);
    addTearDown(container.dispose);
    container.listen(reportsNotifierProvider, (_, __) {});
    final notifier = container.read(reportsNotifierProvider.notifier);

    await notifier.started(connectedUserId: 'u-1', role: UserRole.manager);
    await notifier.selectUser('u-2');

    final state = container.read(reportsNotifierProvider);
    expect(state.isReadOnly, isTrue);
    expect(state.date, '2026-08-21');
    expect(state.availableDates, ['2026-08-21']);
    expect(state.lines.single.title, 'Their task');

    notifier.setLineIncluded('linear|DAB-9', false);
    notifier.setLineNote('linear|DAB-9', 'should not save');
    await notifier.save();

    verifyNever(
      () => userRepository.saveMyDailyReport(
        date: any(named: 'date'),
        includeFollowing: any(named: 'includeFollowing'),
        lines: any(named: 'lines'),
      ),
    );
  });

  test('own report list always includes today even when unsaved', () async {
    when(
      () => userRepository.listMyDailyReports(),
    ).thenAnswer((_) async => const Right(['2026-08-20']));

    final container = containerWith(createNotifier);
    addTearDown(container.dispose);
    container.listen(reportsNotifierProvider, (_, __) {});
    final notifier = container.read(reportsNotifierProvider.notifier);

    await notifier.started(connectedUserId: 'u-1');

    final state = container.read(reportsNotifierProvider);
    expect(state.date, '2026-08-22');
    expect(state.availableDates, ['2026-08-22', '2026-08-20']);
    expect(state.isReadOnly, isFalse);
  });

  test('own report is read-only after the Admin deadline', () async {
    final container = containerWith(
      () => ReportsNotifier(
        ActivityUseCases(activityRepository),
        UserUseCases(userRepository),
        now: () => DateTime.utc(2026, 8, 23),
      ),
    );
    addTearDown(container.dispose);
    container.listen(reportsNotifierProvider, (_, __) {});
    final notifier = container.read(reportsNotifierProvider.notifier);

    await notifier.started(connectedUserId: 'u-1');
    final state = container.read(reportsNotifierProvider);
    expect(state.isPastDeadline, isTrue);
    expect(state.isReadOnly, isTrue);
    expect(state.canSave, isFalse);

    notifier.setLineIncluded('x', false);
    await notifier.save();
    verifyNever(
      () => userRepository.saveMyDailyReport(
        date: any(named: 'date'),
        includeFollowing: any(named: 'includeFollowing'),
        lines: any(named: 'lines'),
      ),
    );
  });
}
