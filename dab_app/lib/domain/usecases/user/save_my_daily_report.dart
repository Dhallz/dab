import 'package:fpdart/fpdart.dart';

import '../../../domain/core/failures.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/entities/user/daily_report_line.dart';
import '../../../domain/repositories/abs_i_user_repository.dart';

/// [ARCH: DOMAIN_USECASE]
/// ROLE: Persists the caller's curated daily report for a day.
class SaveMyDailyReport {
  final IUserRepository repository;

  SaveMyDailyReport(this.repository);

  Future<Either<AppFailure, DailyReport>> execute({
    required String date,
    required bool includeFollowing,
    required List<DailyReportLine> lines,
  }) => repository.saveMyDailyReport(
    date: date,
    includeFollowing: includeFollowing,
    lines: lines,
  );
}
