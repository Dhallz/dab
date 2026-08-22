import 'package:dart_mappable/dart_mappable.dart';

part 'daily_report_line_role.mapper.dart';

/// [ARCH: DOMAIN]
/// ROLE: How a daily-report line relates to the signed-in user.
@MappableEnum()
enum DailyReportLineRole { directed, authored, both }

/// [ARCH: DOMAIN]
/// ROLE: Merge helpers for [DailyReportLineRole].
extension OnDailyReportLineRole on DailyReportLineRole {
  DailyReportLineRole union(DailyReportLineRole other) {
    if (this == other) return this;
    return DailyReportLineRole.both;
  }
}

DailyReportLineRole dailyReportLineRoleFromWire(String? raw) {
  switch ((raw ?? '').trim().toLowerCase()) {
    case 'authored':
      return DailyReportLineRole.authored;
    case 'both':
      return DailyReportLineRole.both;
    default:
      return DailyReportLineRole.directed;
  }
}
