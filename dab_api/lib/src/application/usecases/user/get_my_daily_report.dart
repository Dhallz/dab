import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/daily_report_date.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/contracts/repositories/abs_i_daily_report_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Loads the caller's daily report for an org-calendar day.
/// CONTRACT: Missing rows return an empty draft (200), never 404.
class GetMyDailyReport {
  GetMyDailyReport(this._reports);

  final AbsIDailyReportRepository _reports;
  static const _uuid = Uuid();

  Future<Either<Failure, DailyReport>> execute({
    required String userId,
    required String date,
  }) async {
    final day = parseDailyReportDate(date);
    if (day == null) {
      return const Left(
        ValidationFailure('Date must be YYYY-MM-DD'),
      );
    }
    final result = await _reports.findByUserAndDate(userId: userId, date: day);
    return result.map((saved) => saved ?? _emptyDraft(userId: userId, date: day));
  }

  DailyReport _emptyDraft({required String userId, required String date}) {
    return DailyReport(
      id: _uuid.v5(Namespace.url.value, 'day-report|$userId|$date'),
      userId: userId,
      date: date,
    );
  }
}
