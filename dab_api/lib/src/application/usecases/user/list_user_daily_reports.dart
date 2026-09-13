import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/user_role.dart';
import '../../../domain/contracts/repositories/abs_i_daily_report_repository.dart';
import 'get_user_by_id.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists saved daily-report dates for a user when the caller may read them.
/// CONTRACT: Standard users may only list their own dates ([AuthFailure] otherwise).
class ListUserDailyReports {
  ListUserDailyReports(this._reports, this._getUserById);

  final AbsIDailyReportRepository _reports;
  final GetUserById _getUserById;

  Future<Either<Failure, List<String>>> execute({
    required String callerId,
    required String targetUserId,
  }) async {
    final target = targetUserId.trim();
    if (target.isEmpty) {
      return const Left(ValidationFailure('User id is required'));
    }
    if (target != callerId) {
      final callerResult = await _getUserById.execute(callerId);
      final caller = callerResult.getRight().toNullable();
      if (caller == null) {
        return const Left(AuthFailure('Forbidden'));
      }
      if (caller.role != UserRole.admin && caller.role != UserRole.manager) {
        return const Left(AuthFailure('Forbidden'));
      }
    }
    return _reports.listDatesByUser(userId: target);
  }
}
