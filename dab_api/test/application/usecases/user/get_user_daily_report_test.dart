import 'package:dab_api/src/application/usecases/user/get_my_daily_report.dart';
import 'package:dab_api/src/application/usecases/user/get_user_by_id.dart';
import 'package:dab_api/src/application/usecases/user/get_user_daily_report.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_daily_report_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
import 'package:dab_api/src/domain/entities/user/daily_report.dart';
import 'package:dab_api/src/domain/entities/user/user.dart';
import 'package:dab_api/src/domain/entities/user/user_role.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class _MockReports extends Mock implements AbsIDailyReportRepository {}

class _MockUsers extends Mock implements IUserRepository {}

void main() {
  late _MockReports reports;
  late _MockUsers users;
  late GetUserDailyReport get;

  User caller({required UserRole role}) => User(
    id: 'caller',
    name: 'Caller',
    email: 'caller@example.com',
    role: role,
  );

  setUp(() {
    reports = _MockReports();
    users = _MockUsers();
    get = GetUserDailyReport(GetMyDailyReport(reports), GetUserById(users));
    when(
      () => reports.findByUserAndDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    ).thenAnswer(
      (_) async => const Right(
        DailyReport(
          id: 'r-1',
          userId: 'teammate',
          date: '2026-08-21',
        ),
      ),
    );
  });

  test('self can read without a role lookup', () async {
    final result = await get.execute(
      callerId: 'caller',
      targetUserId: 'caller',
      date: '2026-08-21',
    );
    expect(result.getRight().toNullable()?.userId, 'teammate');
    verifyNever(() => users.getUser(any()));
  });

  test('manager can read another user', () async {
    when(() => users.getUser('caller')).thenAnswer(
      (_) async => Right(caller(role: UserRole.manager)),
    );
    final result = await get.execute(
      callerId: 'caller',
      targetUserId: 'teammate',
      date: '2026-08-21',
    );
    expect(result.isRight(), isTrue);
  });

  test('admin can read another user', () async {
    when(() => users.getUser('caller')).thenAnswer(
      (_) async => Right(caller(role: UserRole.admin)),
    );
    final result = await get.execute(
      callerId: 'caller',
      targetUserId: 'teammate',
      date: '2026-08-21',
    );
    expect(result.isRight(), isTrue);
  });

  test('standard user cannot read another user', () async {
    when(() => users.getUser('caller')).thenAnswer(
      (_) async => Right(caller(role: UserRole.standard)),
    );
    final result = await get.execute(
      callerId: 'caller',
      targetUserId: 'teammate',
      date: '2026-08-21',
    );
    expect(result.getLeft().toNullable(), isA<AuthFailure>());
    verifyNever(
      () => reports.findByUserAndDate(
        userId: any(named: 'userId'),
        date: any(named: 'date'),
      ),
    );
  });
}
