import 'package:fpdart/fpdart.dart';

import '../../core/failures/failure.dart';
import '../../entities/user/daily_report.dart';

/// [ARCH: DOMAIN_INTERFACE]
/// ROLE: Persistence for per-user org-calendar daily reports.
abstract interface class AbsIDailyReportRepository {
  /// Loads the report for [userId] + [date], or null when none is saved.
  Future<Either<Failure, DailyReport?>> findByUserAndDate({
    required String userId,
    required String date,
  });

  /// Org-calendar dates (`YYYY-MM-DD`) with a saved report for [userId], newest first.
  Future<Either<Failure, List<String>>> listDatesByUser({
    required String userId,
  });

  /// Upserts the report header and replaces all lines for that row.
  Future<Either<Failure, DailyReport>> save(DailyReport report);
}
