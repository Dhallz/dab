import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/core/daily_report_date.dart';
import '../../../domain/core/daily_report_lock_policy.dart';
import '../../../domain/core/failures/failure.dart';
import '../../../domain/entities/user/daily_report.dart';
import '../../../domain/entities/user/daily_report_line.dart';
import '../../../domain/contracts/repositories/abs_i_daily_report_repository.dart';
import '../../../domain/contracts/repositories/abs_i_system_settings_repository.dart';

/// [ARCH: APPLICATION_USECASE]
/// ROLE: Upserts the caller's daily report and replaces curated lines.
/// CONSTRAINTS: Rejects writes after the Admin report deadline.
class SaveMyDailyReport {
  SaveMyDailyReport(
    this._reports,
    this._settings, {
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AbsIDailyReportRepository _reports;
  final AbsISystemSettingsRepository _settings;
  final DateTime Function() _now;
  static const _uuid = Uuid();

  Future<Either<Failure, DailyReport>> execute({
    required String userId,
    required String date,
    required bool includeFollowing,
    required List<DailyReportLine> lines,
  }) async {
    final day = parseDailyReportDate(date);
    if (day == null) {
      return const Left(
        ValidationFailure('Date must be YYYY-MM-DD'),
      );
    }
    final timezoneId = await loadOrgTimezoneId(_settings);
    final offsetRes = await _settings.getSetting(kDailyReportLockOffsetDaysKey);
    if (offsetRes.isLeft()) {
      return Left(offsetRes.getLeft().toNullable()!);
    }
    final timeRes = await _settings.getSetting(kDailyReportLockTimeKey);
    if (timeRes.isLeft()) {
      return Left(timeRes.getLeft().toNullable()!);
    }
    final policy = DailyReportLockPolicy.fromSettings(
      offsetDays: offsetRes.getOrElse((_) => null),
      time: timeRes.getOrElse((_) => null),
    );
    if (isDailyReportLocked(
      reportDate: day,
      orgTimezoneId: timezoneId,
      policy: policy,
      now: _now(),
    )) {
      return const Left(
        AuthFailure('This daily report can no longer be edited'),
      );
    }
    final deduped = <String, DailyReportLine>{};
    for (final line in lines) {
      final key = line.subjectKey.trim();
      if (key.isEmpty) {
        return const Left(
          ValidationFailure('Each report line must include a subjectKey'),
        );
      }
      deduped[key] = line.copyWith(
        subjectKey: key,
        note: _clip(line.note, 2000),
        title: _clip(line.title, 200),
        url: _clip(line.url, 500),
      );
    }
    final report = DailyReport(
      id: _uuid.v5(Namespace.url.value, 'day-report|$userId|$day'),
      userId: userId,
      date: day,
      includeFollowing: includeFollowing,
      lines: deduped.values.toList(),
    );
    return _reports.save(report);
  }
}

String? _clip(String? raw, int max) {
  final value = raw?.trim() ?? '';
  if (value.isEmpty) return null;
  if (value.length <= max) return value;
  return value.substring(0, max);
}
