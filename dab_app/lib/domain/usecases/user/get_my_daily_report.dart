import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Loads the caller's daily report for an org-calendar day.
class GetMyDailyReport {
  final IUserRepository repository;

  GetMyDailyReport(this.repository);

  Future<Either<AppFailure, DailyReport>> execute({required String date}) =>
      repository.getMyDailyReport(date: date);
}
