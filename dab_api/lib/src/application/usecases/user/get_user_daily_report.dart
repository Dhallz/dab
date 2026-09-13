import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/entities/user/user_role.dart';
import 'get_my_daily_report.dart';
import 'get_user_by_id.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Loads a user's daily report when the caller is self, manager, or admin.
/// CONTRACT: Standard users may only read their own report ([AuthFailure] otherwise).
/// Missing rows still return an empty draft (same as [GetMyDailyReport]).
class GetUserDailyReport {
  GetUserDailyReport(this._getMy, this._getUserById);

  final GetMyDailyReport _getMy;
  final GetUserById _getUserById;

  Future<Either<Failure, DailyReport>> execute({
    required String callerId,
    required String targetUserId,
    required String date,
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
    return _getMy.execute(userId: target, date: date);
  }
}
