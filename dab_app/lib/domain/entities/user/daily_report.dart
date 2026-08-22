import 'package:dart_mappable/dart_mappable.dart';

import 'daily_report_line.dart';

part 'daily_report.mapper.dart';

/// [ARCH: DOMAIN]
/// ROLE: One user's curated org-calendar daily report.
/// CONTRACT: Unique on ([userId], [date]) where [date] is `YYYY-MM-DD`.
@MappableClass()
class DailyReport with DailyReportMappable {
  final String userId;
  final String date;
  final bool includeFollowing;
  final List<DailyReportLine> lines;

  const DailyReport({
    this.userId = '',
    required this.date,
    this.includeFollowing = false,
    this.lines = const [],
  });

  factory DailyReport.empty({required String date, String userId = ''}) =>
      DailyReport(userId: userId, date: date);

  static DailyReport fromApiMap(Map<String, dynamic> map) {
    final rawLines = map['lines'];
    final lines = <DailyReportLine>[];
    if (rawLines is List) {
      for (final item in rawLines) {
        if (item is! Map) continue;
        lines.add(DailyReportLine.fromApiMap(Map<String, dynamic>.from(item)));
      }
    }
    return DailyReport(
      userId: (map['userId'] ?? '').toString(),
      date: (map['date'] ?? '').toString(),
      includeFollowing: map['includeFollowing'] == true,
      lines: lines,
    );
  }
}
