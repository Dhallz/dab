import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures/failure.dart';
import '../../../domain/contracts/repositories/abs_i_daily_report_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Lists org-calendar dates with a saved daily report for the caller.
class ListMyDailyReports {
  ListMyDailyReports(this._reports);

  final AbsIDailyReportRepository _reports;

  Future<Either<Failure, List<String>>> execute({
    required String userId,
  }) => _reports.listDatesByUser(userId: userId);
}
