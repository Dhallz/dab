import 'package:dab_api/src/application/usecases/user/get_my_daily_report.dart';
import 'package:dab_api/src/application/usecases/user/save_my_daily_report.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/entities/user/daily_report.dart';
import 'package:dab_api/src/domain/entities/user/daily_report_line.dart';
import 'package:dab_api/src/domain/entities/user/daily_report_line_role.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_daily_report_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockReports extends Mock implements AbsIDailyReportRepository {}

void main() {
  late _MockReports reports;
  late GetMyDailyReport get;
  late SaveMyDailyReport save;

  setUpAll(() {
    registerFallbackValue(
      const DailyReport(
        id: 'id',
        userId: 'u-1',
        date: '2026-08-22',
      ),
    );
  });

  setUp(() {
    reports = _MockReports();
    get = GetMyDailyReport(reports);
    save = SaveMyDailyReport(reports);
  });

  test('get returns an empty draft when no row exists', () async {
    when(
      () => reports.findByUserAndDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer((_) async => const Right(null));

    final result = await get.execute(userId: 'u-1', date: '2026-08-22');
    final report = result.getOrElse((_) => throw StateError('left'));
    expect(report.userId, 'u-1');
    expect(report.date, '2026-08-22');
    expect(report.lines, isEmpty);
    expect(report.includeFollowing, isFalse);
  });

  test('get rejects dates that are not YYYY-MM-DD', () async {
    final result = await get.execute(userId: 'u-1', date: '08/22/2026');
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
    verifyNever(
      () => reports.findByUserAndDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    );
  });

  test('save upserts one report per user and date and unique subject keys', () async {
    when(() => reports.save(any())).thenAnswer((invocation) async {
      return Right(invocation.positionalArguments.first as DailyReport);
    });

    final first = await save.execute(
      userId: 'u-1',
      date: '2026-08-22',
      includeFollowing: false,
      lines: const [
        DailyReportLine(
          subjectKey: 'github|acme/app|abc1234',
          role: DailyReportLineRole.authored,
          title: 'Fix login',
        ),
        DailyReportLine(
          subjectKey: ' github|acme/app|abc1234 ',
          included: false,
          note: 'keep last',
          role: DailyReportLineRole.directed,
        ),
      ],
    );
    final saved = first.getOrElse((_) => throw StateError('left'));
    expect(saved.date, '2026-08-22');
    expect(saved.lines, hasLength(1));
    expect(saved.lines.single.subjectKey, 'github|acme/app|abc1234');
    expect(saved.lines.single.included, isFalse);
    expect(saved.lines.single.note, 'keep last');

    final second = await save.execute(
      userId: 'u-1',
      date: '2026-08-22',
      includeFollowing: true,
      lines: const [],
    );
    final replaced = second.getOrElse((_) => throw StateError('left'));
    expect(replaced.includeFollowing, isTrue);
    expect(replaced.lines, isEmpty);
    expect(replaced.id, saved.id);

    verify(() => reports.save(any())).called(2);
  });

  test('save rejects empty subject keys', () async {
    final result = await save.execute(
      userId: 'u-1',
      date: '2026-08-22',
      includeFollowing: false,
      lines: const [DailyReportLine(subjectKey: '  ')],
    );
    expect(result.getLeft().toNullable(), isA<ValidationFailure>());
  });
}
