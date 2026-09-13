import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads a teammate's (or the caller's) daily report for a day.
/// CONTRACT: Server returns 403 when a standard user reads someone else.
class GetUserDailyReport {
  final IUserRepository repository;

  GetUserDailyReport(this.repository);

  Future<Either<AppFailure, DailyReport>> execute({
    required String userId,
    required String date,
  }) => repository.getUserDailyReport(userId: userId, date: date);
}
