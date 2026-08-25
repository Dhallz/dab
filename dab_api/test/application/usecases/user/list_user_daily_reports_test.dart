import 'package:dab_api/src/application/usecases/user/get_user_by_id.dart';
import 'package:dab_api/src/application/usecases/user/list_my_daily_reports.dart';
import 'package:dab_api/src/application/usecases/user/list_user_daily_reports.dart';
import 'package:dab_api/src/domain/core/failures/failure.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_daily_report_repository.dart';
import 'package:dab_api/src/domain/contracts/repositories/abs_i_user_repository.dart';
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
  late ListMyDailyReports listMine;
  late ListUserDailyReports listUser;

  User caller({required UserRole role}) => User(
    id: 'caller',
    name: 'Caller',
    email: 'caller@example.com',
    role: role,
  );

  setUp(() {
    reports = _MockReports();
    users = _MockUsers();
    listMine = ListMyDailyReports(reports);
    listUser = ListUserDailyReports(reports, GetUserById(users));
    when(
      () => reports.listDatesByUser(userId: any(named: 'userId')),
    ).thenAnswer((_) async => const Right(['2026-08-22', '2026-08-21']));
  });

  test('lists the caller dates newest first', () async {
    final result = await listMine.execute(userId: 'caller');
    expect(result.getRight().toNullable(), ['2026-08-22', '2026-08-21']);
    verify(() => reports.listDatesByUser(userId: 'caller')).called(1);
  });

  test('self can list without a role lookup', () async {
    final result = await listUser.execute(
      callerId: 'caller',
      targetUserId: 'caller',
    );
    expect(result.getRight().toNullable(), ['2026-08-22', '2026-08-21']);
    verifyNever(() => users.getUser(any()));
  });

  test('manager can list another user', () async {
    when(() => users.getUser('caller')).thenAnswer(
      (_) async => Right(caller(role: UserRole.manager)),
    );
    final result = await listUser.execute(
      callerId: 'caller',
      targetUserId: 'teammate',
    );
    expect(result.isRight(), isTrue);
    verify(() => reports.listDatesByUser(userId: 'teammate')).called(1);
  });

  test('standard user cannot list another user', () async {
    when(() => users.getUser('caller')).thenAnswer(
      (_) async => Right(caller(role: UserRole.standard)),
    );
    final result = await listUser.execute(
      callerId: 'caller',
      targetUserId: 'teammate',
    );
    expect(result.getLeft().toNullable(), isA<AuthFailure>());
    verifyNever(
      () => reports.listDatesByUser(userId: any(named: 'userId')),
    );
  });
}
