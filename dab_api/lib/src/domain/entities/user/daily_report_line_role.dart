import 'package:dart_mappable/dart_mappable.dart';

part 'daily_report_line_role.mapper.dart';

/// [ARCH: DOMAIN]
/// ROLE: How a daily-report line relates to the authoring user.
/// CONTRACT: [directed] is inbound, [authored] is something the user did,
/// [both] is the same occurrence in live Directed and authored search.
@MappableEnum()
enum DailyReportLineRole { directed, authored, both }

/// [ARCH: DOMAIN]
/// ROLE: Merge helpers for [DailyReportLineRole].
extension OnDailyReportLineRole on DailyReportLineRole {
  /// Combines two roles for the same subject key.
  DailyReportLineRole union(DailyReportLineRole other) {
    if (this == other) return this;
    return DailyReportLineRole.both;
  }

  /// Wire value stored on `daily_report_lines.role`.
  String get wireName => name;
}

/// Parses a stored role; unknown values are [DailyReportLineRole.directed].
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
